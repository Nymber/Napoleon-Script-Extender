# dump_script_api.rb - recover Napoleon's scripting API from Napoleon.exe,
# statically, without running the game.
#
# WHY THIS EXISTS
#   Calling a scripting function with the wrong argument shape does NOT raise a
#   Lua error. It reaches native C that dereferences its arguments without
#   validating them, and the process dies. `pcall` does not help - it catches
#   Lua errors, and an access violation is not one. So "just try it and see" is
#   paid for in crashed campaigns.
#
#   Everything needed is already in the binary. Each scripting function is
#   registered by a fixed code sequence of `push imm32` instructions followed by
#   a call to a per-namespace registrar, and the pushed pointers are the name,
#   the usage example, the description and the per-parameter documentation.
#   Walking back from every call site recovers all of it.
#
# TWO SHAPES, because Napoleon uses two registration idioms:
#
#   A. name LAST (conditions, effects, events)
#        push <native function>
#        push <parameter doc>      (zero or more)
#        push <usage example>
#        push <description>
#        push <name>
#        mov ecx, <registry> ; call <registrar>
#
#   B. name in the MIDDLE (CampaignUI, battle and frontend commands)
#        push <description>
#        push <name>
#        push <native function>
#        mov ecx, <context> ; call <registrar>
#
#   Feeding shape B to a shape-A parser yields the function POINTER as a
#   "name" and silent nonsense, so the two are handled explicitly rather than
#   guessed at.
#
# NAPOLEON'S REGISTRARS (discovered by this tool's own --discover mode against
# Napoleon.exe 1.3.0, ImageBase 0x00400000):
#
#   shape A   00DF15C0   308  conditions      TurnNumber, FactionIsLocal, ...
#   shape A   00DF2F40   138  events          BattleCompleted, CharacterCreated, ...
#   shape A   00DF18C0    13  effects         adjust_treasury, ancillary, ...
#   shape B   00998C50   339  campaign UI     AgentCardSelectionChanged, ...
#   shape B   0059EB40   218  battle          AddUnitsToGroup, Anchor, ...
#   shape B   004587A0   118  frontend        ArmyFundsForSize, ...
#
#   These addresses are for one build. If a patch moves them, run --discover
#   again rather than trusting the table above.
#
# Usage
#   ruby dump_script_api.rb --discover              find the registrars
#   ruby dump_script_api.rb conditions              dump one known namespace
#   ruby dump_script_api.rb all --md out.md         write the full reference
#   ruby dump_script_api.rb events --match Battle
#   ruby dump_script_api.rb --registrar 0xDF15C0 --shape a

IMAGE_BASE = 0x400000

# name => [registrar, shape, human label]
KNOWN = {
  "conditions" => [0x00DF15C0, :a, "conditions - queries you may call from campaign script"],
  "events"     => [0x00DF2F40, :e, "events - callback lists you may append handlers to"],
  "effects"    => [0x00DF18C0, :a, "effects - the `effect` table; these CHANGE game state"],
  "campaignui" => [0x00998C50, :b, "campaign UI commands (the CampaignUI global)"],
  "battle"     => [0x0059EB40, :b, "battle script commands (battle lua_State only)"],
  "frontend"   => [0x004587A0, :b, "frontend / menu commands"],
}.freeze

def arg(name, default = nil)
  i = ARGV.index("--#{name}")
  return default unless i && ARGV[i + 1]
  v = ARGV[i + 1]
  ARGV.delete_at(i); ARGV.delete_at(i)
  v
end

def flag(name)
  !!ARGV.delete("--#{name}")
end

discover = flag("discover")
match    = arg("match")
md_out   = arg("md")
csv_out  = arg("csv")
reg_arg  = arg("registrar")
shape_arg = arg("shape")
# The locator handles Steam libraries on other drives, GOG/retail installs and
# $NSE_GAME. If this file has been copied somewhere on its own, fall back to the
# relative default so it still works in the usual layout.
begin
  require_relative "nse_locate"
rescue LoadError
  NseLocate = nil
end

exe = arg("exe")
exe ||= NseLocate ? NseLocate.exe : File.expand_path("../../Napoleon.exe", __dir__)
unless exe && File.file?(exe)
  abort(NseLocate ? NseLocate.explain("Napoleon.exe", "--exe")
                  : "Napoleon.exe not found at #{exe} (pass --exe <path>)")
end

