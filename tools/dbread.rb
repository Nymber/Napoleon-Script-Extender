# dbread.rb - read a VERSIONED Napoleon DB table.
#
# Napoleon's db files use the same container as Empire's, at different table
# versions: Napoleon's `units` is version 4 where Empire's is 2. Verified by
# decoding db\units_tables\units straight out of data.pack - 442 rows, 25
# fields, all 170,171 bytes consumed exactly.
#
#   HEADER
#     [fd fe fc ff][i32 guid_char_len][UTF-16LE guid]   optional
#     [fc fd fe ff][i32 version]                        optional
#     [u8 unknown/flag][i32 row_count]
#
#   FIELD ENCODING
#     string / string_ascii   u16 length, then UTF-16LE / ASCII
#     optstring*              u8 present flag, then the string if present
#     int                     i32      float  f32      boolean  u8
#
# master_schema.xml often carries SEVERAL definitions for one table+version
# (unit_stats_land v1 has an 82-field and an 84-field form). Rather than guess,
# every candidate is decoded in full and the one that consumes the file EXACTLY
# wins - the same proof used for the .loc format. If none consumes it exactly,
# this reports that instead of returning plausible-looking garbage.
#
# Usage
#   ruby dbread.rb <file> <table_name> [--cols a,b,c] [--csv out.csv] [--limit N]
#   ruby dbread.rb --in-pack db\units_tables\units [--cols ...]
#
# --in-pack reads the table straight out of the shipped packs, so you never
# have to extract first. Later packs win, which is the game's own load order -
# local_en_patch.pack overriding local_en.pack, and so on.
#
# The table name may be given with or without the "_tables" suffix; the schema
# uses the suffixed form (units_tables), the pack path uses both
# (db\units_tables\units).

require "nokogiri"

def opt(n, d = nil)
  i = ARGV.index("--#{n}")
  return d unless i && ARGV[i + 1]
  v = ARGV[i + 1]
  ARGV.delete_at(i); ARGV.delete_at(i)
  v
end

in_pack = opt("in-pack")
want  = opt("cols")&.split(",")
csv   = opt("csv")
limit = (opt("limit") || "20").to_i
begin
  require_relative "nse_locate"
rescue LoadError
  NseLocate = nil
end

data_dir = opt("data")
data_dir ||= NseLocate ? NseLocate.data_dir : File.expand_path("../../data", __dir__)

# The schema is NOT bundled. master_schema.xml ships with SaveParser, which
# states no licence, so redistributing it here would be presumptuous - see
# NOTICE. Point --schema at your own copy, or drop one beside this file.
schema_path = opt("schema")
unless schema_path
  candidates = [
    File.expand_path("master_schema.xml", __dir__),
    File.expand_path("../master_schema.xml", __dir__),
    ENV["TW_MASTER_SCHEMA"],
  ].compact
  schema_path = candidates.find { |p| File.file?(p) }
end
unless schema_path && File.file?(schema_path)
  abort <<~MSG
    master_schema.xml not found.

    It maps each db table+version onto its field list. Without it a db file is
    just bytes - the row count is readable, the columns are not.

    Get it from either:
      SaveParser  https://sourceforge.net/projects/saveparser/   -> Data\\master_schema.xml
      RPFM        https://github.com/Frodo45127/rpfm             -> its schema files

    Then either drop it beside this script, set TW_MASTER_SCHEMA, or pass
      --schema <path>
  MSG
end

if in_pack
  # Same PFH0 reader as packtool.rb; duplicated deliberately so each tool is a
  # single file you can copy somewhere else and still run.
  found = nil
  # Forward slashes: Dir.glob reads a backslash as an escape, so a Windows path
  # matches nothing and you get "no pack entry" for a file that is right there.
  Dir.glob("#{data_dir.tr("\\", "/").chomp("/")}/*.pack").sort.each do |p|
    File.open(p, "rb") do |f|
      next unless f.read(4) == "PFH0".b
      _t, _dc, deps_len, nfiles, index_len = f.read(20).unpack("V5")
      f.seek(24 + deps_len)
      idx = f.read(index_len).to_s
      off = 24 + deps_len + index_len
      pos = 0
      nfiles.times do
        break if pos + 4 > idx.bytesize
        size = idx[pos, 4].unpack1("V"); pos += 4
        z = idx.index("\0", pos) or break
        name = idx[pos...z]; pos = z + 1
        found = [p, off, size] if name.casecmp?(in_pack)
        off += size
      end
    end
  end
  abort "no pack entry named #{in_pack.inspect} under #{data_dir}" unless found
  require "tmpdir"
  file = File.join(Dir.tmpdir, "dbread_" + in_pack.gsub(/[^A-Za-z0-9._-]+/, "_"))
  File.open(found[0], "rb") { |f| f.seek(found[1]); File.binwrite(file, f.read(found[2])) }
  warn "read #{in_pack} from #{File.basename(found[0])} (#{found[2]} bytes)"
  table = ARGV[0] || File.basename(in_pack)
