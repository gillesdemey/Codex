# encoding: utf-8

#####################
# Command Functions #
#####################

module Codex extend self

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
  #
  def backup

    errors = []

    if $supported_apps.instance_of? Array

      $supported_apps.each do |app|

        if Codex.isInstalled app

          app['paths'].each do |path|

            path = Codex.tildeToHomeFolder path
            codex_path = Codex.getCodexPath(path)

            type = Codex.getType path

            #puts "#{path} is a #{type.nil? ? 'not found' : type}"

            if not type.nil?

              puts "Backing up #{app['name']}..."

              # Check if file does not already exist
              if alreadyBackedUp codex_path
                #puts "#{type} #{path} is already backed up. Continue?"
                puts "\u2714 #{app['name']} is already safe in the cloud."
              else
                begin
                  # move file to codex folder
                  FileUtils.move(path, codex_path)
                  # link back to original location
                  FileUtils.symlink(codex_path, File.expand_path("..", path))
                  # done!
                  puts "\u2714 #{app['name']} is secured in the cloud!"
                rescue
                  puts "\2757 something terrible went wrong! #{$!}"
                end
              end

            end

          end

          if errors.empty?
            puts "Your application settings are secured in the cloud!"
          else
            puts "Your application settings are secured in the cloud, but with #{errors.length} errors."
          end

        else
          puts "You don't have #{app['name']} installed."
        end

      end

    end

  end

  def restore

  end

end