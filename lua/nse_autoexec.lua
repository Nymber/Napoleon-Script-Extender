-- ============================================================================
-- nse_autoexec.lua - the starting point for a Napoleon mod built on NSE.
--
-- Deploy this to the GAME ROOT, next to Napoleon.exe. NSE loads it into every
-- campaign scripting state, once Napoleon's scripting layer is up. Edit it and
-- reload a campaign - no rebuild.
--
-- This file is a HARNESS, not a mod. It gives you a safe way to register
-- handlers, a safe way to call the engine, and a way to look around. What you
-- build on top is yours.
--
-- ---------------------------------------------------------------------------
-- THE TWO RULES THAT MATTER
--
-- 1. `pcall` DOES NOT PROTECT YOU.
--    Napoleon's conditions and effects are native C that dereference their
--    arguments without validating them. Wrong arity, or a context from the
--    wrong scope, is an ACCESS VIOLATION - not a catchable Lua error. pcall
--    catches Lua errors only. So every handler body here runs inside
--    NSE_Protect, which arms NSE's vectored exception guard.
--
--    Even then, a caught fault leaves engine state suspect. The guard turns a
--    certain crash into a probable recovery; it is not a licence to guess at
--    signatures. Look them up in docs/SCRIPT_API.md first.
--
-- 2. `context` IS SCOPED, AND THE WRONG SCOPE FAILS SILENTLY.
--    A faction condition called with a region context does not error. It
--    returns zero, or false, and you believe it. docs/SCRIPT_API.md lists the
--    scope of all 138 events - "Faction", "Character", "Region", "Battle" and
--    so on - straight out of the binary. Match the event's scope to the
--    condition you are calling, call inside the handler while the context is
--    live, and never store a context for later.
--
-- `context` is always the LAST argument. A condition that needs a key takes it
-- FIRST: conditions.FactionName("france", context).
-- ============================================================================

NSE = NSE or {}
NSE.version = "0.1 (harness)"
NSE.notes   = {}
NSE.faults  = {}