else
  file  = ARGV[0]
  table = ARGV[1]
end

abort "usage: ruby dbread.rb <file> <table_name> [--cols a,b,c] [--csv out] [--limit N]" unless file && table && File.file?(file)
table = "#{table}_tables" unless table.end_with?("_tables")

d = File.binread(file)
pos = 0
guid = nil
if d[pos, 4] == "\xfd\xfe\xfc\xff".b
  pos += 4
  n = d[pos, 4].unpack1("l<"); pos += 4
  guid = d[pos, n * 2].force_encoding("UTF-16LE").encode("UTF-8"); pos += n * 2
end
version = 0
if d[pos, 4] == "\xfc\xfd\xfe\xff".b
  pos += 4
  version = d[pos, 4].unpack1("l<"); pos += 4
end
flag = d[pos].ord; pos += 1
rows = d[pos, 4].unpack1("l<"); pos += 4
header_end = pos
warn "#{File.basename(file)}: version #{version}, #{rows} rows#{guid ? ", guid #{guid}" : ''} (flag #{flag})"

doc = Nokogiri::XML(File.read(schema_path))
defs = doc.xpath("//table[@table_name='#{table}' and @table_version='#{version}']")
abort "no schema for #{table} version #{version}" if defs.empty?

def decode(d, pos, fields, rows)
  out = []
  rows.times do
    rec = {}
    fields.each do |f|
      case f[:type]
      when "string", "string_ascii", "optstring", "optstring_ascii"
        if f[:type].start_with?("opt")
          present = d[pos].ord; pos += 1
          if present.zero?
            rec[f[:name]] = ""
            next
          end
        end
        n = d[pos, 2].unpack1("v"); pos += 2
        if f[:type].include?("ascii")
          rec[f[:name]] = d[pos, n]; pos += n
        else
          rec[f[:name]] = d[pos, n * 2].force_encoding("UTF-16LE").encode("UTF-8"); pos += n * 2
        end
      when "int"     then rec[f[:name]] = d[pos, 4].unpack1("l<"); pos += 4
      when "float"   then rec[f[:name]] = d[pos, 4].unpack1("e");  pos += 4
      when "boolean" then rec[f[:name]] = (d[pos].ord != 0);        pos += 1
      else raise "unknown field type #{f[:type]}"
      end
    end
    out << rec
  end
  [out, pos]
end

winner = nil
defs.each_with_index do |t, i|
  fields = t.xpath("./field").map { |f| { name: f["name"], type: f["type"] } }
  begin
    recs, endpos = decode(d, header_end, fields, rows)
    if endpos == d.bytesize
      warn "  candidate #{i + 1} (#{fields.size} fields): EXACT - consumed all #{d.bytesize} bytes"
      winner = recs
      break
    else
      warn "  candidate #{i + 1} (#{fields.size} fields): consumed #{endpos} of #{d.bytesize}"
    end
  rescue => e
    warn "  candidate #{i + 1} (#{fields.size} fields): #{e.class} - #{e.message[0, 60]}"
  end
end
abort "no candidate consumed the file exactly - refusing to report guesses" unless winner

cols = want || winner.first.keys
if csv
  File.write(csv, ([cols.join(",")] + winner.map { |r| cols.map { |c| v = r[c].to_s; v.include?(",") ? "\"#{v}\"" : v }.join(",") }).join("\n"), mode: "wb")
  warn "wrote #{csv} (#{winner.size} rows)"
else
  puts cols.join(" | ")
  winner.first(limit).each { |r| puts cols.map { |c| r[c].to_s }.join(" | ") }
  puts "... #{winner.size - limit} more" if winner.size > limit
end
