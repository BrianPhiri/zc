# zc

`zc` is the command line for ZedCloud: describe, stage and diagnose deployments from a terminal or an AI agent. This repository holds only release binaries, the installers and the Homebrew formula. It contains no source.

## Install

### Linux

```sh
curl -fsSL https://raw.githubusercontent.com/BrianPhiri/zc/main/install.sh | sh
```

Installs to `~/.local/bin` (no sudo). Options: `--version 0.1.0`, `--dir /some/dir`, `--dry-run`. The installer verifies the SHA256 of the download and aborts on a mismatch.

### macOS

The same curl installer works, or use Homebrew:

```sh
brew tap BrianPhiri/zc https://github.com/BrianPhiri/zc
brew install BrianPhiri/zc/zc
```

### Windows (PowerShell)

```powershell
irm https://raw.githubusercontent.com/BrianPhiri/zc/main/install.ps1 -OutFile install.ps1
.\install.ps1 -AddToPath
```

Installs to `%LOCALAPPDATA%\zc\bin`, no admin needed. `-AddToPath` edits only your user PATH.

## Use

```sh
export ZC_TOKEN=<personal access token from Settings > Developer>
zc version
zc --help
```

## Upgrade

Re-run the installer, or `brew upgrade zc`.

## Verify by hand

Download an archive and `SHA256SUMS` from the release, then:

```sh
shasum -a 256 -c --ignore-missing SHA256SUMS      # macOS
sha256sum -c --ignore-missing SHA256SUMS          # Linux
```

Releases are not signed yet; the checksums only protect against corrupted or swapped downloads from a mirror, not against a compromised release page. Signing is planned.
