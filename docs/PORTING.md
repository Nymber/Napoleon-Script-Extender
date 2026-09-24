# Porting ESE to Napoleon — what was established, and how

> **Empire: Total War is not a dependency.** It appears throughout this document
> because it was the *reference* used to derive Napoleon's Lua addresses. Those
> signatures now ship in `tools/lua_api_signatures.json`; nothing in NSE reads
> an Empire binary at build or run time.

This is the evidence record. Everything the extender depends on is listed here
with the way it was checked, so a future reader can tell what is proven from
what is inference — and so that a patch that breaks something points straight at
the check that would catch it.

Split into three tiers:

- **Verified** — established from Napoleon's own binary or shipped data, with a
  test that would have failed had the claim been wrong.
- **Inherited** — an Empire design decision reused because the mechanism it
  relies on was confirmed present in Napoleon.
- **Unverified** — believed, not tested. These are the ones to watch on bring-up.

---

## Verified

### Napoleon.exe is a 32-bit PE at ImageBase 0x00400000 that imports DINPUT8

```
machine=0x014C (i386)  magic=0x010B  imagebase=0x00400000  sections=6
  .text    VA=00001000 VSZ=00F058FC RAW=00000400
  .rdata   VA=00F07000 VSZ=00146236 RAW=00F05E00
  .data    VA=0104E000 VSZ=003F5ED8 RAW=0104C200
imports: ADVAPI32, binkw32, COMDLG32, d3d9, d3dx9d_40, DINPUT8, DSOUND, GDI32,
         KERNEL32, mss32, OLEAUT32, RPCRT4, SHELL32, SHLWAPI, steam_api, tbb,
         USER32, VERSION, WINMM, WS2_32, ole32
```

The whole proxy-DLL approach rests on that `DINPUT8` import. It is there, it has
five exports, and it is not a protected KnownDLL — so the application-directory
override works exactly as it does for Empire.

### Napoleon statically links Lua 5.1

The version string is present twice (`0xFEBAAE`, `0x1041F4C`), along with
`_LOADED`, `stack overflow` and `not enough memory` — the Lua runtime's own
strings, in the executable, not in a separate DLL.

### The ten Lua C API addresses

Derived by `tools/find_lua_api.rb`, which takes each function's bytes from
Empire.exe at its known address, masks what relocation changes (the 4 bytes
after `E8`/`E9`, and any dword that reads as an in-image address), and searches
Napoleon's `.text` for the remainder. 76–92 of each 96-byte window survives
masking.

```
lua_getfield       80/96 bytes fixed  -> 0x00FE8F90
lua_gettop         88/96 bytes fixed  -> 0x00FE9070
lua_pcall          84/96 bytes fixed  -> 0x00FE93C0
lua_pushcclosure   80/96 bytes fixed  -> 0x00FE9460
lua_pushlstring    88/96 bytes fixed  -> 0x00FE9560
lua_setfield       76/96 bytes fixed  -> 0x00FE9990
lua_settop         92/96 bytes fixed  -> 0x00FE9AD0
lua_tolstring      76/96 bytes fixed  -> 0x00FE9C40
lua_type           76/96 bytes fixed  -> 0x00FE9DA0
luaL_loadbuffer    80/96 bytes fixed  -> 0x00FEA6C0
```

Each matched **exactly once**. That alone would be suggestive, not conclusive.

**The proof is the relative layout.** All ten sit at identical offsets from
`lua_getfield` in both binaries:

```
getfield +0      gettop +0xE0     pcall +0x430     pushcclosure +0x4D0
pushlstring +0x5D0   setfield +0xA00   settop +0xB40   tolstring +0xCB0
type +0xE10      loadbuffer +0x1730
```

Ten functions agreeing on ten offsets is not coincidence — it is the same Lua
object file, relocated by `0xE1B70`. `find_lua_api.rb --verify` re-runs this
check and refuses to emit a partial result.

### Both hook sites have the expected prologue

`lua_getfield` and `lua_setfield` at the Napoleon addresses both begin
`83 EC 08 53 56` — `sub esp,8; push ebx; push esi`. Whole instructions, none
position-dependent, so the 5-byte steal and the single trampoline shape carry
over unchanged. `install_hook_ex` checks this again at runtime and refuses to
patch on a mismatch.

### The scripting API: 1,134 registrations

`tools/dump_script_api.rb --discover` walks every `call rel32` in `.text` and
groups the call sites by target, then walks back over the run of `push imm32`
feeding each one. Six registrars, in two distinct shapes:

| registrar | shape | entries | namespace |
|---|---|---|---|
| `00DF15C0` | name last | 308 | `conditions` |
| `00DF2F40` | name last (short) | 138 | `events` |
| `00DF18C0` | name last | 13 | `effect` |
| `00998C50` | name middle | 339 | campaign UI commands |
| `0059EB40` | name middle | 218 | battle commands |
| `004587A0` | name middle | 118 | frontend commands |

