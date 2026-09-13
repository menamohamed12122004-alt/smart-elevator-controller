# Author: Ahmed Ellamie
# Email:  ahmed.ellamiee@gmail.com
#
# /build — check the AVR_NTI sources and toolchain, repair the Makefile
# if it is broken, then build the project to verify.

[CmdletBinding()]
param(
    [string]$ProjectRoot = ""
)

$ErrorActionPreference = "Stop"

function Write-Step([string]$Message) { Write-Host "[BUILD] $Message" }

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
    return [bool](Get-Command $Name -ErrorAction SilentlyContinue)
}

function Add-SessionPath([string]$BinDir) {
    if ($BinDir -and (Test-Path $BinDir) -and ($env:Path -notlike "*$BinDir*")) {
        $env:Path = "$BinDir;$env:Path"
    }
}

$root = Get-ProjectRoot
Write-Step "Project: $root"

$required = @(
    "main.c",
    "LIB",
    "MCAL",
    "HAL",
    "Logic"
)
$missing = @()
foreach ($item in $required) {
    if (-not (Test-Path (Join-Path $root $item))) { $missing += $item }
}
if ($missing.Count -gt 0) {
    throw "Missing project files/folders: $($missing -join ', '). Run /AVRINIT first."
}

$cFiles = Get-ChildItem -Path $root -Recurse -Filter *.c |
    Where-Object { $_.FullName -notmatch '\\build\\' }
if ($cFiles.Count -lt 1) {
    throw "No .c files found under $root"
}
$sourceNames = @($cFiles | ForEach-Object { $_.FullName.Substring($root.Length + 1) })
Write-Step ("C sources : " + ($sourceNames -join ", "))

Add-SessionPath "C:\avr-gcc\bin"
Add-SessionPath "C:\WinAVR-20100110\bin"
Add-SessionPath "C:\WinAVR-20100110\utils\bin"
Add-SessionPath "C:\ProgramData\chocolatey\bin"
Add-SessionPath "C:\MinGW\bin"

if (-not (Test-Tool "avr-gcc") -or -not (Test-Tool "avr-objcopy")) {
    throw "AVR toolchain is missing. Run /AVRINIT to install it on C:\avr-gcc and add it to PATH."
}
$make = Get-Command make -ErrorAction SilentlyContinue
if (-not $make) { $make = Get-Command mingw32-make -ErrorAction SilentlyContinue }
if (-not $make) {
    throw "make is missing. Run /AVRINIT to add GNU make to PATH."
}

Write-Step ("avr-gcc : " + (Get-Command avr-gcc).Source)
Write-Step ("make    : " + $make.Source)

$makefile = Join-Path $root "Makefile"
$template = Join-Path $PSScriptRoot "Makefile.template"
$needsFix = $false
if (-not (Test-Path $makefile)) {
    Write-Step "Makefile is missing"
    $needsFix = $true
}
else {
    $text = Get-Content $makefile -Raw
    $requiredTokens = @("avr-gcc", "avr-objcopy", "wildcard *.c", "LIB", "MCAL", "HAL", "Logic", "program.hex", "program.bin")
    $missingTokens = @($requiredTokens | Where-Object { $text -notmatch [regex]::Escape($_) })
    if ($missingTokens.Count -gt 0) {
        Write-Step ("Makefile is incomplete: " + ($missingTokens -join ", "))
        $needsFix = $true
    }
    if ($text -match "(?m)^[ ]+(avr-gcc|avr-objcopy|@echo|mkdir)") {
        Write-Step "Makefile recipes use spaces instead of tabs"
        $needsFix = $true
    }
}

if ($needsFix) {
    if (-not (Test-Path $template)) {
        throw "Cannot repair Makefile: tools/Makefile.template is missing. Run /AVRINIT."
    }
    Copy-Item $template $makefile -Force
    Write-Step "Makefile repaired from tools/Makefile.template"
}
else {
    Write-Step "Makefile looks valid"
}

Write-Step "Building"
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
    throw "Build did not produce build/program.hex and build/program.bin"
}

Write-Step "OK — HEX: $hex"
Write-Step "OK — BIN: $bin"
Write-Step "Build verified."
exit 0
