module Formulas extend self

  require_relative 'lib/os.rb'

  # Load all installed formulas
  def loadAllFormulas

    $formulas.each do |f|
      loadFormula(f)
    end

    #puts "[getFormulas - $loaded_apps]: #{$loaded_apps}"
  end

  # Load a certain formula into the supported apps global
  def loadFormula(f)
    $loaded_apps << JSON.load( IO.read(f) )
  end

  # Discover all installed formulas
  # TODO: Fetch formulas from git repo
  def discoverFormulas
    begin
      $formulas = Dir.glob("#{MANUSCRIPT_PATH}/#{OS.name}/*.js")
      #puts "[discoverFormulas - $formulas]: #{$formulas}"
    rescue
      puts "\2757 Couldn't discover formulas. #{$!}"
    end
  end

  # TODO: write update formulas function
  def updateFormulas
    puts "Fetching formulas..."
  end

end