The pushes are positional. For conditions and effects:

```
[0] implementing function
[1] the CA developer who wrote it  ("Guy", "Paul", "Tom", "Ed", "Alan", ...)
[2] usage example
[3] description
[4..] one doc string per parameter
[-1] name
```

That `[1]` slot is a trap: parsed as documentation it gives every entry a first
"doc" line that is a first name, which reads like corrupt output. It is a byline
and `dump_script_api.rb` reports it as one.

Events use a shorter form — `[registry object, context scope, description]` —
and **that scope field is the most valuable thing in the dump**, because calling
a condition with a context from the wrong scope is the engine's quietest failure
mode. All 138 are in `SCRIPT_API.md`.

The per-parameter doc is the second prize. For `RegionSlotBuildingTypeExists`
the description says "a building of the specified type", which sounds like a
building *type*, while the parameter doc says "The key of the building level you
are querying from the building_levels table". They disagree, and the parameter
doc is the one that matches the code.

### Napoleon's campaign scripting goes through a module, not a global

`data\all_scripted.lua` ships in plain text and does what Empire does:

```lua
local triggers = require "data.export_triggers"
events = triggers.events
```

but `data\campaigns\eur_napoleon\scripting.lua` — also plain text — does not use
it. It uses:

```lua
local scripting = require "EpisodicScripting"
scripting.SetCampaign("eur_napoleon")
scripting.game_interface:trigger_custom_mission(...)
conditions.TurnNumber(...)
```

`episodicscripting.lua` itself is shipped uncompiled inside `data.pack` (56 KB).
Reading it settles two things that Empire's notes could not:

```lua
function AddEventCallBack(event, func, add_to_user_defined_list)
	assert(events[event] ~= nil, "Attempting to add event callback to non existant event ("..event..")")
	events[event][#events[event]+1] = func           -- APPENDS
	if add_to_user_defined_list ~= false then ... end -- and records it for teardown
end
```

So `AddEventCallBack` **appends** rather than replacing, and going through it
also registers the handler with `ClearEventCallbacks`. `NSE.on()` uses it, with
the raw event table only as a fallback.

This is also why the autoexec readiness gate differs from Empire's. Empire waits
for a global `events` table; Napoleon's campaign state may never have one, so
NSE walks `package` → `loaded` → `EpisodicScripting` with `lua_getfield` instead,
accepting Empire's global `events` as a secondary signal.

### The UI path for on-screen text exists

Extracted from `data.pack`:

- `ui\panelmanager.luac` — requires `CoreUtils`, exposes `OpenPanel`,
  `ClosePanel`, `IsPanelOpen`, and knows the panel id `dialogue_box`.
- `ui\common ui\dialogue_box.luac` — requires `Utilities`, and its `Initialise`
  takes `(txt, ok_callback, cancel_callback)`.

Note the two shipped scripts disagree on the helper module name — one says
`Utilities`, the other `CoreUtils`. `NSE_Say` and `nse.ps1 -Say` try both rather
than picking one and being wrong half the time.

### The data formats carry over

All three checked against Napoleon's own files, not assumed:

| format | check | result |
|---|---|---|
| `.pack` | header of `data\boot.pack` | `PFH0`, identical layout to Empire's, dependency block present |
| `.loc` | `text\ui.loc` decoded end to end | 2,820 entries, **857,648 of 857,648 bytes consumed** |
| `db` | `db\units_tables\units` decoded | version 4, 442 rows, 25 fields, **170,171 of 170,171 bytes consumed** |

Reading a binary format to EOF with zero bytes left over is the only real proof
it has been decoded correctly, and it is what `loctool.rb verify` and
`dbread.rb`'s candidate selection both test. `dbread.rb` decodes *every*
schema candidate in full and takes the one that consumes the file exactly — on
`unit_stats_land` (version 5) that correctly rejects an 84-field candidate and
picks the 89-field one, rather than returning plausible garbage.

**Table versions differ from Empire's.** Napoleon's `units` is version 4 where
Empire's is 2. Do not assume a schema transfers; `dbread.rb` will tell you if it
does not fit.

---

## Inherited

Design decisions carried over from ESE because the mechanism they depend on was
confirmed present in Napoleon.

- **Queue-and-pump threading.** The pipe thread never touches Lua; the
  `lua_getfield` hook drains the queue on the game thread. Nothing about this is
  game-specific — it follows from `lua_State` not being thread-safe.
- **Keying the campaign state on `L`, not a boolean.** A new campaign is a new
  `lua_State`; a one-shot "registered" flag would leave the pointer aimed at
  freed memory. Comparing `L` re-acquires automatically.
