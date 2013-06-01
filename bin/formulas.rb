module Codex extend self

  # Load all installed formulas
  def loadAllFormulas

    $formulas.each do |f|
      loadFormula(f)
    end

    #puts "[getFormulas - $supported_apps]: #{$supported_apps}"
  end

  # Load a certain formula into the supported apps global
  def loadFormula(f)
    $supported_apps << JSON.load( IO.read(f) )
  end

  # Discover all installed formulas
  # TODO: Fetch formulas from git repo
  def discoverFormulas
    begin
      $formulas = Dir.glob("#{MANUSCRIPT_PATH}*.js")
      #puts "[discoverFormulas - $formulas]: #{$formulas}"
    rescue
      puts "\2757 Couldn't discover formulas. #{$!}"
    end
  end

  # TODO: write update formulas function
  def updateFormulas
    puts "Fetching formulas..."
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