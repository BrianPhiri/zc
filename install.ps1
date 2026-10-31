<#
.SYNOPSIS  Install zc (the ZedCloud CLI) on Windows. No admin rights needed.
.EXAMPLE   irm https://raw.githubusercontent.com/BrianPhiri/zc/main/install.ps1 -OutFile install.ps1; .\install.ps1
.EXAMPLE   .\install.ps1 -Version 0.1.0 -InstallDir C:\tools\zc -AddToPath
.NOTES     -AddToPath edits the USER PATH only when passed. ZC_RELEASE_REPO / ZC_RELEASE_BASE work as in install.sh.
#>
[CmdletBinding()]
param(
  [string]$Version = $env:ZC_VERSION,
  [string]$InstallDir = $(if ($env:ZC_INSTALL_DIR) { $env:ZC_INSTALL_DIR } else { Join-Path $env:LOCALAPPDATA 'zc\bin' }),
  [switch]$AddToPath
)
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'
[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12

function Install-Zc {
  $repo = if ($env:ZC_RELEASE_REPO) { $env:ZC_RELEASE_REPO } else { 'BrianPhiri/zc' }
  $Version = $Version -replace '^v', ''
  $archRaw = if ($env:PROCESSOR_ARCHITEW6432) { $env:PROCESSOR_ARCHITEW6432 } else { $env:PROCESSOR_ARCHITECTURE }
  switch ($archRaw) {
    'AMD64' { $arch = 'amd64' }
    'ARM64' { $arch = 'arm64' }
    default { throw "unsupported architecture '$archRaw' (need AMD64 or ARM64)" }
  }
  if ($env:ZC_RELEASE_BASE) { $base = $env:ZC_RELEASE_BASE.TrimEnd('/') }
  elseif ($Version) { $base = "https://github.com/$repo/releases/download/v$Version" }
  else { $base = "https://github.com/$repo/releases/latest/download" }

  $tmp = Join-Path ([IO.Path]::GetTempPath()) ("zc-install-" + [Guid]::NewGuid().ToString('N'))
  New-Item -ItemType Directory -Path $tmp | Out-Null
  try {
    $sumsFile = Join-Path $tmp 'SHA256SUMS'
    Invoke-WebRequest -UseBasicParsing -Uri "$base/SHA256SUMS" -OutFile $sumsFile
    $lines = Get-Content -LiteralPath $sumsFile | ForEach-Object { $p = $_ -split '\s+', 2; if ($p.Count -eq 2) { [pscustomobject]@{ Hash = $p[0]; Name = $p[1].TrimStart('*') } } }
    if ($Version) { $name = "zc_${Version}_windows_$arch.zip" }
    else {
      $m = @($lines | Where-Object { $_.Name -like "zc_*_windows_$arch.zip" })
      if ($m.Count -ne 1) { throw "cannot pick a single windows/$arch archive from SHA256SUMS" }
      $name = $m[0].Name
    }
    $entry = @($lines | Where-Object { $_.Name -eq $name })
    if ($entry.Count -ne 1) { throw "no checksum for $name in SHA256SUMS; refusing to install" }

    Write-Host "downloading $name"
    $zip = Join-Path $tmp $name
    Invoke-WebRequest -UseBasicParsing -Uri "$base/$name" -OutFile $zip
    $got = (Get-FileHash -Algorithm SHA256 -LiteralPath $zip).Hash.ToLowerInvariant()
    if ($got -ne $entry[0].Hash.ToLowerInvariant()) { throw "checksum mismatch for $name (expected $($entry[0].Hash), got $got); nothing installed" }

    $x = Join-Path $tmp 'x'
    Expand-Archive -LiteralPath $zip -DestinationPath $x
    if (-not (Test-Path -LiteralPath (Join-Path $x 'zc.exe'))) { throw 'archive has no zc.exe' }

    New-Item -ItemType Directory -Force -Path $InstallDir | Out-Null
    $new = Join-Path $InstallDir ("zc.exe.new." + $PID)
    Copy-Item -LiteralPath (Join-Path $x 'zc.exe') -Destination $new
    Move-Item -Force -LiteralPath $new -Destination (Join-Path $InstallDir 'zc.exe')
    Write-Host "installed: $(Join-Path $InstallDir 'zc.exe')"
    & (Join-Path $InstallDir 'zc.exe') version | Select-Object -First 1

    $userPath = [string][Environment]::GetEnvironmentVariable('Path', 'User')
    $onPath = @(($userPath -split ';') | Where-Object { $_ -ieq $InstallDir }).Count -gt 0
    if ($AddToPath -and -not $onPath) {
      [Environment]::SetEnvironmentVariable('Path', (($userPath.TrimEnd(';') + ';' + $InstallDir).TrimStart(';')), 'User')
      Write-Host "added $InstallDir to your user PATH; open a new terminal"
    } elseif (-not $onPath) {
      Write-Host "note: $InstallDir is not on your PATH. Re-run with -AddToPath, or add it yourself."
    }
  } finally {
    Remove-Item -Recurse -Force -LiteralPath $tmp -ErrorAction SilentlyContinue
  }
}
Install-Zc
