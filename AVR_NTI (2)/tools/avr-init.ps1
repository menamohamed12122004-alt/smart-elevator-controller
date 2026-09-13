# Author: Ahmed Ellamie
# Email:  ahmed.ellamiee@gmail.com
#
# /AVRINIT — check the machine, install AVR-GCC on C:\ if missing,
# add it to PATH, write a project-wide Makefile, then build and verify.

[CmdletBinding()]
param(
    [string]$ProjectRoot = "",
    [string]$InstallDir = "C:\avr-gcc",
    [switch]$ForceInstall
)

$ErrorActionPreference = "Stop"
$ToolchainUrl = "https://github.com/ZakKemble/avr-gcc-build/releases/download/v15.2.0-1/avr-gcc-15.2.0-x64-windows.zip"

function Write-Step([string]$Message) { Write-Host "[AVRINIT] $Message" }

function Get-ProjectRoot {
    if ($ProjectRoot -and (Test-Path $ProjectRoot)) {
        return (Resolve-Path $ProjectRoot).Path
    }
    $scriptRoot = Split-Path -Parent $PSScriptRoot
    if (Test-Path (Join-Path $scriptRoot "main.c")) { return $scriptRoot }

    $here = (Get-Location).Path
    $named = Join-Path $here "05_Code\AVR\AVR_NTI"
    if (Test-Path (Join-Path $named "main.c")) { return $named }
    if ((Test-Path (Join-Path $here "MCAL")) -and (Test-Path (Join-Path $here "main.c"))) { return $here }
    return $scriptRoot
}

function Test-Tool([string]$Name) {
    $cmd = Get-Command $Name -ErrorAction SilentlyContinue
    if ($cmd) { return $cmd.Source }
    return $null
}

function Find-AvrBin {
    $fromPath = Test-Tool "avr-gcc"
    if ($fromPath) { return (Split-Path -Parent $fromPath) }

    $candidates = @(
        (Join-Path $InstallDir "bin"),
        "C:\avr-gcc\bin",
        "C:\WinAVR-20100110\bin"
    )
    foreach ($bin in $candidates) {
        if (Test-Path (Join-Path $bin "avr-gcc.exe")) { return $bin }
    }
    return $null
}

function Find-MakeBin {
    $fromPath = Test-Tool "make"
    if ($fromPath) { return (Split-Path -Parent $fromPath) }

    $candidates = @(
        (Join-Path $InstallDir "bin"),
        "C:\avr-gcc\bin",
        "C:\WinAVR-20100110\utils\bin",
        "C:\ProgramData\chocolatey\bin",
        "C:\MinGW\bin"
    )
    foreach ($bin in $candidates) {
        if (Test-Path (Join-Path $bin "make.exe")) { return $bin }
        if (Test-Path (Join-Path $bin "mingw32-make.exe")) { return $bin }
    }
    return $null
}

function Add-UserPath([string]$BinDir) {
    if (-not $BinDir -or -not (Test-Path $BinDir)) { return }
    $userPath = [Environment]::GetEnvironmentVariable("Path", "User")
    if (-not $userPath) { $userPath = "" }
    $parts = $userPath.Split(";") | Where-Object { $_ }
    if ($parts -notcontains $BinDir) {
        $newPath = if ($userPath) { "$userPath;$BinDir" } else { $BinDir }
        [Environment]::SetEnvironmentVariable("Path", $newPath, "User")
        Write-Step "Added to user PATH: $BinDir"
    }
    if ($env:Path -notlike "*$BinDir*") {
        $env:Path = "$BinDir;$env:Path"
    }
}

