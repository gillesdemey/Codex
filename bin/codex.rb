#!/System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/bin/ruby -W0
# encoding: utf-8

###############################################
# USAGE:                                      #
# codex [backup | restore ] [FORMULA...]      #
###############################################

require 'rubygems'
require 'bundler/setup'

require 'json'
require 'fileutils'

# TODO: refactor require_relative for Ruby 1.8.7
require_relative 'helpers.rb'
require_relative 'commands.rb'
require_relative 'formulas.rb'

#############
# Constants #
#############

CODEX_VERSION = '0.1'

# Words used to trigger actions

COMMANDS = {
  :backup => 'backup',
  :restore => 'restore',
  :unlink => 'unlink',
  :update => 'update'
}

#################
# Configuration #
#################

$formulas = []
$loaded_apps = []
$config = JSON.load( IO.read('config/config.js') )

# Common paths
PREFERENCES = '~/Library/Preferences/'
APP_SUPPORT = '~/Library/Application Support/'
MANUSCRIPT_PATH = 'Library/Manuscripts/'

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

  Formulas.discoverFormulas

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
      Formulas.loadFormula(formula)
    else
      puts "Formula #{ARGV[1]} not found."
      exit 0
    end

  else
    # no formula specified, load all of them
    Formulas.loadAllFormulas
  end

  case ARGV.first
    when COMMANDS[:backup]
      Codex.executeCommand('backup')
    when COMMANDS[:restore]
      Codex.executeCommand('restore')
    when COMMANDS[:unlink]
      Codex.executeCommand('unlink')
    when COMMANDS[:update]
      Formulas.updateFormulas
    else
      #puts "Please choose #{COMMANDS.values}"
      require_relative 'cmd/help'
      Codex.help
      exit 0
  end

end