#!/System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/bin/ruby -W0
# encoding: UTF-8

###############################################
# USAGE:                                      #
# codex [backup | restore ] [FORMULA...]      #
###############################################


#############
# Constants #
#############

CODEX_VERSION = '0.1'

# Words used to trigger actions
BACKUP_W = 'backup'
RESTORE_W = 'restore'
REVERT_W = 'uninstall'

# Common paths

PREFERENCES = '~/Library/Preferences/'
APP_SUPPORT = '~/Library/Application Support/'
MANUSCRIPT_PATH = 'Library/Manuscript/'

#################
# Configuration #
#################

$formulas = []
$supported_apps = []

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

# Functions

# TODO: fetch list of apps from the git repo

# Load all installed formulas
def getFormulas

  $formulas.each do |f|
    loadFormula(f)
  end

  puts $supported_apps
end

# Load a certain formula into the supported apps global
def loadFormula(f)
  require 'json'
  $supported_apps << JSON.load( IO.read(f) )
end

# Discover all installed formulas
def discoverFormulas
  $formulas = Dir.glob("#{MANUSCRIPT_PATH}*.js")
  puts $formulas
end

####################
# Helper Functions #
####################

def isSameFile(left, right)
  require 'digest/md5'
  left_hash = Digest::MD5.file(left)
  right_hash = Digest::MD5.file(right)

  left_hash === right_hash
end

begin

  discoverFormulas
  getFormulas

  case ARGV[0]
  when BACKUP_W
    #backup($formulas)
  when RESTORE_W
    #restore($formulas)
  else
    puts "Please choose '#{BACKUP_W}' or '#{RESTORE_W}'"
  end

  # Find requested formula in formulas list
  if $formulas.any? {|k, v| k.include? ARGV[1]}
    form = $formulas.select {|k, v| $formulas.include? ARGV[1]}
    puts form
  else
    puts "Formula #{ARGV[1]} not found."
  end

end