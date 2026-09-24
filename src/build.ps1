<#
  build.ps1 - build nse_proxy.c into a 32-bit dinput8.dll for Napoleon.

  Napoleon.exe is 32-bit (PE machine 0x014C), so the DLL must be too. A 64-bit
  build loads silently as nothing at all: the game starts, no log appears, and
  there is nothing to tell you why. That is why the checks at the bottom of this
  script are not optional.

  Toolchains, in the order this script prefers them. Zig is recommended: one
  portable zip, no installer, no admin rights, and it cross-compiles to 32-bit
  Windows out of the box.

    Zig         https://ziglang.org/download/   (unzip anywhere)
    w64devkit   https://github.com/skeeto/w64devkit/releases  (portable MinGW)
    MSVC        Visual Studio Build Tools, "C++ build tools" workload

  Usage:
    .\build.ps1                 build to .\dinput8.dll
    .\build.ps1 -Deploy         build, then install into the game folder
    .\build.ps1 -Zig <path>     use a specific zig.exe
#>
param(
    [switch]$Deploy,
    [string]$Zig,
    [string]$Game
)

$ErrorActionPreference = "Stop"
$here    = Split-Path -Parent $MyInvocation.MyCommand.Path
$src     = Join-Path $here "nse_proxy.c"
$def     = Join-Path $here "nse.def"
$bin     = Join-Path $here "..\bin"
if (-not (Test-Path $bin)) { New-Item -ItemType Directory -Force $bin | Out-Null }
$out     = Join-Path (Resolve-Path $bin).Path "dinput8.dll"
# Find the game. Same order as tools/nse_locate.rb, so the two agree:
#   1. -Game
#   2. $env:NSE_GAME
#   3. ..\.. from src\  (this project unpacked inside the game folder - usual)
#   4. Steam app 34030, via libraryfolders.vdf
function Find-GameDir {
    if ($Game -and (Test-Path (Join-Path $Game "Napoleon.exe"))) { return $Game }
    if ($env:NSE_GAME -and (Test-Path (Join-Path $env:NSE_GAME "Napoleon.exe"))) { return $env:NSE_GAME }

    $rel = (Resolve-Path (Join-Path $here "..\..") -ErrorAction SilentlyContinue).Path
    if ($rel -and (Test-Path (Join-Path $rel "Napoleon.exe"))) { return $rel }

    # Steam's own install path, then every library it knows about.
    $steamRoots = @()
    foreach ($k in @('HKCU:\Software\Valve\Steam','HKLM:\SOFTWARE\WOW6432Node\Valve\Steam')) {
        try {
            $p = (Get-ItemProperty -Path $k -ErrorAction Stop)
            if ($p.SteamPath)   { $steamRoots += $p.SteamPath }
            if ($p.InstallPath) { $steamRoots += $p.InstallPath }
        } catch { }
    }
    $steamRoots += 'C:\Program Files (x86)\Steam'
    $libs = @()
    foreach ($r in ($steamRoots | Select-Object -Unique)) {
        if (-not (Test-Path $r)) { continue }
        $libs += $r
        foreach ($vdf in @("$r\steamapps\libraryfolders.vdf", "$r\config\libraryfolders.vdf")) {
            if (-not (Test-Path $vdf)) { continue }
            # Scrape quoted absolute paths: the vdf schema changed between Steam
            # versions and this handles both shapes without a real parser.
            foreach ($m in ([regex]'"((?:[A-Za-z]:|/)[^"]+)"').Matches((Get-Content $vdf -Raw))) {
                $libs += $m.Groups[1].Value -replace '\\\\','\'
            }
        }
    }
    foreach ($lib in ($libs | Select-Object -Unique)) {
        $dir = "Napoleon Total War"
        $manifest = Join-Path $lib "steamapps\appmanifest_34030.acf"
        if (Test-Path $manifest) {
            $mm = [regex]::Match((Get-Content $manifest -Raw), '"installdir"\s+"([^"]+)"')
            if ($mm.Success) { $dir = $mm.Groups[1].Value }
        }
        $cand = Join-Path $lib "steamapps\common\$dir"
        if (Test-Path (Join-Path $cand "Napoleon.exe")) { return $cand }
    }
    return $null
}

