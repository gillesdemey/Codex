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
    return folder.gsub("~", Dir.home)
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
    return "#{CODEX_FOLDER}/#{File.basename path}"
  end

  def normalizeString(string)
    return string.strip.downcase.gsub(' ', '')
  end

  def parentDirectory(path)
    return File.expand_path("..", path)
  end

  def alreadyBackedUp(folder)
    File.exists? Codex.getCodexPath(folder)
  end

  # check if application is installed
  # at least one file in paths has to match
  def isInstalled(app)
    installed = false
    app['paths'].each do |path|
      if File.exists? Codex.tildeToHomeFolder(path)
        installed = true
      end
    end
    return installed
  end

end