function Install-AvrToolchain {
    Write-Step "AVR toolchain not found. Installing to $InstallDir"
    $zip = Join-Path $env:TEMP "avr-gcc-windows.zip"
    Write-Step "Downloading AVR-GCC 15.2.0 (this can take several minutes)..."
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    Invoke-WebRequest -Uri $ToolchainUrl -OutFile $zip -UseBasicParsing

    $extract = Join-Path $env:TEMP "avr-gcc-extract"
    if (Test-Path $extract) { Remove-Item $extract -Recurse -Force }
    Expand-Archive -Path $zip -DestinationPath $extract -Force

    $inner = Get-ChildItem $extract | Where-Object { $_.PSIsContainer } | Select-Object -First 1
    $source = if ($inner -and (Test-Path (Join-Path $inner.FullName "bin\avr-gcc.exe"))) { $inner.FullName } else { $extract }

    New-Item -ItemType Directory -Force -Path $InstallDir | Out-Null
    Copy-Item -Path (Join-Path $source "*") -Destination $InstallDir -Recurse -Force
    Write-Step "Installed AVR-GCC to $InstallDir"
}

function Ensure-LayeredProject([string]$Root) {
    foreach ($dir in @("LIB", "MCAL", "HAL", "Logic", "tools", ".vscode")) {
        New-Item -ItemType Directory -Force -Path (Join-Path $Root $dir) | Out-Null
    }
    $main = Join-Path $Root "main.c"
    if (-not (Test-Path $main)) {
        throw "main.c is missing in $Root"
    }
}

# ---- run ----
Write-Step "System check"
Write-Step ("OS   : " + [System.Environment]::OSVersion.VersionString)
Write-Step ("Arch : " + $env:PROCESSOR_ARCHITECTURE)
Write-Step ("User : " + $env:USERNAME)

$root = Get-ProjectRoot
Write-Step "Project: $root"
Ensure-LayeredProject $root

$avrBin = Find-AvrBin
if (-not $avrBin -or $ForceInstall) {
    Install-AvrToolchain
    $avrBin = Join-Path $InstallDir "bin"
    if (-not (Test-Path (Join-Path $avrBin "avr-gcc.exe"))) {
        throw "Install finished but avr-gcc.exe was not found in $avrBin"
    }
}
else {
    Write-Step "AVR toolchain found: $avrBin"
}

$makeBin = Find-MakeBin
if (-not $makeBin) {
    throw "make.exe was not found. Re-run /AVRINIT or install GNU make."
}

Add-UserPath $avrBin
Add-UserPath $makeBin

$gcc = Get-Command avr-gcc -ErrorAction Stop
$obj = Get-Command avr-objcopy -ErrorAction Stop
$make = Get-Command make -ErrorAction SilentlyContinue
if (-not $make) { $make = Get-Command mingw32-make -ErrorAction Stop }

Write-Step ("avr-gcc    : " + $gcc.Source)
Write-Step ("avr-objcopy: " + $obj.Source)
Write-Step ("make       : " + $make.Source)
& $gcc.Source --version | Select-Object -First 1

$makefileTemplate = Join-Path $PSScriptRoot "Makefile.template"
$makefile = Join-Path $root "Makefile"
if (Test-Path $makefileTemplate) {
    Copy-Item $makefileTemplate $makefile -Force
    Write-Step "Wrote Makefile that searches LIB, MCAL, HAL, Logic, and nested folders"
}
elseif (-not (Test-Path $makefile)) {
    throw "Makefile.template missing and no Makefile exists in $root"
}

Write-Step "Building project to verify the toolchain"
Push-Location $root
try {
    & $make.Source clean
    & $make.Source all
    if ($LASTEXITCODE -ne 0) { throw "make failed with exit code $LASTEXITCODE" }
}
finally {
    Pop-Location
}

$hex = Join-Path $root "build\program.hex"
$bin = Join-Path $root "build\program.bin"
if (-not (Test-Path $hex) -or -not (Test-Path $bin)) {
    throw "Build finished but program.hex or program.bin is missing"
}

Write-Step "OK — HEX: $hex"
Write-Step "OK — BIN: $bin"
Write-Step "AVRINIT complete. Restart VS Code / Cursor once if a new PATH entry was added."
exit 0
