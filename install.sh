#!/bin/sh
# zc installer. Usage: curl -fsSL https://raw.githubusercontent.com/BrianPhiri/zc/main/install.sh | sh
#   sh install.sh [--version X.Y.Z] [--dir DIR] [--dry-run] [--help]
# Env: ZC_VERSION, ZC_INSTALL_DIR (default ~/.local/bin), ZC_RELEASE_REPO (default BrianPhiri/zc),
#      ZC_RELEASE_BASE (directory URL holding the archives + SHA256SUMS; for mirrors and tests).
#      ZC_UNAME_S / ZC_UNAME_M: test-only overrides of uname output.
# Never uses sudo, never edits shell rc files. All logic is in main(), called on the last line,
# so a truncated download does nothing.
set -eu

say() { printf '%s\n' "$*"; }
die() { printf 'zc install: %s\n' "$*" >&2; exit 1; }

fetch() { # url dest
  if command -v curl >/dev/null 2>&1; then curl -fsSL -o "$2" "$1" || die "download failed: $1"
  elif command -v wget >/dev/null 2>&1; then wget -q -O "$2" "$1" || die "download failed: $1"
  else die "need curl or wget"; fi
}

sha256_of() {
  if command -v sha256sum >/dev/null 2>&1; then sha256sum "$1" | cut -d' ' -f1
  elif command -v shasum >/dev/null 2>&1; then shasum -a 256 "$1" | cut -d' ' -f1
  else die "need sha256sum or shasum to verify the download"; fi
}

main() {
  repo=${ZC_RELEASE_REPO:-BrianPhiri/zc}
  ver=${ZC_VERSION:-}
  dir=${ZC_INSTALL_DIR:-}
  dry=0
  while [ $# -gt 0 ]; do
    case $1 in
      --version) [ $# -ge 2 ] || die "--version needs a value"; ver=$2; shift 2 ;;
      --dir) [ $# -ge 2 ] || die "--dir needs a value"; dir=$2; shift 2 ;;
      --dry-run) dry=1; shift ;;
      -h|--help) sed -n 2,8p "$0" 2>/dev/null || say "see https://github.com/$repo"; return 0 ;;
      *) die "unknown option: $1 (try --help)" ;;
    esac
  done
  ver=${ver#v}
  [ -n "$dir" ] || { [ -n "${HOME:-}" ] || die "HOME is not set; pass --dir"; dir=$HOME/.local/bin; }

  s=${ZC_UNAME_S:-$(uname -s)}; m=${ZC_UNAME_M:-$(uname -m)}
  case $s in
    Darwin) os=darwin ;;
    Linux) os=linux ;;
    *) die "unsupported OS '$s'. On Windows use install.ps1 (PowerShell); other systems are not built." ;;
  esac
  case $m in
    x86_64|amd64) arch=amd64 ;;
    aarch64|arm64) arch=arm64 ;;
    *) die "unsupported architecture '$m' (need amd64 or arm64)" ;;
  esac

  if [ -n "${ZC_RELEASE_BASE:-}" ]; then base=${ZC_RELEASE_BASE%/}
  elif [ -n "$ver" ]; then base=https://github.com/$repo/releases/download/v$ver
  else base=https://github.com/$repo/releases/latest/download; fi

  if [ "$dry" = 1 ]; then
    say "would download $base/SHA256SUMS"
    if [ -n "$ver" ]; then say "would download $base/zc_${ver}_${os}_${arch}.tar.gz"
    else say "would download the zc_*_${os}_${arch}.tar.gz listed in SHA256SUMS"; fi
    say "would verify its SHA256 and install zc to $dir/zc"
    return 0
  fi

  tmp=$(mktemp -d "${TMPDIR:-/tmp}/zc-install.XXXXXX") || die "cannot create a temp dir"
  trap 'rm -rf "$tmp"' EXIT INT TERM HUP

  fetch "$base/SHA256SUMS" "$tmp/SHA256SUMS"
  if [ -n "$ver" ]; then name=zc_${ver}_${os}_${arch}.tar.gz
  else
    name=$(awk -v suf="_${os}_${arch}.tar.gz" '$2 ~ /^zc_/ && substr($2, length($2)-length(suf)+1)==suf {print $2}' "$tmp/SHA256SUMS")
    case $name in ''|*"
"*) die "cannot pick a single $os/$arch archive from SHA256SUMS" ;; esac
  fi
  want=$(awk -v f="$name" '$2==f {print $1}' "$tmp/SHA256SUMS")
  [ -n "$want" ] || die "no checksum for $name in SHA256SUMS; refusing to install"

  say "downloading $name"
  fetch "$base/$name" "$tmp/$name"
  got=$(sha256_of "$tmp/$name")
  [ "$got" = "$want" ] || die "checksum mismatch for $name (expected $want, got $got); nothing installed"

  mkdir "$tmp/x"
  tar -xzf "$tmp/$name" -C "$tmp/x" || die "cannot extract $name"
  [ -f "$tmp/x/zc" ] || die "archive has no zc binary"

  mkdir -p "$dir" || die "cannot create $dir"
  cp "$tmp/x/zc" "$dir/.zc.new.$$" || die "cannot write to $dir"
  chmod 755 "$dir/.zc.new.$$"
  mv -f "$dir/.zc.new.$$" "$dir/zc" || { rm -f "$dir/.zc.new.$$"; die "cannot replace $dir/zc"; }

  say "installed: $dir/zc"
  "$dir/zc" version | head -n 1
  case ":$PATH:" in
    *":$dir:"*) ;;
    *) say "note: $dir is not on your PATH. Add it, e.g.: export PATH=\"$dir:\$PATH\"" ;;
  esac
}

main "$@"
