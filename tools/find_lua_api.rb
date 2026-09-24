# find_lua_api.rb - locate Napoleon's statically-linked Lua 5.1 C API by
# signature.
#
# NEEDS ONLY Napoleon.exe. The signatures ship with this project, in
# lua_api_signatures.json beside this file. Empire: Total War is NOT required
# and never was at run time - it was the source the signatures were originally
# derived FROM, which is a fact about their history, not a dependency.
#
# WHY
#   NSE hooks lua_getfield and lua_setfield and calls eight more Lua C API
#   functions directly. Their addresses are baked into src/nse_proxy.c. Nothing
#   published gives them for Napoleon, and a patch can move them. This tool
#   derives them, and re-derives them, from evidence.
#
# THE OPTIONAL --ref PATH
#   --ref <Empire.exe> re-derives the signatures from a reference binary instead
#   of reading the cache, and --emit-signatures writes the cache back out. You
#   need this only if lua_api_signatures.json is lost, or you want a wider
#   window than 96 bytes. Ordinary use never touches it.
#
#   An earlier version of this tool required --ref on every run, which made the
#   documented recovery-after-a-patch workflow depend on owning a second game -
#   a hole in exactly the procedure you reach for when things are already
#   broken. Hence the cache.
#
# HOW
#   Both games statically link the SAME Lua 5.1 build. Take the bytes of each
#   function out of Empire.exe at its known address, mask the parts that
#   relocation changes, and search Napoleon's .text for what is left:
#
#     - the 4 bytes after E8 (call rel32) and E9 (jmp rel32) are displacements,
#       different in every image - masked
#     - any 4-byte value that reads as an address inside the image is an
#       absolute reference to .data or .rdata - masked
#     - everything else is opcode and encoding, identical between the two
#
#   Roughly 80% of each 96-byte window survives masking, which is far more than
#   enough to be unique.
#
# THE CROSS-CHECK THAT MAKES THIS TRUSTWORTHY
#   A single unique hit per function is suggestive. The proof is that the
#   RELATIVE OFFSETS between the ten functions are identical in both binaries:
#
#     getfield +0     gettop +0xE0    pcall +0x430    pushcclosure +0x4D0
#     pushlstring +0x5D0   setfield +0xA00   settop +0xB40   tolstring +0xCB0
#     type +0xE10     loadbuffer +0x1730
#
#   Ten functions landing at ten matching offsets is not coincidence; it is the
#   same object file, relocated. Napoleon's copy sits 0xE1B70 above Empire's.
#   --verify reports this, and any mismatch means the assumption has broken and
#   the result should not be used.
#
# Usage
#   ruby find_lua_api.rb                    locate everything, print a C header
#   ruby find_lua_api.rb --verify           also run the relative-offset check
#   ruby find_lua_api.rb --exe <path>       a different target binary
#   ruby find_lua_api.rb --ref <Empire.exe> --emit-signatures
#                                           rebuild lua_api_signatures.json

IMAGE_BASE = 0x400000
SIG_LEN    = 96

# Empire: Total War 1.5.0.0 addresses. These are the reference, not the answer.
REFERENCE = {
  "lua_getfield"     => 0x00F07420,
  "lua_gettop"       => 0x00F07500,
  "lua_pcall"        => 0x00F07850,
  "lua_pushcclosure" => 0x00F078F0,
  "lua_pushlstring"  => 0x00F079F0,
  "lua_setfield"     => 0x00F07E20,
  "lua_settop"       => 0x00F07F60,
  "lua_tolstring"    => 0x00F080D0,
  "lua_type"         => 0x00F08230,
  "luaL_loadbuffer"  => 0x00F08B50,
}.freeze

def arg(n, d = nil)
  i = ARGV.index("--#{n}")
  return d unless i && ARGV[i + 1]
  v = ARGV[i + 1]; ARGV.delete_at(i); ARGV.delete_at(i); v
end

require "json"
begin
  require_relative "nse_locate"
