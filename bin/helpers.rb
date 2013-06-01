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

  def update
    puts "Updating codex..."
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

end