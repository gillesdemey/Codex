####################
# Helper Functions #
####################

module Codex extend self

  def isSameFile(left, right)
    require 'digest/md5'
    left_hash = Digest::MD5.file(left)
    right_hash = Digest::MD5.file(right)

    left_hash === right_hash
  end

  def tildeToHomeFolder(folder)
    folder.gsub("~", Dir.home)
  end

  def getType(path)
    # directory
    if File.directory? path
      type = 'folder'
    # file
    elsif File.exists? path
      type = 'file'
    else
      type = nil
    end
  end

  def getCodexPath(path)
    "#{CODEX_FOLDER}/#{File.basename path}"
  end

  def normalizeString(string)
    string.strip.downcase.gsub(' ', '')
  end

  def parentDirectory(path)
    File.expand_path("..", path)
  end

  def alreadyBackedUp(app)
    # asume it's not
    backedup = false
    app['paths'].each do |path|
      # one or more paths found
      if File.exists? Codex.getCodexPath(path)
        backedup = true
      end
    end
    return backedup
  end

  def alreadyRestored(app)
    # asume it's not
    restored = false
    app['paths'].each do |path|
      path = Codex.tildeToHomeFolder path
      # one or more paths found
      if File.symlink? Codex.folderToFile(path)
        restored = true
      end
    end
    return restored
  end

  def folderToFile(path)
    path.chomp('/')
  end

  # check if application is installed, at least one file in paths has to exist
  # also check if maybe it has been symlinked
  def isInstalled(app)
    # assume it's false by default
    installed = false
    app['paths'].each do |path|
      path = Codex.tildeToHomeFolder path
      if File.exists? path or File.symlink? path
        installed = true
      end
    end
    return installed
  end

end