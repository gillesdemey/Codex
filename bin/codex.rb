#!/System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/bin/ruby -W0
# encoding: UTF-8

###############################################
# USAGE:                                      #
# codex [backup | restore ] [FORMULA...]      #
###############################################

require 'json'
require 'fileutils'
require_relative 'helpers.rb'

#############
# Constants #
#############

CODEX_VERSION = '0.1'

# Words used to trigger actions
BACKUP_W = 'backup'
RESTORE_W = 'restore'
REVERT_W = 'uninstall'
UPDATE_W = 'update'

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

  puts "[getFormulas - $supported_apps]: #{$supported_apps}"
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
  puts "[discoverFormulas - $formulas]: #{$formulas}"
end

# Backup the application config files
#
#   Algorithm:
#     if exists home/file
#       if home/file is a real file
#         if exists .codex/file
#           are you sure ?
#           if sure
#             rm .codex/file
#             mv home/file .codex/file
#             link .codex/file home/file
#         else
#           mv home/file .codex/file
#           link .codex/file home/file
def backup

  if $supported_apps.instance_of? Array

    $supported_apps.each do |app|
      puts "Backing up #{app['name']}..."

      app['paths'].each do |path|

        path = Codex.tildeToHomeFolder path
        codex_path = Codex.getCodexPath(path)

        file = File.basename path

        type = Codex.getType path

        puts "#{path} is a #{type.nil? ? 'not found' : type}"

        if not type.nil?

          # Check if file does not already exist
          if alreadyBackedUp codex_path
            puts "#{type} #{path} is already backed up. Continue?"
          else
            # move file to codex folder
            FileUtils.move(path, codex_path)
            # link back to original location
            FileUtils.symlink(codex_path, File.expand_path("..", path))
          end

        end

      end

    end

  end

end

def alreadyBackedUp(folder)
  File.exists? Codex.getCodexPath(folder)
end

# Make sure all folders are in place
def setup
  if not File.directory? "#{DROPBOX_FOLDER}"
    puts "No dropbox folder found! Please update your config file!"
    exit 0
  else
    if not File.directory? "#{CODEX_FOLDER}"
      puts "No codex folder found, creating..."
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

  # Find requested formula in formulas list
  if ARGV[1]
    if $formulas.any? {|k, v| k.include? ARGV[1]}
      form = $formulas.select {|k, v| $formulas.include? ARGV[1]}
      $supported_apps = form
    else
      puts "Formula #{ARGV[1]} not found."
    end
  else
    getFormulas
  end

  case ARGV.first
    when BACKUP_W
      backup
    when RESTORE_W
      restore
    when REVERT_W
      uninstall
    when UPDATE_W
      update
    else
      puts "Please choose '#{BACKUP_W}' or '#{RESTORE_W}'"
  end

end