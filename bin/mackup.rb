#!/System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/bin/ruby -W0
# encoding: UTF-8

std_trap = trap("INT") { exit! 130 } # no backtrace thanks

HOMEBREW_BREW_FILE = ENV['HOMEBREW_BREW_FILE']

# USAGE:
# mackup [backup | restore ] [FORMULA...]

# Requires

# Constants

MACKUP_VERSION = '0.1'

# Words used to trigger actions
BACKUP_W = 'backup'
RESTORE_W = 'restore'

# Common paths

PREFERENCES = '~/Library/Preferences/'
APP_SUPPORT = '~/Library/Application Support/'
MANUSCRIPT_PATH = 'Library/Manuscript/'

# Configuration

$formulas = []
$supported_apps = []

# TODO: fetch list of apps from the git repo

# CLI options
case ARGV.first
when '-h', '--help', '--usage', '-?', 'help', nil
  require 'cmd/help'
  puts Mackup.help_s
  exit ARGV.first ? 0 : 1
when '--version'
  puts MACKUP_VERSION
  exit 0
when '-v'
  puts "Mackup v#{MACKUP_VERSION}"
    # Shift the -v to the end of the parameter list
    ARGV << ARGV.shift
    # If no other arguments, just quit here.
    exit 0 if ARGV.length == 1
  end

  def require? path
    require path.to_s.chomp
  rescue LoadError => e
  # HACK :( because we should raise on syntax errors but
  # not if the file doesn't exist. TODO make robust!
  raise unless e.to_s.include? path
end

# Functions

def init

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

# Helper functions
def isSameFile(left, right)
  require 'digest/md5'
  left_hash = Digest::MD5.file(left)
  right_hash = Digest::MD5.file(right)

  left_hash === right_hash
end

init