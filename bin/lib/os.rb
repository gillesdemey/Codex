module OS extend self

  def windows?
    (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM) != nil
  end

  def mac?
   (/darwin/ =~ RUBY_PLATFORM) != nil
  end

  def unix?
    !windows?
  end

  def linux?
    unix? and not mac?
  end

  def name
    if windows?
      'windows'
    elsif mac?
      'osx'
    elsif linux?
      'linux'
    else
      nil
    end
  end

end