rescue LoadError
  NseLocate = nil
end

verify  = !!ARGV.delete("--verify")
emit    = !!ARGV.delete("--emit-signatures")
exe     = arg("exe")
exe   ||= NseLocate ? NseLocate.exe : File.expand_path("../../Napoleon.exe", __dir__)
ref     = arg("ref")
sig_path = arg("signatures", File.expand_path("lua_api_signatures.json", __dir__))

unless exe && File.file?(exe)
  abort(NseLocate ? NseLocate.explain("Napoleon.exe", "--exe")
                  : "target not found: #{exe} (pass --exe <path>)")
end
if ref && !File.file?(ref)
  abort "reference not found: #{ref}"
end
if !ref && !File.file?(sig_path)
  abort "no signatures and no reference binary.\n" \
        "  expected #{sig_path}\n" \
        "  or pass --ref <path to Empire.exe> to derive them from source."
end

def sections(d)
  pe = d[0x3c, 4].unpack1("V")
  raise "not a PE image" unless d[pe, 4] == "PE\0\0"
  nsec  = d[pe + 6, 2].unpack1("v")
  optsz = d[pe + 20, 2].unpack1("v")
  opt   = pe + 24
  (0...nsec).map do |i|
    o = opt + optsz + i * 40
    vsz, va, rsz, ra = d[o + 8, 16].unpack("V4")
    [d[o, 8].delete("\0"), IMAGE_BASE + va, vsz, ra, rsz]
  end
end

def va2fo(secs, va)
  secs.each { |_n, base, vsz, ra, rsz| return ra + (va - base) if va >= base && va < base + [vsz, rsz].max }
  nil
end

# Returns [bytes, mask] where mask[i] == 1 means "this byte must match".
def masked(window, lo, hi)
  b = window.bytes
  m = Array.new(b.size, 1)
  i = 0
  while i < b.size - 4
    if b[i] == 0xE8 || b[i] == 0xE9
      4.times { |k| m[i + 1 + k] = 0 }
      i += 5
      next
    end
    dw = window[i, 4].unpack1("V")
    if dw >= lo && dw < hi
      4.times { |k| m[i + k] = 0 }
      i += 4
      next
    end
    i += 1
  end
  [b, m]
end

# Anchor on the longest unbroken run of must-match bytes, then verify the whole
# window. Searching on the anchor keeps this fast over a 16 MB .text.
def scan(hay, bytes, mask)
  run = 0
  best = [0, 0]
  mask.each_with_index do |v, i|
    if v == 1
      run += 1
      best = [run, i - run + 1] if run > best[0]
    else
      run = 0
    end
  end
  alen, aoff = best
  return [] if alen < 6
  anchor = bytes[aoff, alen].pack("C*")
  hits = []
  pos = 0
  while (i = hay.index(anchor, pos))
    pos = i + 1
    st = i - aoff
    next if st.negative? || st + bytes.size > hay.bytesize
    ok = true
    bytes.each_index do |k|
      next unless mask[k] == 1
      if hay.getbyte(st + k) != bytes[k]
        ok = false
        break
      end
    end
    hits << st if ok
    break if hits.size > 8
  end
  hits
end

dst  = File.binread(exe)
dsec = sections(dst)
_dn, dva, _dvsz, dra, drs = dsec.find { |n, _| n == ".text" }
hay = dst[dra, drs]