D = File.binread(exe)
pe = D[0x3c, 4].unpack1("V")
abort "not a PE image: #{exe}" unless D[pe, 4] == "PE\0\0"
nsec  = D[pe + 6, 2].unpack1("v")
optsz = D[pe + 20, 2].unpack1("v")
opt   = pe + 24
SECS = (0...nsec).map do |i|
  o = opt + optsz + i * 40
  name = D[o, 8].delete("\0")
  vsz, va, _rsz, ra = D[o + 8, 16].unpack("V4")
  [name, IMAGE_BASE + va, vsz, ra]
end

def va2fo(va)
  SECS.each { |_n, base, len, fo| return fo + (va - base) if va >= base && va < base + len }
  nil
end

# A pushed pointer is only a string if it lands in a mapped section AND the
# bytes there are printable and null-terminated. Anything else is a function
# pointer, a vtable or an integer, and must not be reported as documentation.
def str_at(va)
  fo = va2fo(va)
  return nil unless fo
  z = D.index("\0".b, fo)
  return nil unless z && (2...300).cover?(z - fo)
  s = D[fo...z]
  s.bytes.all? { |c| c >= 32 && c < 127 } ? s : nil
end

TEXT_NAME, TEXT_VA, TEXT_LEN, TEXT_FO = SECS.find { |n, _| n == ".text" }
abort "no .text section" unless TEXT_NAME

# Scan every `call rel32` in .text, group the call sites by target, and for each
# one walk backwards over the contiguous run of `push imm32` that feeds it.
def collect
  rows = Hash.new { |h, k| h[k] = [] }
  fo = TEXT_FO
  tend = TEXT_FO + TEXT_LEN - 5
  while fo < tend
    fo = D.index("\xE8".b, fo)
    break if fo.nil? || fo >= tend
    site = fo
    fo += 1
    va = TEXT_VA + (site - TEXT_FO)
    rel = D[site + 1, 4].unpack1("l<")
    # Mask to 32 bits: a backwards branch is negative and would otherwise fall
    # outside the image and be discarded.
    tgt = (va + 5 + rel) & 0xFFFF_FFFF
    next unless tgt >= TEXT_VA && tgt < TEXT_VA + TEXT_LEN

    p = site
    p -= 5 if p - 5 >= TEXT_FO && D.getbyte(p - 5) == 0xB9   # mov ecx, imm32
    pushes = []
    while p - 5 >= TEXT_FO && D.getbyte(p - 5) == 0x68        # push imm32
      p -= 5
      pushes.unshift(D[p + 1, 4].unpack1("V"))
    end
    next if pushes.size < 3
    rows[tgt] << pushes
  end
  rows
end

# Shape A's middle pushes are POSITIONAL, established by reading a dozen entries
# whose meaning is unambiguous:
#
#   [0] the implementing function
#   [1] the CA developer who wrote it ("Guy", "Paul", "Tom", "Ed", "Alan", ...)
#   [2] a usage example
#   [3] the description
#   [4..] one doc string per parameter
#   [-1] the name
#
# That [1] slot is the trap: parsed as documentation it produces entries whose
# first "doc" line is a first name, which reads like corrupt output. It is a
# byline, and it is reported as one.
#
# The parameter doc is the field worth reading. For RegionSlotBuildingTypeExists
# the description says "a building of the specified type", which sounds like a
# building TYPE, while the parameter doc says "The key of the building level you
# are querying from the building_levels table". They disagree, and the parameter
# doc is the one that matches what the code actually does.
Entry = Struct.new(:name, :func, :author, :usage, :desc, :params, :scope)

def parse(pushes, shape)
  if shape == :a || shape == :e
    name = str_at(pushes[-1])
    return nil unless name =~ /\A[A-Za-z_][A-Za-z0-9_]*\z/
    mid = pushes[1..-2].map { |v| str_at(v) }
    # Events use a shorter form: [registry object, context scope, description].
    # That scope field is the most useful thing in this whole dump - see the
    # note above KNOWN.
    return Entry.new(name, pushes[0], nil, nil, mid[1], [], mid[0]) if shape == :e
    Entry.new(name, pushes[0], mid[0], mid[1], mid[2], mid[3..].to_a.compact, nil)
  else
    return nil if pushes.size != 3
    name = str_at(pushes[-2])
    return nil unless name =~ /\A[A-Za-z_][A-Za-z0-9_]*\z/
    Entry.new(name, pushes[-1], nil, nil, str_at(pushes[-3]), [], nil)
  end
end

ROWS = collect

