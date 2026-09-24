# nse_locate.rb - find the Napoleon: Total War installation.
#
# WHY THIS EXISTS
#   The tools default to paths relative to this folder, which is correct when
#   the project lives inside the game directory (the normal case, and what
#   build.ps1 -Deploy assumes). But people put things where they like, Steam
#   libraries land on whatever drive had room, and the GOG and retail releases
#   are somewhere else entirely. A tool that only knows one layout fails on
#   someone else's machine with a path they have to reverse-engineer.
#
# RESOLUTION ORDER, most explicit first
#   1. an explicit --exe / --data / --game argument
#   2. $NSE_GAME
#   3. two levels up from tools/  (project sits inside the game folder)
#   4. Steam: read the library list, find app 34030, take its installdir
#   5. a few common install paths
#
# Napoleon: Total War is Steam app 34030, installdir "Napoleon Total War"
# (verified from appmanifest_34030.acf: name "Total War: NAPOLEON - Definitive
# Edition").
#
# Nothing here raises. A tool that cannot find the game should say so in its own
# words, with its own flag named - see `explain`.

module NseLocate
  APPID      = "34030"
  INSTALLDIR = "Napoleon Total War"

  module_function

  # Where Steam itself is installed. The registry is authoritative; the common
  # paths are a fallback for when reg.exe is unavailable or the key is missing.
  def steam_roots
    roots = []
    begin
      # HKCU is per-user and set by the installer; HKLM covers a machine-wide
      # install. 2>NUL because a missing key is normal, not an error.
      %w[HKCU\\Software\\Valve\\Steam HKLM\\SOFTWARE\\WOW6432Node\\Valve\\Steam].each do |key|
        out = `reg query "#{key}" /v SteamPath 2>NUL`
        if (m = out.match(/SteamPath\s+REG_SZ\s+(.+)/))
          roots << m[1].strip.tr("\\", "/")
        end
        out = `reg query "#{key}" /v InstallPath 2>NUL`
        if (m = out.match(/InstallPath\s+REG_SZ\s+(.+)/))
          roots << m[1].strip.tr("\\", "/")
        end
      end
    rescue StandardError
      # no reg.exe, not Windows, locked down - fall through to the guesses
    end
    roots += ["C:/Program Files (x86)/Steam", "C:/Program Files/Steam"]
    roots.uniq.select { |r| exists?(r) }
  end

  # Sweeping drive letters is the LAST resort, never part of the normal path.
  # Dir.exist? on a disconnected mapped network drive blocks until the SMB
  # timeout - seconds per letter - so a machine with a dead Z: would make every
  # tool appear to hang. The registry answers on any real Steam install, so this
  # only runs when that has already failed.
  def steam_roots_by_sweep
    out = []
    ("C".."Z").each do |d|
      next unless exists?("#{d}:/")
      ["#{d}:/Steam", "#{d}:/steam", "#{d}:/SteamLibrary", "#{d}:/Games/Steam"].each do |p|
        out << p if exists?(p)
      end
    end
    out
  end

  # Dir.exist? with a guard, so one unreachable path cannot take the tool down.
  def exists?(path)
    Dir.exist?(path)
  rescue StandardError
    false
  end

  # Every library folder Steam knows about. libraryfolders.vdf moved between
  # steamapps/ and config/ across Steam versions, and its schema changed - older
  # files map an index straight to a path string, newer ones nest it under a
  # "path" key. Scraping every quoted absolute path handles both without
  # pretending to be a real VDF parser.
  def steam_libraries(roots = steam_roots)
    libs = []
    roots.each do |root|
      libs << root
      %W[#{root}/steamapps/libraryfolders.vdf #{root}/config/libraryfolders.vdf].each do |vdf|
        next unless File.file?(vdf)
        begin
          File.read(vdf).scan(/"((?:[A-Za-z]:|\/)[^"]+)"/) { |(p)| libs << p.gsub("\\\\", "/").tr("\\", "/") }
        rescue StandardError
          next
        end
      end
    end
    libs.uniq.select { |l| exists?(l) }
  end

  # Prefer the appmanifest, because it names the real installdir - which a
  # non-English or relocated install can change. Fall back to the default name.
  def from_steam(roots = steam_roots)
    steam_libraries(roots).each do |lib|
      manifest = File.join(lib, "steamapps", "appmanifest_#{APPID}.acf")
      dir = INSTALLDIR
      if File.file?(manifest)
        begin
          if (m = File.read(manifest).match(/"installdir"\s+"([^"]+)"/))
            dir = m[1]
          end
        rescue StandardError
          # keep the default
        end
      end
      cand = File.join(lib, "steamapps", "common", dir)
      return cand if File.file?(File.join(cand, "Napoleon.exe"))
    end
    nil
  end

  # GOG and retail installs. Also a last resort, for the same reason as
  # steam_roots_by_sweep.
  def common_paths
    out = ["C:/Program Files (x86)/Steam/steamapps/common/#{INSTALLDIR}",
           "C:/GOG Games/#{INSTALLDIR}",
           "C:/Games/#{INSTALLDIR}"]
    ("D".."Z").each do |d|
      next unless exists?("#{d}:/")
      out << "#{d}:/GOG Games/#{INSTALLDIR}" << "#{d}:/Games/#{INSTALLDIR}"
    end
    out
  end

  # The game root, or nil. `explicit` short-circuits everything.
  def game_root(explicit = nil)
    if explicit
      root = File.directory?(explicit) ? explicit : File.dirname(explicit)
      return root if File.file?(File.join(root, "Napoleon.exe"))
      return root # trust the user; the caller reports the missing file
    end

    if (e = ENV["NSE_GAME"]) && File.file?(File.join(e, "Napoleon.exe"))
      return e
    end

    # The normal case: this project unpacked inside the game folder.
    rel = File.expand_path("../..", __dir__)
    return rel if File.file?(File.join(rel, "Napoleon.exe"))

    # Registry-guided Steam lookup: fast, and right on virtually every machine.
    if (s = from_steam)
      return s
    end

    # Everything below sweeps drive letters and is therefore slow on a machine
    # with dead network mappings. Only reached when the fast paths found nothing.
    if (s = from_steam(steam_roots_by_sweep))
      return s
    end

    common_paths.each { |c| return c if File.file?(File.join(c, "Napoleon.exe")) }
    nil
  end

  def exe(explicit = nil)
    return explicit if explicit && File.file?(explicit)
    r = game_root(explicit)
    r && File.join(r, "Napoleon.exe")
  end

  def data_dir(explicit = nil)
    return explicit if explicit && Dir.exist?(explicit)
    r = game_root(explicit)
    r && File.join(r, "data")
  end

  # One message, used by every tool, so the advice is identical wherever you hit
  # it. `flag` is whatever that tool calls its override.
  def explain(what, flag)
    <<~MSG
      Could not find #{what}.

      Looked, in order:
        1. the #{flag} argument
        2. $NSE_GAME
        3. #{File.expand_path('../..', __dir__)}
           (this project unpacked inside the game folder - the usual layout)
        4. Steam app #{APPID}, via libraryfolders.vdf
        5. common GOG / retail install paths

      Fix it with whichever suits you:
        #{flag} "C:\\path\\to\\Napoleon Total War"
        set NSE_GAME=C:\\path\\to\\Napoleon Total War
        or move this project inside the game folder
    MSG
  end
end
