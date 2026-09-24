# packtool.rb - list, extract from and build Napoleon: Total War .pack archives.
#
# Napoleon uses the SAME PFH0 container as Empire (verified: both boot.pack
# files begin "PFH0" and index identically), so this is format-compatible with
# the Empire tooling. It is Ruby rather than PowerShell because the shipped
# packs are large - data.pack is 2.8 GB, battleterrain.pack 2.2 GB - and a
# byte-at-a-time BinaryReader loop takes minutes where this takes under a
# second. Only the header and index are ever read for a listing.
#
# PFH0 LAYOUT
#   "PFH0"          4 bytes
#   type            int32   0 boot, 1 release, 2 patch, 3 mod, 4 movie
#   deps_count      int32
#   deps_len        int32   <-- byte length of the dependency block
#   files_count     int32
#   index_len       int32
#   [dependency block]      deps_len bytes
#   [index]                 index_len bytes; per file: int32 size, ASCII path, 0x00
#   [file blobs]            concatenated, in index order
#
# THE TRAP: vanilla packs carry a dependency block between the header and the
# index. Skipping it puts every data offset out by exactly deps_len, which
# yields plausible-looking garbage instead of an obvious failure. Mod packs
# usually have deps_len 0, which is why a reader that ignores the block appears
# to work right up until it is pointed at a shipped pack.
#
# Usage
#   ruby packtool.rb list   [pattern]                 list matching entries
#   ruby packtool.rb cat    <pattern>                 print one entry to stdout
#   ruby packtool.rb get    <pattern> [outdir]        extract matching entries
#   ruby packtool.rb build  <out.pack> <dir> [type]   build a pack from a folder
#   ruby packtool.rb info   <file.pack>               header summary
#
# Options (anywhere on the line)
#   --data <dir>   the game's data folder (default: two levels up from here)
#   --pack <name>  restrict to one pack, e.g. --pack data.pack
#   --max <n>      cap listing output (default 200, 0 = unlimited)

MAGIC = "PFH0".b

def opt(name, default = nil)
  i = ARGV.index("--#{name}")
  return default unless i && ARGV[i + 1]
  v = ARGV[i + 1]
  ARGV.delete_at(i); ARGV.delete_at(i)
  v
end

# Read only the header and index. Returns [type, deps_len, entries] where each
# entry is [path, size, absolute_offset].
def read_index(path)
  File.open(path, "rb") do |f|
    return nil unless f.read(4) == MAGIC
    type, _deps_count, deps_len, nfiles, index_len = f.read(20).unpack("V5")
    f.seek(24 + deps_len)
    idx = f.read(index_len).to_s
    data_at = 24 + deps_len + index_len
    entries = []
    off = data_at
    p = 0
    nfiles.times do
      break if p + 4 > idx.bytesize
      size = idx[p, 4].unpack1("V"); p += 4
      z = idx.index("\0", p)
      break unless z
      name = idx[p...z]; p = z + 1
      entries << [name, size, off]
      off += size
    end
    [type, deps_len, entries]
  end
end

def packs(data_dir, only)
  # Forward slashes: Dir.glob reads a backslash as an escape, so a Windows path
  # matches nothing and the listing comes back empty with no error at all.
  list = Dir.glob("#{data_dir.tr("\\", "/").chomp("/")}/*.pack").sort
  list = list.select { |p| File.basename(p).downcase == only.downcase } if only
  list
end

# A pack path uses backslashes; flatten it to something a filesystem will take
# on any OS, keeping the path readable.
def flat(name)
  name.gsub(/[^A-Za-z0-9._-]+/, "_")
end

TYPE_NAMES = { 0 => "boot", 1 => "release", 2 => "patch", 3 => "mod", 4 => "movie" }.freeze

begin
  require_relative "nse_locate"
rescue LoadError
  NseLocate = nil
end

data_dir = opt("data")
data_dir ||= NseLocate ? NseLocate.data_dir : File.expand_path("../../data", __dir__)
only     = opt("pack")
maxout   = (opt("max", "200")).to_i
cmd      = ARGV.shift

unless cmd
  warn "usage: ruby packtool.rb list|cat|get|build|info ...   (see the header of this file)"
  exit 1
end
# `build` writes a pack and never reads the game's data, so it must not be
# blocked by a missing install.
if cmd != "build" && !(data_dir && Dir.exist?(data_dir))
  abort(NseLocate ? NseLocate.explain("the game's data folder", "--data")
                  : "data dir not found: #{data_dir}")
