# Making a Napoleon mod

Two routes, and most real mods use both.

- **Script** — behaviour. Event handlers, missions, economy rules. Goes in
  `nse_autoexec.lua`, needs no pack and no restart.
- **Data** — content. Units, buildings, costs, text. Goes in a `.pack` and needs
  a game restart.

This covers the data side, and where the two meet. For the script side start
with `lua/nse_autoexec.lua` and `SCRIPT_API.md`.

---

## The data layout

```
data\*.pack                     the shipped archives (PFH0 containers)
  db\<table>_tables\<table>      versioned binary tables
  text\localisation.loc          the text the player sees
  text\ui.loc
  ui\...luac                     compiled UI scripts
  *.lua                          a few scripts ship uncompiled
```

Later packs win. `local_en_patch.pack` overrides `local_en.pack`; a mod pack
overrides both. That load order is how modding works here — you never edit a
shipped pack, you ship a smaller one that shadows the entries you care about.

---

## Looking at what is there

```powershell
cd tools

ruby packtool.rb list units                       # find entries by substring
ruby packtool.rb info data.pack                   # header summary
ruby packtool.rb get "db\units_tables\units" out  # extract
ruby packtool.rb cat "episodicscripting.lua"      # straight to stdout
```

`packtool.rb list` with no pattern lists everything, which is a lot — `--max`
caps it and `--pack data.pack` narrows the search.

### db tables

```powershell
ruby dbread.rb --in-pack "db\units_tables\units" --cols key,on_screen_name,create_cost --limit 10
ruby dbread.rb --in-pack "db\unit_stats_land_tables\unit_stats_land" --csv land.csv
```

`--in-pack` reads straight out of the shipped packs, honouring load order, so
you never extract first.

A db file is `[optional guid][optional version marker][flag][row count]` then
packed rows. The schema comes from `master_schema.xml`, which is **not bundled**
— get it from SaveParser or RPFM (`NOTICE.md` has the links and the reason), then
drop it beside `dbread.rb`, set `TW_MASTER_SCHEMA`, or pass `--schema`.
`master_schema.xml` often carries several
definitions for one table and version, so `dbread.rb` decodes **every** candidate
in full and takes the one that consumes the file exactly. If none does, it says
so rather than reporting guesses:

```
db_unit_stats_land_tables_unit_stats_land: version 5, 328 rows (flag 1)
  candidate 1 (84 fields): Encoding::InvalidByteSequenceError - incomplete
  candidate 2 (89 fields): EXACT - consumed all 230201 bytes
```

Napoleon's table versions are **not** Empire's — `units` is version 4 here,
version 2 there. Never assume a schema transfers.

### Localisation

```powershell
ruby packtool.rb get "text\localisation.loc" out
ruby loctool.rb verify out\text_localisation.loc
ruby loctool.rb list   out\text_localisation.loc unit_description
ruby loctool.rb add    out\text_localisation.loc my_key "My text" --apply
ruby loctool.rb addfile out\text_localisation.loc entries.txt --apply
```

Every write re-reads the file afterwards and refuses to report success unless it
round-trips. `verify` on its own answers "did I decode this correctly" — it
consumes the file to EOF or tells you how many bytes were left over.

The `.loc` format is UTF-16LE with a **trailing flag byte per entry**. That byte
is why a naive "split on nulls" decode produces interleaved garbage: it leaves
every following entry off by one. Flag 1 is what real entries use; flag 0 also
occurs and is not an error marker, so a missing string is never explained by it.

An `addfile` batch file is `key|value` per line, `#` for comments, and a literal
`\n` in the value becomes a real newline — long descriptions are
multi-paragraph and the file is line-based.

---

## Building a mod pack

```powershell
ruby packtool.rb build mymod.pack .\mymod_root
```

`mymod_root` mirrors the pack's internal tree:

```
mymod_root\
  db\units_tables\units
  text\localisation.loc
```

The tool writes a type-3 (mod) pack with no dependency block. Internal paths use
backslashes and are relative to the root you gave it — get the separator wrong
and the game simply never finds the file, silently.

Check what you built before shipping it:

```powershell
ruby packtool.rb info mymod.pack
ruby packtool.rb list --pack mymod.pack
```

### Getting the game to load it

Put the pack in `data\`, then create

```
%APPDATA%\The Creative Assembly\Napoleon\scripts\user.script.txt
```

containing one line per mod:

```
mod "mymod.pack";
```

That folder already exists (it holds `preferences.script.txt`); the
`user.script.txt` beside it is what you add.

---

## Where script and data meet

A new unit needs rows in several tables **and** localisation keys **and** often
a script to make it available. The failure mode is always the same: the game
finds nothing and shows nothing.

- A db row referencing a key that does not exist in another table is not an
  error — the unit is simply never offered.
- A missing `.loc` key shows as blank or as the raw key, not as an error.
- `AddEventCallBack` on an event name that does not exist **does** assert, which
  is the one place this engine is loud. `NSE.on()` surfaces that rather than
  falling through and appending blindly.

So verify positively. After a change, ask the running game what it thinks:

```powershell
cd tools
.\nse.ps1 "return NSE.ask('TurnNumber')"
.\nse.ps1 "return NSE.keys(conditions, 40)"
.\nse.ps1 "return NSE.why()"
```

---

## Scripting without editing vanilla files

You never need to. Napoleon's own extension point appends:

```lua
local scripting = require "EpisodicScripting"
scripting.AddEventCallBack("FactionTurnStart", handler)
```

The engine, the UI layer and every other mod chain onto the same lists. `NSE.on()`
wraps this with the crash guard and tells you if the event name was rejected.

Read `SCRIPT_API.md` before writing a handler. It gives each event's **context
scope**, and calling a condition with a context from the wrong scope does not
error — it returns zero. That is the single most expensive mistake available in
this engine, and the scope column is there to make it avoidable.