$gameDir = Find-GameDir
if (-not $gameDir) {
    # Not fatal: you can still BUILD without the game present. Only -Deploy
    # needs to know where it lives.
    $gameDir = (Resolve-Path (Join-Path $here "..\..") -ErrorAction SilentlyContinue).Path
}

if (-not (Test-Path $src)) { throw "missing source: $src" }
if (-not (Test-Path $def)) { throw "missing module definition: $def" }
if (Test-Path (Join-Path $gameDir "Napoleon.exe")) {
    Write-Host "game: $gameDir"
} else {
    Write-Host "note: could not locate Napoleon.exe. Building is fine; -Deploy needs a path."
    Write-Host '      use  -Game "C:\path\to\Napoleon Total War"  or  $env:NSE_GAME'
}

function Have($name) { return [bool](Get-Command $name -ErrorAction SilentlyContinue) }

# Find a zig: an explicit -Zig, then $env:NSE_ZIG, then one unpacked beside this
# project or next to the game folder, then PATH. Nothing here depends on PATH
# being set up, because it usually is not.
$zigLocal = $null
if ($Zig -and (Test-Path $Zig)) { $zigLocal = $Zig }
if (-not $zigLocal -and $env:NSE_ZIG -and (Test-Path $env:NSE_ZIG)) { $zigLocal = $env:NSE_ZIG }
if (-not $zigLocal) {
    # Look beside the project and one level up from the game folder. Nothing
    # machine-specific: if zig lives somewhere else, pass -Zig or put it on PATH.
    $searchRoots = @(
        (Join-Path $here "..\tools"),
        (Join-Path $here ".."),
        $gameDir,
        (Join-Path $gameDir "..")
    )
    foreach ($root in $searchRoots) {
        if (-not (Test-Path $root)) { continue }
        $cand = Get-ChildItem $root -Directory -ErrorAction SilentlyContinue |
                Where-Object { $_.Name -like "zig-*windows*" } |
                Sort-Object Name -Descending | Select-Object -First 1
        if ($cand) {
            $p = Join-Path $cand.FullName "zig.exe"
            if (Test-Path $p) { $zigLocal = $p; break }
        }
    }
}
if (-not $zigLocal -and (Have "zig")) { $zigLocal = (Get-Command zig).Source }

