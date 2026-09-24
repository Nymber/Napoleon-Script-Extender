# NSE — Napoleon Script Extender

A native script extender and modding toolkit for **Napoleon: Total War** (32-bit).
Loads automatically, exposes the game's Lua to you while it runs, and lets you
add native functions the engine never offered.

Ported from the Empire Script Extender. Everything game-specific was re-derived
from Napoleon's own binary and packs — no Empire address, table version or API
name was assumed to carry over. Where something did carry over, it says so and
says how that was checked.

```
bin/dinput8.dll          the extender (deploy to the game root)
src/                     C source, module-definition file, build script
tools/                   the toolkit (see below)
lua/nse_autoexec.lua     Lua that runs automatically in every campaign
docs/SCRIPT_API.md       1,134 scripting functions, enumerated from Napoleon.exe
docs/PORTING.md          how every address and format claim here was established
docs/MODDING.md          building an actual mod: packs, db tables, localisation
LICENSE                  MIT
NOTICE.md                credits, third-party licences, what is and is not bundled
```

MIT licensed, © 2026 Sean. Credits and third-party terms are in `NOTICE.md`.
Unofficial; not endorsed by or affiliated with SEGA or Creative Assembly.

---

## Status

**Working. Verified in a running campaign.**

Brought up 2026-09-21 against a live Napoleon process. Hooks installed, campaign
and UI states bound, natives registered, autoexec ran, a handler read real game
state (`turn=1 treasury=7000`) with zero faults, and an in-game dialogue box
rendered. All ten `-Probe` checks return their expected values.

Still unverified: the **battle** state binding, which is a heuristic and needs a
battle to be in progress before it can fire. See `docs/PORTING.md`.

The address derivation held up under ASLR — the game loaded at `0x00AB0000`
(delta `0x6B0000`), and both hook sites still carried the expected prologue.

---

## What it gives you

| | |
|---|---|
| **Live Lua eval** | Run Lua in the running game from PowerShell. No restart. |
| **Real game state** | 308 `conditions`, 138 `events`, 13 `effects`, 339 campaign-UI, 218 battle and 118 frontend commands — all documented |
| **Event scopes** | Every event's context scope, from the binary. This is the trap that silently returns zeros. |
| **In-game text** | Dialogue boxes with your own content, on demand |
| **Native functions** | Register C functions callable from campaign scripts |
| **Crash guard** | Turns an engine access violation into an error string instead of a lost session |
| **Persistent setup** | `nse_autoexec.lua` runs on every campaign load |
| **No file patching** | Register handlers without editing a single vanilla file |
| **Pack / db / loc tooling** | Read and build `.pack`, decode `db` tables, edit `.loc` |

---

## Requirements