- **Two-stage UI root detection.** Collect states that receive `CampaignUI`,
  then promote whichever also receives `Component`. Empire creates a minimal
  `CampaignUI` state alongside the real UI root; Napoleon's UI is the same
  codebase. Tracking every `Component`-bearing state instead would be a
  use-after-free — there are ~100 and they are per-panel.
- **Registering through `LUA_GLOBALSINDEX` and never verifying via `_G`.**
- **Refusing to hook on a prologue mismatch.** This is what turns "a patch moved
  the function" from silent memory corruption into a line in the log.

---

## Confirmed at bring-up (2026-09-21)

Run against a live Napoleon process, campaign loaded.

**The addresses were right, under ASLR.** The image loaded at `0x00AB0000`
(delta `0x6B0000`), both hook sites still carried `83 EC 08 53 56`, and both
detours installed. Had the derivation been wrong, `install_hook_ex` would have
refused and said so.

```
[nse] ---- start ---- base=00AB0000 delta=0x6B0000
[nse] hooked 01699990 -> tramp 025F0000 (steal 5)
[nse] hooked 01698F90 -> tramp 03FF0000 (steal 5)
[nse] campaign state (re)acquired: 05F98CB8 (key 'conditions')
[nse] scripting layer is up - running autoexec
[nse] autoexec ran OK (9917 bytes)
```

**The `EpisodicScripting` readiness gate works.** `package.loaded.EpisodicScripting`
became a table and the autoexec fired. The concern about gate timing and the
1-in-256 throttle was unfounded — the window is wide.

**Both event routes exist in the campaign state.** `EpisodicScripting` is a
table *and* so is a global `events`, so `NSE.on()`'s primary path and its
fallback are both live. The primary is still the one to use, because it
registers for teardown.

**The whole chain works end to end.** `conditions.FactionIsLocal`,
`TurnNumber` and `FactionTreasury` called from a `FactionTurnStart` handler
inside `NSE_Protect` returned `turn=1 treasury=7000` with zero faults. All ten
`-Probe` checks matched their expected values.

**`dialogue_box` `Initialise` takes the Empire call shape.**
`OpenPanel('dialogue_box', false, 'Initialise', text)` through
`require('Utilities').Require('panelmanager')` returned `shown` and rendered.
The `Utilities` spelling won; the `CoreUtils` fallback was not needed but costs
nothing.

**UI root promotion never fires, and that is fine.** Two `CampaignUI` candidates
appear and neither is later seen receiving `Component` — but the provisional
first candidate already *has* `Component`, `UIComponent` and `CampaignUI` as
tables, so it was the right state all along. The promotion step is harmless
insurance rather than a necessary stage. Do not "fix" the missing log line.

**`_G` vs `getfenv`, measured.**

```
_G.conditions          -> nil          getfenv(1).conditions  -> table
rawget(_G,'NSE_Ping')  -> nil          getfenv(1).NSE_Ping    -> function
```

This caught the project out during bring-up: `NSE.survey()` read `_G[name]` and
reported `conditions=nil effect=nil events=nil` — indistinguishable from a
complete failure to load — while the turn handler beside it was reading real
treasury figures. Fixed to use `getfenv(1)`. The lesson is the one already in
the README, which the code then failed to follow: never verify through `_G`.

---

## Unverified

### The battle-state binding is a heuristic

Napoleon registers 218 battle commands through the registrar at `0059EB40`. But
that registrar stores them into its own lists (`DAT_014A4174`, `DAT_014A4178`)
rather than calling `lua_setfield` directly, so static analysis cannot prove the
names land as globals in the battle `lua_State`.

NSE therefore watches for four distinctive command names — `BattleDetails`,
`CameraZoomTo`, `AddUnitsToGroup`, `BroadsideMouseEvent` — and binds the state
that receives any of them. If they are never assigned as globals, nothing binds
and `@battle` says so plainly. It never guesses at a state.

`nse.ps1 -Native states` prints what actually bound, which is how to find the
real sentinel if these are wrong.

The campaign and UI states do not depend on this and are unaffected — both were
confirmed working at bring-up while `battle` remained `00000000`, which is the
expected reading outside a battle.

To settle it, start a battle and run `nse.ps1 -Native states`. If `battle` is
still null, one of the 218 battle commands is reaching that state under a name
none of the four sentinels match; `nse.ps1 -Battle "return 1"` will also report
plainly rather than guessing. The sentinel list is `kBattleSentinels[]` in
`src/nse_proxy.c`.

---

## Re-deriving everything after a patch

```powershell
cd tools
ruby find_lua_api.rb --verify          # new Lua C API addresses, with the cross-check
ruby dump_script_api.rb --discover     # new registrars
ruby dump_script_api.rb all --md ..\docs\SCRIPT_API.md
```

Paste the `#define`s from the first command into `src/nse_proxy.c`, rebuild, and
the prologue guard will tell you if anything still does not line up.
