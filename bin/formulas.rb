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

    formula = JSON.load( IO.read(f) )

    # run a quick sanity check
    if isSane formula
      $loaded_apps << formula
    else
      # config file not sane
      puts "Manuscript file #{f} is invalid."
    end
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

  def isSane(formula)
    sane = true
    # not an array
    if not formula['paths'].instance_of? Array
      sane = false
    end
    # no name node found
    if formula['name'].nil?
      sane = false
    # name is empty
    elsif formula['name'].empty?
      sane = false
    end
    return sane
  end

end