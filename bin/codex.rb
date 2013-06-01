#!/System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/bin/ruby -W0
# encoding: UTF-8

###############################################
# USAGE:                                      #
# codex [backup | restore ] [FORMULA...]      #
###############################################

require 'json'
require 'fileutils'
require_relative 'helpers.rb'
require_relative 'commands.rb'

#############
# Constants #
#############

CODEX_VERSION = '0.1'

# Words used to trigger actions

COMMANDS = {
  backup: 'backup',
  restore: 'restore',
  revert: 'uninstall',
  update: 'update'
}

#################
# Configuration #
#################

$formulas = []
$supported_apps = []
$config = JSON.load( IO.read('config/config.js') )

# Common paths
PREFERENCES = '~/Library/Preferences/'
APP_SUPPORT = '~/Library/Application Support/'
MANUSCRIPT_PATH = 'Library/Manuscript/'

DROPBOX_FOLDER = Codex.tildeToHomeFolder($config['dropbox_folder'])
CODEX_FOLDER  = DROPBOX_FOLDER + $config['codex_folder']

########################
# Command Line Options #
########################

case ARGV.first
  when '-h', '--help', '--usage', '-?', 'help', nil
    require_relative 'cmd/help'
    Codex.help
    exit ARGV.first ? 0 : 1
  when '--version'
    puts CODEX_VERSION
    exit 0
  when '-v'
    puts "Codex v#{CODEX_VERSION}"
    # Shift the -v to the end of the parameter list
    ARGV << ARGV.shift
    # If no other arguments, just quit here.
    exit 0 if ARGV.length == 1
end

#############
# Functions #
#############

# Load all installed formulas
def getFormulas

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
  Codex.update
  $formulas = Dir.glob("#{MANUSCRIPT_PATH}*.js")
  #puts "[discoverFormulas - $formulas]: #{$formulas}"
end

def alreadyBackedUp(folder)
  File.exists? Codex.getCodexPath(folder)
end

# Make sure all folders are in place
def setup
  if not File.directory? "#{DROPBOX_FOLDER}"
    puts "No dropbox folder found. Please update your config file."
    exit 0
  else
    if not File.directory? "#{CODEX_FOLDER}"
      #puts "No codex folder found, creating..."
      Dir.mkdir "#{CODEX_FOLDER}"
    end
  end
end

#########
# Begin #
#########

begin

  setup

  discoverFormulas

  # Formula specified, find requested formula in formulas list
  if ARGV[1]

    formula = nil

    $formulas.each do |f|
      if File.basename(f, '.*') === Codex.normalizeString(ARGV[1])
        #puts "Formula #{f_name} found!"
        formula = f
      end
    end

    if not formula.nil?
      #puts formula
      loadFormula(formula)
    else
      puts "Formula #{ARGV[1]} not found."
    end

  else
    # no formula specified, load all of them
    getFormulas
  end

  case ARGV.first
    when COMMANDS[:backup]
      Codex.backup
    when COMMANDS[:restore]
      restore
    when COMMANDS[:revert]
      uninstall
    when COMMANDS[:update]
      update
    else
      puts "Please choose #{COMMANDS.values}"
  end

end