if ($zigLocal) {
    Write-Host "building with zig: $zigLocal"
    # -target x86-windows-gnu : 32-bit, MinGW ABI - what a proxy DLL for a
    #   32-bit game needs.
    #
    # nse.def aliases the undecorated export names (see that file for why).
    # Zig's lld rejects --kill-at, so the .def is how we get
    # "DirectInput8Create" rather than "DirectInput8Create@20".
    #
    # Compiler warnings arrive on stderr, and PowerShell 5.1 turns native stderr
    # into error records that $ErrorActionPreference='Stop' then makes fatal -
    # which reports "build failed" on a build that actually succeeded. Judge
    # success by the exit code only.
    $prevEAP = $ErrorActionPreference
    $ErrorActionPreference = 'Continue'
    & $zigLocal cc -target x86-windows-gnu -shared -O2 `
        -o $out $src $def -lkernel32 -luser32 2>&1 | ForEach-Object { Write-Host "  $_" }
    $rc = $LASTEXITCODE
    $ErrorActionPreference = $prevEAP
    if ($rc -ne 0) { throw "zig build failed (exit $rc)" }
}
elseif (Have "i686-w64-mingw32-gcc") {
    Write-Host "building with mingw (i686)..."
    & i686-w64-mingw32-gcc -shared -O2 -o $out $src $def -lkernel32 -luser32
    if ($LASTEXITCODE -ne 0) { throw "mingw build failed" }
}
elseif (Have "gcc") {
    Write-Host "building with gcc -m32 (must be a 32-bit-capable toolchain)..."
    & gcc -m32 -shared -O2 -o $out $src $def -lkernel32 -luser32
    if ($LASTEXITCODE -ne 0) { throw "gcc build failed (is it 32-bit capable?)" }
}
elseif (Have "cl") {
    Write-Host "building with MSVC cl (run from an x86 Native Tools prompt)..."
    Push-Location $here
    & cl /nologo /LD /O2 nse_proxy.c /link /DEF:nse.def /OUT:$out kernel32.lib user32.lib
    $rc = $LASTEXITCODE; Pop-Location
    if ($rc -ne 0) { throw "cl build failed" }
}
else {
    Write-Host ""
    Write-Host "No C compiler found. Install ONE of these (no admin needed for the first two):"
    Write-Host "  Zig        https://ziglang.org/download/   <- recommended, single portable zip"
    Write-Host "  w64devkit  https://github.com/skeeto/w64devkit/releases"
    Write-Host "  MSVC       Visual Studio Build Tools (C++ workload)"
    Write-Host ""
    Write-Host "Then re-run this script. If it is already installed somewhere this"
    Write-Host "script did not look, either:"
    Write-Host "  .\build.ps1 -Zig <path to zig.exe>"
    Write-Host '  $env:NSE_ZIG = "<path to zig.exe>"   (persists for the session)'
    Write-Host "  or unzip it into .\tools\ beside this project"
    exit 1
}

$fi = Get-Item $out
Write-Host ("built {0} ({1:N0} bytes)" -f $fi.Name, $fi.Length)

# ---- check 1: it really is a 32-bit PE ------------------------------------
$bytes = [System.IO.File]::ReadAllBytes($out)
$po = [BitConverter]::ToInt32($bytes, 0x3C)
$machine = [BitConverter]::ToUInt16($bytes, $po + 4)
if ($machine -eq 0x014C) {
    Write-Host "  machine: 0x014C (i386) - correct for Napoleon"
} else {
    throw ("machine=0x{0:X4}, expected 0x014C (i386). Napoleon would load nothing and say nothing." -f $machine)
}

# ---- check 2: the export NAMES are undecorated -----------------------------
# A proxy whose exports carry the stdcall @N suffix cannot satisfy Napoleon's
# imports, and the only symptom is the game refusing to launch. Check it here
# rather than discovering it that way.
$ns = [BitConverter]::ToUInt16($bytes, $po + 6)
$os = [BitConverter]::ToUInt16($bytes, $po + 20)
$st = $po + 24 + $os
$secs = @()
for ($i = 0; $i -lt $ns; $i++) {
    $o = $st + $i * 40
    $secs += [pscustomobject]@{
        VA = [BitConverter]::ToUInt32($bytes, $o + 12)
        VS = [BitConverter]::ToUInt32($bytes, $o + 8)
        RP = [BitConverter]::ToUInt32($bytes, $o + 20)
    }
}
function Rva2Off($r) {
    foreach ($s in $secs) { if ($r -ge $s.VA -and $r -lt ($s.VA + $s.VS)) { return $s.RP + ($r - $s.VA) } }
    return -1
}
$expRva = [BitConverter]::ToUInt32($bytes, $po + 24 + 0x60)
$names = @()
if ($expRva -ne 0) {
    $e = Rva2Off $expRva
    $cnt  = [BitConverter]::ToUInt32($bytes, $e + 24)
    $nOff = Rva2Off ([BitConverter]::ToUInt32($bytes, $e + 32))
    for ($i = 0; $i -lt $cnt; $i++) {
        $so = Rva2Off ([BitConverter]::ToUInt32($bytes, $nOff + $i * 4))
        $end = $so; while ($bytes[$end] -ne 0) { $end++ }
        $names += [System.Text.Encoding]::ASCII.GetString($bytes, $so, $end - $so)
    }
}
Write-Host ("  exports: {0}" -f ($names -join ", "))
$required = @('DirectInput8Create','DllGetClassObject','DllCanUnloadNow',
              'DllRegisterServer','DllUnregisterServer')
$missing = $required | Where-Object { $names -notcontains $_ }
if ($missing) {
    Write-Host ("  ERROR: missing undecorated export(s): {0}" -f ($missing -join ", "))
    Write-Host "         Napoleon imports the undecorated names; it would refuse to launch."
    Write-Host "         Check nse.def is being passed to the linker."
    throw "missing required exports - refusing to deploy"
}
if ($names -match '@') {
    Write-Host "  note: decorated @N aliases also present (harmless - the undecorated names resolve)"
}
Write-Host "  all 5 undecorated exports present - the proxy will satisfy Napoleon's import"

if ($Deploy) {
    if (-not (Test-Path (Join-Path $gameDir "Napoleon.exe"))) {
        throw ("cannot deploy: no Napoleon.exe at $gameDir`n" +
               "  pass -Game `"C:\path\to\Napoleon Total War`", set `$env:NSE_GAME,`n" +
               "  or move this project inside the game folder")
    }
    if (Get-Process Napoleon -ErrorAction SilentlyContinue) { throw "Napoleon is running - close it first" }
    $dest = Join-Path $gameDir "dinput8.dll"
    if (Test-Path $dest) {
        # Only back up a REAL dinput8 - never a previous copy of OURS. A check
        # that merely tests whether a backup exists will, on the second deploy,
        # happily save our own proxy as "the original". Our builds embed the NSE
        # version string; use that as the marker.
        $destBytes = [System.IO.File]::ReadAllBytes($dest)
        $marker = [System.Text.Encoding]::ASCII.GetBytes("NSE proxy")
        $isOurs = $false
        for ($i = 0; $i -le ($destBytes.Length - $marker.Length); $i++) {
            if ($destBytes[$i] -eq $marker[0]) {
                $m = $true
                for ($j = 1; $j -lt $marker.Length; $j++) {
                    if ($destBytes[$i + $j] -ne $marker[$j]) { $m = $false; break }
                }
                if ($m) { $isOurs = $true; break }
            }
        }
        if ($isOurs) {
            Write-Host "existing dinput8.dll is a previous NSE build - not backing it up"
        } else {
            $bak = Join-Path $gameDir "dinput8_original.dll"
            if (-not (Test-Path $bak)) {
                Copy-Item $dest $bak
                Write-Host "backed up the REAL dinput8.dll -> dinput8_original.dll"
            }
        }
    }
    try {
        Copy-Item $out $dest -Force -ErrorAction Stop
    } catch [System.UnauthorizedAccessException] {
        # The default Steam library is under Program Files (x86), which needs
        # elevation to write. Say that plainly rather than surfacing a raw
        # .NET access error.
        throw ("cannot write to $dest - permission denied.`n" +
               "  The game is in a protected folder (Program Files). Either:`n" +
               "    - re-run this in a PowerShell started as Administrator, or`n" +
               "    - move the Steam library somewhere user-writable`n" +
               "  NSE itself does not need admin once installed.")
    }
    Write-Host "deployed -> $dest"

    # The autoexec is optional but the whole point of the thing, so put a copy
    # in place on the first deploy. Never overwrite one you have edited.
    $autoSrc = Join-Path $here "..\lua\nse_autoexec.lua"
    $autoDst = Join-Path $gameDir "nse_autoexec.lua"
    if ((Test-Path $autoSrc) -and -not (Test-Path $autoDst)) {
        Copy-Item $autoSrc $autoDst
        Write-Host "installed -> $autoDst  (edit this; no rebuild needed)"
    }

    Write-Host ""
    Write-Host "Launch the game, then check nse_log.txt in the game folder."
    Write-Host "Nothing in nse_log.txt at all means the DLL was not loaded."
}