if discover
  puts "Registrars in #{File.basename(exe)} (each is a separate scripting namespace)"
  puts
  [[:a, "name last  (conditions / effects / events)"],
   [:b, "name middle (UI / battle / frontend)"]].each do |shape, label|
    puts "  shape #{shape.to_s.upcase} - #{label}"
    found = ROWS.map { |reg, list|
      parsed = list.map { |p| parse(p, shape) }.compact
      [reg, parsed]
    }.reject { |_, p| p.size < 4 }.sort_by { |_, p| -p.size }
    found.first(8).each do |reg, p|
      # :e (events) is a sub-shape of :a - same walk, shorter field list - so a
      # discovery pass run as :a must still recognise it.
      known = KNOWN.find { |_k, (r, s, _)| r == reg && (s == shape || (shape == :a && s == :e)) }
      tag = known ? "  <- #{known[0]}" : ""
      puts format("    %08X  %4d entries   e.g. %s%s", reg, p.size,
                  p.first(4).map(&:name).join(", "), tag)
    end
    puts
  end
  exit 0
end

def namespace(reg, shape, label, match)
  rows = (ROWS[reg] || []).map { |p| parse(p, shape) }.compact
  rows = rows.uniq(&:name).sort_by(&:name)
  rows = rows.select { |e| "#{e.name} #{e.usage} #{e.desc} #{e.scope} #{e.params.join(' ')}" =~ /#{match}/i } if match
  [label, rows]
end

targets =
  if reg_arg
    shape = (shape_arg || "a").downcase.to_sym
    [namespace(Integer(reg_arg, 16), shape, format("registrar %08X (shape %s)", Integer(reg_arg, 16), shape), match)]
  else
    which = ARGV.shift || "all"
    keys = which == "all" ? KNOWN.keys : [which.downcase]
    keys.map do |k|
      spec = KNOWN[k] or abort "unknown namespace #{k.inspect} - one of: #{KNOWN.keys.join(', ')}, or all"
      namespace(spec[0], spec[1], spec[2], match)
    end
  end

if md_out
  out = +"# Napoleon: Total War - scripting API\n\n"
  out << "Enumerated from `#{File.basename(exe)}` by `tools/dump_script_api.rb`.\n"
  out << "Every entry below is a real registration in the shipped binary - not a\n"
  out << "guess, and not carried over from Empire.\n\n"
  targets.each do |label, rows|
    out << "## #{label}\n\n#{rows.size} entries.\n\n"
    cell = ->(s) { s.to_s.gsub("|", "\\|").gsub("\n", " ") }
    if rows.first&.scope
      out << "| event | context scope | when it fires |\n|---|---|---|\n"
      rows.each { |e| out << "| `#{e.name}` | **#{cell.(e.scope)}** | #{cell.(e.desc)} |\n" }
    else
      out << "| name | usage | what it does |\n|---|---|---|\n"
      rows.each { |e| out << "| `#{e.name}` | #{e.usage ? "`#{cell.(e.usage)}`" : ''} | #{cell.(e.desc)} |\n" }
    end
    out << "\n"
    detailed = rows.select { |e| e.params.any? }
    next if detailed.empty?
    out << "### Parameters\n\n"
    detailed.each do |e|
      out << "**`#{e.name}`** &mdash; `0x#{format('%08X', e.func)}`#{e.author ? " (CA: #{e.author})" : ''}\n\n"
      e.params.each { |p| out << "- #{p}\n" }
      out << "\n"
    end
  end
  File.write(md_out, out)
  warn "wrote #{md_out} (#{targets.sum { |_, r| r.size }} entries)"
  exit 0
end

if csv_out
  require "csv"
  CSV.open(csv_out, "wb") do |c|
    c << %w[namespace name func author scope usage description parameters]
    targets.each do |label, rows|
      rows.each { |e| c << [label, e.name, format("%08X", e.func), e.author, e.scope, e.usage, e.desc, e.params.join(" || ")] }
    end
  end
  warn "wrote #{csv_out}"
  exit 0
end

targets.each do |label, rows|
  puts "== #{label}"
  puts "   #{rows.size} entries"
  puts
  rows.each do |e|
    puts format("%08X  %s", e.func, e.name)
    puts "    scope  : #{e.scope}"  if e.scope
    puts "    usage  : #{e.usage}"  if e.usage
    puts "    does   : #{e.desc}"   if e.desc
    e.params.each { |p| puts "    param  : #{p}" }
    puts "    CA     : #{e.author}" if e.author
  end
  puts
end