local function note(s) NSE.notes[#NSE.notes + 1] = tostring(s) end
NSE.note = note

-- ---------------------------------------------------------------------------
-- safe(label, fn) - run fn with NSE's NATIVE crash guard armed.
--
-- Falls back to pcall if NSE_Protect is missing, so this file still loads if
-- you paste it into a game without the extender. That fallback is strictly
-- weaker and cannot catch an access violation; it exists so nothing explodes at
-- load time, not because it is sufficient.
-- ---------------------------------------------------------------------------
local function safe(label, fn)
  if type(NSE_Protect) ~= "function" then
    local ok, err = pcall(fn)
    if not ok then NSE.faults[#NSE.faults + 1] = label .. ": " .. tostring(err) end
    return ok
  end
  local r = NSE_Protect(fn)
  if r ~= "true" then
    NSE.faults[#NSE.faults + 1] = label .. ": " .. tostring(r)
    if type(NSE_Log) == "function" then NSE_Log("handler " .. label .. " -> " .. tostring(r)) end
    return false
  end
  return true
end
NSE.safe = safe

-- ---------------------------------------------------------------------------
-- NSE.on(event, fn) - register a handler, wrapped in the crash guard.
--
-- Napoleon's supported route is the EpisodicScripting module:
--
--     local scripting = require "EpisodicScripting"
--     scripting.AddEventCallBack("FactionTurnStart", handler)
--
-- and its AddEventCallBack APPENDS (`events[event][#events[event]+1] = func`,
-- read out of the shipped episodicscripting.lua). That is why NO vanilla file
-- ever needs editing to add a handler - the engine, the UI layer and any other
-- mod all chain onto the same list.
--
-- Do not reach for the raw table unless the module is genuinely absent; going
-- through AddEventCallBack also records the handler so ClearEventCallbacks can
-- remove it on campaign teardown. The raw path below is a fallback for exactly
-- that case, and it is asserted, not assumed.
-- ---------------------------------------------------------------------------
function NSE.on(event, fn)
  local wrapped = function(context) safe(event, function() fn(context) end) end

  local ok, scripting = pcall(require, "EpisodicScripting")
  if ok and type(scripting) == "table" and type(scripting.AddEventCallBack) == "function" then
    local added = pcall(scripting.AddEventCallBack, event, wrapped)
    if added then
      note("registered " .. event .. " via EpisodicScripting")
      return true
    end
    -- AddEventCallBack asserts on an unknown event name. That is a real error
    -- in your code, not a reason to fall through and append blindly.
    note("AddEventCallBack REFUSED " .. event .. " - is that event name real? see docs/SCRIPT_API.md")
    return false
  end

  local ok2, ev = pcall(require, "data.events")
  if ok2 and type(ev) == "table" and type(ev[event]) == "table" then
    ev[event][#ev[event] + 1] = wrapped
    note("registered " .. event .. " via data.events (fallback)")
    return true
  end
  if type(events) == "table" and type(events[event]) == "table" then
    events[event][#events[event] + 1] = wrapped
    note("registered " .. event .. " via global events (fallback)")
    return true
  end

  note("could NOT register " .. event .. " - no event table reachable")
  return false
end

-- ---------------------------------------------------------------------------
-- NSE.ask(name, ...) - call a condition safely and get a value back.
--
-- safe() cannot return the condition's result (NSE_Protect returns a status
-- string), so the value is stashed in an upvalue. Anything that faults comes
-- back as nil plus a recorded fault, never as a wrong answer.
-- ---------------------------------------------------------------------------
function NSE.ask(name, ...)
  local fn = conditions and conditions[name]
  if type(fn) ~= "function" then
    note("no such condition: " .. tostring(name))
    return nil
  end
  local args = { ... }
  local result
  local ok = safe("conditions." .. name, function() result = fn(unpack(args)) end)
  if not ok then return nil end
  return result
end

-- ---------------------------------------------------------------------------
-- Looking around. Napoleon's scripting surface is enumerated statically in
-- docs/SCRIPT_API.md, but these tell you what is live in THIS state right now -
-- which is not always the same thing.
-- ---------------------------------------------------------------------------

-- Keys of a table, sorted, as one string. Handy down the pipe:
--   .\nse.ps1 "return NSE.keys(conditions)"
function NSE.keys(t, limit)
  if type(t) ~= "table" then return "(not a table: " .. type(t) .. ")" end
  local k = {}
  for name in pairs(t) do k[#k + 1] = tostring(name) end
  table.sort(k)
  local n = #k
  if limit and n > limit then
    local cut = {}
    for i = 1, limit do cut[i] = k[i] end
    return table.concat(cut, " ") .. " ... (" .. n .. " total)"
  end
  return table.concat(k, " ") .. "  (" .. n .. " total)"
end

-- What is reachable from this state?
--
-- MUST use getfenv, not _G. In the campaign state those are different tables,
-- and _G is the wrong one: measured live in Napoleon,
--
--     _G.conditions           -> nil
--     getfenv(1).conditions   -> table
--     rawget(_G,'NSE_Ping')   -> nil
--     getfenv(1).NSE_Ping     -> function
--
-- A first version of this function used _G[name] and reported every single
-- entry as nil while the handler two screens down was happily calling
-- conditions.TurnNumber(). That is the trap, and reading it back as "nothing is
-- loaded" is exactly how it wastes your afternoon.
--
-- getfenv(1) is the environment of THIS function, which is the table the engine
-- actually registers into.
function NSE.survey()
  local env = getfenv(1)
  local out = {}
  for _, name in ipairs({ "conditions", "effect", "events", "out", "package",
                          "CampaignUI", "UIComponent", "Component", "GAME",
                          "NSE_Protect" }) do
    out[#out + 1] = name .. "=" .. type(env[name])
  end
  local ok, es = pcall(require, "EpisodicScripting")
  out[#out + 1] = "EpisodicScripting=" .. (ok and type(es) or "unavailable")
  if ok and type(es) == "table" then
    out[#out + 1] = "game_interface=" .. type(es.game_interface)
  end
  return table.concat(out, " ")
end

-- ---------------------------------------------------------------------------
-- A worked example, deliberately minimal.
--
-- FactionTurnStart fires for EVERY faction - Napoleon's Europe campaign has
-- dozens - so the first thing any handler must do is filter down to the human
-- player. Without the filter your code runs forty times a turn and the numbers
-- you read belong to whoever the AI is currently moving.
--
-- Scope: FactionTurnStart is a "Faction" event (docs/SCRIPT_API.md), so faction
-- conditions are the ones that are valid here.
-- ---------------------------------------------------------------------------
NSE.turn = 0
NSE.treasury = 0

local function on_faction_turn(context)
  local is_local = conditions.FactionIsLocal(context)
  if not is_local then return end

  NSE.turn     = conditions.TurnNumber(context) or 0
  NSE.treasury = conditions.FactionTreasury(context) or 0
  note("turn " .. NSE.turn .. " treasury " .. NSE.treasury)

  -- Uncomment to have the mod speak up on its own. NSE_Say queues the text and
  -- NSE shows it from the UI state on the next Lua hook, deferring if one of
  -- the game's own panels is already on screen.
  -- NSE_Say("Turn " .. NSE.turn .. " - treasury " .. NSE.treasury)
end

-- Short status line, for the pipe:  .\nse.ps1 "return NSE.dump()"
function NSE.dump()
  return string.format("nse=%s turn=%d treasury=%d notes=%d faults=%d",
                       NSE.version, NSE.turn, NSE.treasury, #NSE.notes, #NSE.faults)
end

-- Whatever went wrong, most recent last:  .\nse.ps1 "return NSE.why()"
function NSE.why()
  if #NSE.faults == 0 then return "no faults recorded" end
  return table.concat(NSE.faults, " | ")
end

-- ---------------------------------------------------------------------------
-- Registration happens last, so a syntax error above cannot leave a half-built
-- harness wired into the engine's event lists.
-- ---------------------------------------------------------------------------
NSE.on("FactionTurnStart", on_faction_turn)

if type(NSE_Log) == "function" then
  NSE_Log("nse_autoexec loaded: " .. NSE.survey())
end