# Signatures come from the cache, or are derived fresh if a reference binary was
# given. The cache stores only the MASKED pattern - the bytes that relocation
# does not touch - which is what an interoperability signature is. See NOTICE.
sigs = {}
if ref
  src  = File.binread(ref)
  ssec = sections(src)
  REFERENCE.each do |name, va|
    fo = va2fo(ssec, va)
    bytes, mask = masked(src[fo, SIG_LEN], IMAGE_BASE, IMAGE_BASE + 0x1500000)
    # Blank the masked-out bytes so the cache carries no relocation-specific
    # data from the reference image.
    bytes = bytes.each_with_index.map { |b, i| mask[i] == 1 ? b : 0 }
    sigs[name] = { "ref_va" => va, "bytes" => bytes, "mask" => mask }
  end
  if emit
    File.write(sig_path, JSON.pretty_generate(
      "_comment"  => "Masked Lua 5.1 C API signatures, derived from Empire: Total War 1.5.0.0. " \
                     "Masked bytes are zeroed. Regenerate with: ruby find_lua_api.rb --ref <Empire.exe> --emit-signatures",
      "sig_len"   => SIG_LEN,
      "functions" => sigs))
    $stderr.puts "wrote #{sig_path} (#{sigs.size} signatures)"
    exit 0
  end
else
  cache = JSON.parse(File.read(sig_path))
  cache["functions"].each { |k, v| sigs[k] = v }
end

found  = {}
report = []
REFERENCE.each_key do |name|
  s = sigs[name] or abort "no signature for #{name} in #{sig_path}"
  bytes = s["bytes"] || s[:bytes]
  mask  = s["mask"]  || s[:mask]
  hits  = scan(hay, bytes, mask)
  addrs = hits.map { |h| dva + h }
  found[name] = addrs.first if addrs.size == 1
  report << [name, mask.count(1), hits.size, addrs]
end

$stderr.puts "signatures: #{ref ? File.basename(ref) + ' (live)' : File.basename(sig_path)}"
$stderr.puts "target    : #{File.basename(exe)}"
$stderr.puts
report.each do |name, must, n, addrs|
  $stderr.puts format("  %-18s %2d/%d bytes fixed  %s",
                      name, must, SIG_LEN,
                      n == 1 ? format("-> 0x%08X", addrs[0]) :
                      n.zero? ? "NO MATCH" : "AMBIGUOUS (#{n} hits: #{addrs.map { |a| format('0x%08X', a) }.join(' ')})")
end
$stderr.puts

missing = REFERENCE.keys - found.keys
unless missing.empty?
  $stderr.puts "FAILED for: #{missing.join(', ')}"
  $stderr.puts "Do not paste a partial result into nse_proxy.c. Either the binary is a"
  $stderr.puts "different build, or the Lua object file differs and the signatures need"
  $stderr.puts "rebuilding by hand from a disassembly."
  exit 1
end

if verify
  base_ref = REFERENCE["lua_getfield"]
  base_new = found["lua_getfield"]
  $stderr.puts "relative-layout cross-check (offsets from lua_getfield):"
  bad = 0
  REFERENCE.each do |name, va|
    a = va - base_ref
    b = found[name] - base_new
    same = a == b
    bad += 1 unless same
    $stderr.puts format("  %-18s ref +0x%-6X  target +0x%-6X  %s", name, a, b, same ? "match" : "DIFFER")
  end
  $stderr.puts
  if bad.zero?
    $stderr.puts format("all %d offsets match - same Lua object file, relocated by 0x%X",
                        REFERENCE.size, base_new - base_ref)
  else
    $stderr.puts "#{bad} offset(s) differ. The two binaries do NOT share a Lua build;"
    $stderr.puts "the addresses above are individually plausible but collectively unproven."
    exit 1
  end
  $stderr.puts
end

# The point of the tool: something you can paste straight into nse_proxy.c.
puts "/* generated by tools/find_lua_api.rb from #{File.basename(exe)} */"
REFERENCE.each_key do |name|
  puts format("#define A_%-18s 0x%08X", name, found[name])
end

# The hook site prologue must also be checked: NSE steals 5 bytes from
# lua_getfield and lua_setfield, and refuses to patch if they are not what it
# expects. Print what is actually there so the constant in nse_proxy.c can be
# confirmed rather than assumed.
puts
%w[lua_getfield lua_setfield].each do |name|
  fo = va2fo(dsec, found[name])
  bytes = dst[fo, 5].bytes.map { |b| format("0x%02X", b) }.join(",")
  puts "/* #{name} prologue: #{bytes} */"
end