end

case cmd
when "info"
  target = ARGV.shift or abort "info needs a .pack path"
  # A bare name means "in the data folder"; anything that already resolves is
  # taken as given, so you can point this at a mod pack you just built.
  target = File.join(data_dir, target) unless File.file?(target)
  abort "no such pack: #{target}" unless File.file?(target)
  type, deps_len, entries = read_index(target)
  abort "not a PFH0 pack: #{target}" unless entries
  total = entries.sum { |_, s, _| s }
  puts "#{File.basename(target)}"
  puts "  type       #{type} (#{TYPE_NAMES[type] || '?'})"
  puts "  deps block #{deps_len} bytes"
  puts "  files      #{entries.size}"
  puts "  payload    #{total} bytes"

when "list", "cat", "get"
  pattern = ARGV.shift
  if cmd != "list" && pattern.nil?
    abort "#{cmd} needs a pattern"
  end
  outdir = (cmd == "get" ? (ARGV.shift || ".") : nil)
  Dir.mkdir(outdir) if outdir && !Dir.exist?(outdir)

  shown = 0
  packs(data_dir, only).each do |p|
    got = read_index(p)
    next unless got
    _type, _dl, entries = got
    entries.each do |name, size, off|
      next if pattern && !name.downcase.include?(pattern.downcase)
      case cmd
      when "list"
        if maxout.zero? || shown < maxout
          puts format("%-22s %-64s %10d @ %d", File.basename(p), name, size, off)
        end
        shown += 1
      when "cat"
        File.open(p, "rb") { |f| f.seek(off); $stdout.write(f.read(size)) }
        exit 0
      when "get"
        dest = File.join(outdir, flat(name))
        File.open(p, "rb") { |f| f.seek(off); File.binwrite(dest, f.read(size)) }
        # A Lua chunk starts 1B 4C 75 61. Cheap proof the offset arithmetic was
        # right, since a wrong offset gives plausible garbage, not an error.
        head = File.binread(dest, 4).to_s
        tag = head == "\x1BLua".b ? "Lua 5.1 bytecode" : "sig #{head.unpack1('H*')}"
        puts "#{name}  ->  #{dest}  (#{size} bytes, #{tag})"
        shown += 1
      end
    end
  end
  if cmd == "cat"
    warn "no entry matching #{pattern.inspect}"
    exit 1
  end
  puts "#{shown} entr#{shown == 1 ? 'y' : 'ies'}#{maxout.positive? && shown > maxout ? " (#{maxout} shown)" : ''}" if cmd == "list"

when "build"
  out  = ARGV.shift or abort "build needs an output .pack path"
  src  = ARGV.shift or abort "build needs a source directory"
  type = (ARGV.shift || "3").to_i    # 3 = mod, which is what you almost always want
  abort "source directory not found: #{src}" unless Dir.exist?(src)

  # Dir.glob treats a backslash as an ESCAPE character, not a separator, so a
  # Windows path silently matches nothing and the build reports an empty source
  # directory that is plainly full of files. Normalise first.
  src = src.tr("\\", "/").chomp("/")
  files = Dir.glob("#{src}/**/*").select { |f| File.file?(f) }.sort
  abort "no files under #{src}" if files.empty?

  # Pack paths are backslash-separated and relative to the source root; the
  # game matches them against its own virtual tree, so getting the separator
  # wrong means the file is simply never found - silently.
  index = +"".b
  blobs = +"".b
  files.each do |f|
    rel = f.sub(/\A#{Regexp.escape(src)}\//, "").tr("/", "\\")
    data = File.binread(f)
    index << [data.bytesize].pack("V") << rel.b << "\0".b
    blobs << data
  end

  # deps_count 0 and deps_len 0: a mod pack declares no dependency block.
  header = MAGIC + [type, 0, 0, files.size, index.bytesize].pack("V5")
  File.binwrite(out, header + index + blobs)
  puts "wrote #{out}"
  puts "  type #{type} (#{TYPE_NAMES[type] || '?'}), #{files.size} files, #{blobs.bytesize} bytes of payload"
  files.first(20).each { |f| puts "    #{f.sub(/\A#{Regexp.escape(src)}\//, '').tr('/', '\\')}" }
  puts "    ... and #{files.size - 20} more" if files.size > 20

else
  abort "unknown command #{cmd.inspect}"
end