| for | you need |
|---|---|
| the extender | **Napoleon: Total War 1.3.0.0** — see [Which build](#which-build) |
| building it | **[Zig](https://ziglang.org/download/)** (portable zip, no installer). MinGW or MSVC also work. |
| the tools | **Ruby 2.7+** for the `.rb` tools, **PowerShell 5.1+** (ships with Windows) for the rest |
| `dbread.rb` only | `gem install nokogiri`, plus a `master_schema.xml` you supply — see `NOTICE.md` |

**Empire: Total War is not required.** NSE was ported from the Empire Script
Extender, and the Lua signatures were originally derived from Empire's binary —
but that is history, not a dependency. The signatures ship in
`tools/lua_api_signatures.json`, and every tool here runs against Napoleon
alone. Verified by running the whole toolkit from a copy outside the game
folder with no Empire involvement.

`--ref <Empire.exe>` on `find_lua_api.rb` is the one place a second binary can
be used, and it is optional — it only re-derives the cached signatures.

### Finding your game

Nothing is hardcoded to one machine. The tools and `build.ps1` resolve the game
folder in the same order:

1. an explicit flag — `--exe` / `--data` on the Ruby tools, `-Game` on `build.ps1`
2. the `NSE_GAME` environment variable
3. two levels up from the tool — i.e. this project unpacked **inside** the game
   folder, which is the usual layout
4. **Steam**: the install path from the registry, then every library in
   `libraryfolders.vdf`, then app `34030`'s own `installdir`
5. common GOG and retail paths

So a Steam install on any drive is found automatically, including from a copy of
this project kept somewhere else entirely. If none of that works, every tool
prints the list above with the flag to use. Set it once and forget it:

```powershell
$env:NSE_GAME = "C:\path\to\Napoleon Total War"
```

Drive-letter scanning is a **last** resort, deliberately, because probing a
disconnected network drive blocks for seconds per letter. The registry answers
on any real Steam install, so the slow path almost never runs.

### If the game is in Program Files

The default Steam library is under `C:\Program Files (x86)`, which is not
user-writable. Two consequences, both handled:

- `build.ps1 -Deploy` needs an **elevated** PowerShell to copy the DLL in. It
  says so plainly instead of surfacing a raw access error. NSE itself needs no
  admin once installed.
- The log cannot be written beside the game, so NSE falls back to
  `%APPDATA%\The Creative Assembly\Napoleon\nse_log.txt`. **Run
  `nse.ps1 -Native states` to see exactly where the log went** — it reports the
  path it chose. Without this the extender would work perfectly while appearing
  to produce no log at all, and "no log means it never loaded" would be badly
  wrong advice.

### Which build

Every Lua address in `src/nse_proxy.c` is specific to one executable:

```
Napoleon.exe   FileVersion 1.3.0.0 (ProductVersion 3.0.1.0)
               17,895,424 bytes
               TimeDateStamp 0x645E917F (2023-05-12 19:20:31 UTC)
               SHA256 44880EC1770F600163A336EEC83B4366901484C5CCEEC83DC326E2932F02A054
```

NSE checks this at startup and says so either way. On a different build it logs
a loud `HOST BUILD DOES NOT MATCH` block naming both identities, then declines
to hook — which is the safe outcome, not a crash. Recover with:

```powershell
ruby tools\find_lua_api.rb --verify
```

That needs nothing but your own `Napoleon.exe`; the signatures ship with the
project. Paste the `#define`s it prints into `src/nse_proxy.c` and rebuild.

---

## Install

1. `cd src; .\build.ps1 -Deploy` — builds and installs `dinput8.dll` plus a
   starter `nse_autoexec.lua` into the game root.
2. Launch. Check `nse_log.txt` in the game root.

**Uninstall:** delete `dinput8.dll`. Nothing else is modified — NSE never
touches game files.

Log from an actual healthy start (addresses vary — the game is ASLR'd):

```
[nse] ---- start ---- base=00AB0000 delta=0x6B0000
[nse] crash guard armed
[nse] hooked 01699990 -> tramp 025F0000 (steal 5)     <- lua_setfield
[nse] hooked 01698F90 -> tramp 03FF0000 (steal 5)     <- lua_getfield
[nse] ready; pipe \\.\pipe\nse
[nse] campaign state (re)acquired: 05F98CB8 (key 'conditions')
[nse] registered 10 native function(s) into state 05F98CB8
[nse] CampaignUI candidate: 05F98A88
[nse] CampaignUI candidate: 05FDAAE0
[nse] scripting layer is up - running autoexec
[nse] autoexec ran OK (9917 bytes)
```

Two `CampaignUI candidate` lines and no `UI root confirmed` is **normal** here:
the first candidate already has the full `Component` / `UIComponent` API, so the
promotion step never needed to fire. `-UI` works against it.

### Bring-up

The failure modes, in the order they are worth checking:

| Symptom | Meaning |
|---|---|
| No `nse_log.txt` at all | Run `nse.ps1 -Native states` **first** — it reports where the log actually went. If that answers, NSE is loaded and the log is just elsewhere (see [Program Files](#if-the-game-is-in-program-files)). If it does not answer, the DLL was never loaded: check it sits next to `Napoleon.exe` and is 32-bit. |
| `REFUSING to hook ... prologue mismatch` | Your `Napoleon.exe` is not the build these addresses came from. Run `ruby tools/find_lua_api.rb --verify` and paste the new `#define`s into `src/nse_proxy.c`. This refusal is the guard working: it declined to corrupt the binary. |
| Game refuses to launch, no window | Almost always decorated exports. `build.ps1` checks for this and would have thrown; if you built by hand, check `nse.def` reached the linker. |
| Log stops after `ready` | Nothing has assigned `conditions` yet — load a campaign. |
| `no campaign lua_State bound yet` | Same. The campaign state does not exist before a campaign does. |
| `battle=0000000` in `-Native states` | The battle sentinel never fired. That binding is a heuristic (see below); the campaign and UI states are unaffected. |

---

## Use

```powershell
cd tools

.\nse.ps1 "return 1+1"                    # evaluate in the campaign state
.\nse.ps1 -Repl                           # interactive prompt
.\nse.ps1 -Probe                          # sanity checks, each with its expected value
.\nse.ps1 -Say "Hello"                    # dialogue box in-game
.\nse.ps1 -UI "return type(Component)"    # evaluate in the UI state
.\nse.ps1 -Native states                  # what has bound so far (works at the menu)
```

A campaign must be loaded for anything but `-Native` — the campaign `lua_State`
does not exist before that.

### Reading live game state

```powershell
.\nse.ps1 "return NSE.dump()"
.\nse.ps1 "return NSE.survey()"
.\nse.ps1 "return NSE.keys(conditions, 40)"
```

---

## The toolkit

Everything here is for *making* mods. Each tool is a single file with its
reasoning in its own header.

| tool | what it does |
|---|---|
| `nse.ps1` | Talk to the running game. |
| `find_lua_api.rb` | Locate Napoleon's Lua 5.1 C API by signature. Run this after any patch. Needs no reference binary. |
| `dump_script_api.rb` | Enumerate the scripting API from `Napoleon.exe`. Generated `docs/SCRIPT_API.md`. |
| `packtool.rb` | List, extract from and **build** `.pack` archives. |
| `dbread.rb` | Decode a versioned `db` table, straight out of a pack if you like. Needs `nokogiri` and a `master_schema.xml` you supply. |
| `loctool.rb` | Read, search, extend and verify `.loc` localisation files. |

---

## How it works

**Proxy DLL.** Napoleon imports `DINPUT8.dll` (confirmed from its import table);
Windows loads a DLL from the application directory before the system one. So the
game loads NSE, NSE forwards the five real exports to `SysWOW64\dinput8.dll`,
and meanwhile we run native code inside the process *before* `main()` — hooks
are installed before Lua even initialises.

**Hooks.** Two 5-byte detours on `lua_setfield` and `lua_getfield`. Both begin
`83 EC 08 53 56` (`sub esp,8; push ebx; push esi`) — whole instructions, no
relative branches, nothing position-dependent. The prologue is verified before
patching and NSE refuses to hook on a mismatch.

**Finding the states.** Napoleon runs *many* `lua_State`s:

| state | identified by | holds |
|---|---|---|
| campaign scripting | global `conditions` assigned | `conditions`, `effect`, `EpisodicScripting` |
| campaign UI root | `CampaignUI` **and** `Component` assigned | `Component`, `UIComponent`, `Address` |
| battle | one of four sentinel command names (heuristic) | the 218-function battle API |
| ~100 per-component | (not tracked) | transient — pointers go stale |

Both campaign states are re-acquired on every campaign load, so reloading is
safe.

**Threading.** `lua_State` is not thread-safe and the engine's allocator and GC
assume single-threaded access. The pipe thread therefore **never touches Lua**:
it queues a request, and the `lua_getfield` hook — which runs constantly on the
game's own thread — drains it. This is the single most important safety property
in the design.

**Crash guard.** A vectored exception handler, armed only during evaluation,
turns an access violation into an error string instead of losing the session.
Honest caveat: `longjmp`ing out of a fault in engine code can leave state
inconsistent — it converts a *certain* crash into a *probable* recovery. Restart
if the game misbehaves afterwards.

---

## Traps

These are the ones that cost real time in Empire and apply unchanged here.

**`pcall` does not protect you.** The engine's script functions are native C that
dereference their arguments without validating. A wrong-arity or wrong-scoped
call is a hard access violation, not a catchable Lua error. `pcall` catches Lua
errors only. Use `NSE_Protect`.

**`context` is scoped, and the wrong scope returns silent zeros.** A faction
condition called with a settlement context returns `TurnNumber=0`,
`FactionTreasury=0`, `FactionName('france')=false` — no error, just wrong.
`docs/SCRIPT_API.md` gives the scope of all 138 events; match it, call inside
the handler while the context is live, and never store a context for later.

**`_G` is not the campaign globals table.** Measured live in Napoleon:

```
_G.conditions          -> nil          getfenv(1).conditions  -> table
rawget(_G,'NSE_Ping')  -> nil          getfenv(1).NSE_Ping    -> function
```

A native registered through `LUA_GLOBALSINDEX` works perfectly; `_G` just is not
the table it went into. Register via `LUA_GLOBALSINDEX`, and when you need to
inspect the globals **use `getfenv(1)`, never `_G`**. This one bit this project
during bring-up: `NSE.survey()` used `_G[name]`, reported every entry as `nil`,
and looked exactly like a total failure to load — while the handler two screens
away was happily calling `conditions.TurnNumber()`.

**Napoleon extends events through a module, not a global.** Empire exposes a
global `events` table. Napoleon goes through `EpisodicScripting`:

```lua
local scripting = require "EpisodicScripting"
scripting.AddEventCallBack("FactionTurnStart", function(context) ... end)
```

Its `AddEventCallBack` **appends** — read out of the shipped
`episodicscripting.lua` — so **no vanilla file ever needs editing**, and it
registers the handler for clean removal on teardown. `NSE.on()` wraps this.

**`FactionTurnStart` fires for every faction.** Filter first:

```lua
if not conditions.FactionIsLocal(context) then return end
```

**Napoleon fails quietly.** Wrong-scoped conditions return zeros; an autoexec
that runs before the scripting layer exists reports success and does nothing.
Verify positively; don't trust "no error".

---

## Extending it

**Lua** — edit `nse_autoexec.lua` in the game root. No rebuild; reload a
campaign and it re-runs.

**Native** — add to `kNatives[]` in `src/nse_proxy.c`:

```c
static int __cdecl nse_myfn(lua_State* L) {
    L_.pushlstring(L, "result", 6);
    return 1;                    /* number of return values */
}
static const struct { const char* name; lua_CFunction fn; } kNatives[] = {
    { "NSE_MyFn", nse_myfn },
    ...
};
```

Then `cd src; .\build.ps1 -Deploy` (game must be closed).

**Build requirements:** [Zig](https://ziglang.org/download/) (portable, no
installer). `build.ps1` finds it automatically nearby or on PATH; MinGW and MSVC
also work. It verifies the output is 32-bit (`0x014C`) and that the five
undecorated exports exist — a decorated export table makes the game refuse to
launch, so that check is not optional.

---

## Read this before writing anything

`docs/SCRIPT_API.md` is the real engine API, enumerated from the shipped binary
with usage examples, descriptions, per-parameter documentation and event context
scopes. A large amount of what looks like it needs a native extension already
exists in Napoleon's own API — it had simply never been enumerated.

`docs/PORTING.md` records how each claim in this project was established, and
which ones are still inference rather than evidence.
