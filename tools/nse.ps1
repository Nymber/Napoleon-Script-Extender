<#
  nse.ps1 - talk to the running game.

  Sends Lua source to dinput8.dll (NSE) over a named pipe; the DLL queues it and
  a hook running on the GAME's own thread evaluates it in the requested
  lua_State, then the result comes back. The game keeps running throughout -
  this exists so you stop restarting it for every experiment.

  Usage
    .\nse.ps1 "return 1+1"                  evaluate in the campaign state
    .\nse.ps1 -Repl                         interactive prompt
    .\nse.ps1 -Probe                        sanity checks
    .\nse.ps1 -Say "Hello"                  dialogue box in-game
    .\nse.ps1 -UI "return type(Component)"  evaluate in the campaign UI state
    .\nse.ps1 -Battle "return 1"            evaluate in the battle state
    .\nse.ps1 -Native states                ask NSE what it has bound

  Notes
    - "return <expr>" gets a value back; bare statements return nil.
    - The campaign lua_State does not exist until a campaign is loaded, and the
      DLL will say so rather than guessing.
    - -Native needs no lua_State at all, so it works at the main menu and during
      loading. That is when "which states have bound so far?" is most useful.
#>
param(
    [Parameter(Position=0, ValueFromRemainingArguments=$true)][string[]]$Code,
    [switch]$Repl,
    [switch]$Probe,
    # Napoleon runs the UI in separate lua_States, and the UI API
    # (UIComponent / Component / panelmanager) exists ONLY there - so anything
    # that draws on screen needs -UI.
    [switch]$UI,
    # The battle lua_State, where Napoleon's 218-function battle API lives
    # (CameraZoomTo, AddUnitsToGroup, BattleDetails, ...). Created per battle,
    # so this only works while in one - and its binding is a heuristic; see
    # src/nse_proxy.c and docs/SCRIPT_API.md.
    [switch]$Battle,
    # NSE's own commands, no lua_State required.
    [switch]$Native,
    # Show a dialogue box in the running game. Routed to the UI state
    # automatically - panelmanager only works there.
    [string]$Say,
    [int]$TimeoutMs = 8000
)

function Send-Nse([string]$lua) {
    if ($UI)     { $lua = "@ui $lua" }
    if ($Battle) { $lua = "@battle $lua" }
    if ($Native) { $lua = "@nat $lua" }
    $pipe = New-Object System.IO.Pipes.NamedPipeClientStream('.', 'nse', [System.IO.Pipes.PipeDirection]::InOut)
    try { $pipe.Connect($TimeoutMs) }
    catch {
        return "[no connection] Is the game running with dinput8.dll (NSE) in the " +
               "game folder? Check nse_log.txt there - an empty or absent log means " +
               "the DLL was never loaded."
    }
    try {
        $pipe.ReadMode = [System.IO.Pipes.PipeTransmissionMode]::Message
        $bytes = [System.Text.Encoding]::ASCII.GetBytes($lua)
        $pipe.Write($bytes, 0, $bytes.Length)
        $pipe.Flush()
        $buf = New-Object byte[] 8192
        $n = $pipe.Read($buf, 0, $buf.Length)
        if ($n -le 0) { return "[empty response]" }
        return [System.Text.Encoding]::ASCII.GetString($buf, 0, $n)
    } finally { $pipe.Dispose() }
}

if ($Say) {
    # Escape for a Lua single-quoted string, then open the vanilla dialogue_box
    # panel. Always the UI state - panelmanager needs its Component API; from
    # the campaign state OpenPanel dies on a nil TriggerPanelOpenEvent.
    #
    # Napoleon's own dialogue_box.luac requires 'Utilities' while its
    # panelmanager.luac requires 'CoreUtils' - both spellings ship, so try both
    # rather than picking one and being wrong half the time.
    $esc = $Say -replace '\\','\\\\' -replace "'","\'" -replace "`r?`n",'\n'
    $lua = "@ui local pm " +
           "for _,m in ipairs({'Utilities','CoreUtils'}) do " +
           "  local ok,u = pcall(require, m) " +
           "  if ok and type(u)=='table' and u.Require then " +
           "    local ok2,p = pcall(u.Require,'panelmanager') " +
           "    if not (ok2 and type(p)=='table') then ok2,p = pcall(u.Require,'PanelManager') end " +
           "    if ok2 and type(p)=='table' then pm=p break end " +
           "  end " +
           "end " +
           "if type(pm)~='table' or not pm.OpenPanel then return 'panelmanager not reachable' end " +
           "local ok,err=pcall(pm.OpenPanel,'dialogue_box',false,'Initialise','$esc') " +
           "return ok and 'shown' or ('failed: '..tostring(err))"
    $pipe = New-Object System.IO.Pipes.NamedPipeClientStream('.', 'nse', [System.IO.Pipes.PipeDirection]::InOut)
    try { $pipe.Connect($TimeoutMs) } catch { Write-Output "[no connection] is the game running?"; return }
    try {
        $pipe.ReadMode = [System.IO.Pipes.PipeTransmissionMode]::Message
        $b = [System.Text.Encoding]::ASCII.GetBytes($lua)
        $pipe.Write($b, 0, $b.Length); $pipe.Flush()
        $buf = New-Object byte[] 8192
        $n = $pipe.Read($buf, 0, $buf.Length)
        Write-Output ([System.Text.Encoding]::ASCII.GetString($buf, 0, $n))
    } finally { $pipe.Dispose() }
    return
}

