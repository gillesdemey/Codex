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

    # keep an array of errors
    errors = []

    if $loaded_apps.instance_of? Array

      $loaded_apps.each do |app|

        if Codex.isInstalled app

          app['paths'].each do |path|

            path = Codex.tildeToHomeFolder path
            codex_path = Codex.getCodexPath(path)

            #puts "#{path} is a #{type.nil? ? 'not found' : type}"

            # the file/directory was found
            if not Codex.getType(path).nil?

              #puts "Backing up #{app['name']}..."

              # Check if file does not already exist
              if not Codex.alreadyBackedUp codex_path

                begin
                  # move file to codex folder
                  FileUtils.move(path, codex_path)
                  # link back to original location
                  FileUtils.symlink(codex_path, Codex.parentDirectory)
                  # done!
                  puts "\u2714 #{app['name']} is secured in the cloud!"
                rescue
                  # TODO: write rescue code to ensure no data was lost!
                  puts "\2757 something terrible went wrong! #{$!}"
                end

              else
                puts "\u2714 #{app['name']} is already safe in the cloud."
              end

            end

          end

        else
          if $loaded_apps.size === 1
            puts "You don't have #{app['name']} installed."
            exit 0
          end
        end

      end

    end

    if errors.empty?
      puts "\u2714 Your application settings are secured in the cloud!"
    else
      puts "\2757 Your application settings are secured in the cloud, but with #{errors.length} errors."
    end

  end

  # Restore the application config files
  #
  #  Algorithm:
  #
  #     if exists .codex/file
  #       if exists home/file
  #         are you sure ?
  #         if sure
  #           rm home/file
  #           link .codex/file home/file
  #       else
  #         link .codex/file home/file
  def restore

  end

end