if ($Probe) {
    # Positive checks only. This engine fails QUIETLY - a wrong-scoped condition
    # returns zero rather than erroring - so "no error" proves nothing and every
    # check here has an expected value stated next to it.
    $checks = @(
        @{ q = "@nat version";                             why = "DLL is loaded and answering (no lua_State needed)" },
        @{ q = "@nat states";                              why = "which lua_States have bound so far" },
        @{ q = "return NSE_Version()";                     why = "native fn reachable from the campaign state" },
        @{ q = "return NSE_Ping()";                        why = "native call round-trip (expect pong)" },
        @{ q = "return _VERSION";                          why = "expect Lua 5.1" },
        @{ q = "return type(conditions)";                  why = "campaign API present (expect table)" },
        @{ q = "return type(effect)";                      why = "campaign API present (expect table)" },
        @{ q = "return type(package.loaded.EpisodicScripting)"; why = "Napoleon's scripting module (expect table)" },
        @{ q = "return tostring(rawget(_G,'NSE_Ping'))";   why = "_G is NOT the campaign globals (expect nil - this is correct)" },
        @{ q = "return tostring(conditions.TurnNumber ~= nil)"; why = "a real condition exists (expect true)" }
    )
    foreach ($c in $checks) {
        $pipe = New-Object System.IO.Pipes.NamedPipeClientStream('.', 'nse', [System.IO.Pipes.PipeDirection]::InOut)
        try { $pipe.Connect($TimeoutMs) } catch { Write-Output "[no connection] is the game running?"; return }
        try {
            $pipe.ReadMode = [System.IO.Pipes.PipeTransmissionMode]::Message
            $b = [System.Text.Encoding]::ASCII.GetBytes($c.q)
            $pipe.Write($b, 0, $b.Length); $pipe.Flush()
            $buf = New-Object byte[] 8192
            $n = $pipe.Read($buf, 0, $buf.Length)
            $r = [System.Text.Encoding]::ASCII.GetString($buf, 0, $n)
        } finally { $pipe.Dispose() }
        Write-Output ("{0,-52} -> {1}" -f $c.q, ($r -replace "`n", " / "))
        Write-Output ("{0,-52}    ({1})" -f "", $c.why)
    }
    return
}

if ($Repl) {
    $where = if ($UI) { "campaign UI" } elseif ($Battle) { "battle" } else { "campaign scripting" }
    Write-Host "NSE Lua REPL - evaluates in Napoleon's $where state."
    Write-Host "Type Lua, 'quit' to exit. Use 'return x' to see a value."
    Write-Host ""
    while ($true) {
        Write-Host -NoNewline "lua> "
        $line = Read-Host
        if ($null -eq $line) { break }
        if ($line -in @('quit','exit')) { break }
        if ([string]::IsNullOrWhiteSpace($line)) { continue }
        # Convenience: a bare expression is almost always meant as "return <it>".
        if ($line -notmatch '^\s*(return|local|if|for|while|do|function|--)') {
            if ($line -notmatch '[=;]') { $line = "return $line" }
        }
        Write-Host (Send-Nse $line)
    }
    return
}

# Single-quoted: PowerShell does NOT accept C-style \" escaping inside a
# double-quoted string (use a backtick, or single quotes as here).
if (-not $Code) {
    Write-Host 'usage: .\nse.ps1 "return NSE_Ping()"  |  -Repl  |  -Probe  |  -Native states'
    exit 1
}
# Write-OUTPUT, not Write-Host: results must flow down the pipeline so callers
# can capture them ($x = .\nse.ps1 "..."). Write-Host goes straight to the
# console and returns $null to the caller, which silently breaks scripted use.
Write-Output (Send-Nse ($Code -join ' '))
