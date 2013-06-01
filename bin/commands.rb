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
                  FileUtils.symlink(codex_path, Codex.parentDirectory(path))
                  # done!
                  puts "\u2714 #{app['name']} is secured in the cloud!"
                rescue
                  # TODO: write rescue code to ensure no data was lost!
                  puts "\2757 something went wrong! #{$!}"
                  errors << $!
                  $loaded_apps.delete(app)
                end

              else
                puts "\u2714 #{app['name']} is already safe in the cloud."
              end

            end

          end

        else
          # application seems not installed
          if $loaded_apps.size === 1
            puts "You don't seem to have #{app['name']} installed."
            exit 0
          end
          $loaded_apps.delete(app)
        end

      end

    end

    if errors.empty?
      puts "\u2714 #{$loaded_apps.size} application(s) are secured in the cloud!"
    else
      puts "\u2757 #{$loaded_apps.size} application(s) are secured in the cloud, but with #{errors.length} error(s)."
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

    # keep an array of errors
    errors = []
    restored_apps = []

    if $loaded_apps.instance_of? Array

      $loaded_apps.each do |app|

        # check if application is installed
        if Codex.isInstalled app

          #puts "#{app['name']} seems to be installed. Restoring..."

          # check if local files exist, overwrite with cloud-synced files?
          app['paths'].each_with_index do |path, index|

            path = Codex.tildeToHomeFolder path
            codex_path = Codex.getCodexPath(path)
            type = Codex.getType(path)

            # Check if file is not already symlinked
            if not Codex.alreadyRestored path

              begin
                # remove local file/folder
                if type === 'file'
                  FileUtils.rmdir path
                elsif type === 'folder'
                  FileUtils.rm_r path
                end
                # link .codex path to system path
                FileUtils.symlink(codex_path, Codex.parentDirectory(path))
                puts "\u2714 #{app['name']} is successfuly restored!"
              rescue
                # TODO: write rescue code to ensure no data was lost!
                puts "\u2757 something went wrong! #{$!}"
                errors << $!
              end

            else
              if index === app['paths'].size - 1
                puts "\u2714 #{app['name']} is already restored and linked."
              end
            end

          end

          restored_apps << app

        else
          if $loaded_apps.size === 1
            puts "You don't seem to have #{app['name']} installed."
            exit 0
          end
        end

      end

      if errors.empty?
        puts "\u2714 #{restored_apps.size} application(s) have been restored!"
      else
        puts "\u2757 #{restored_apps.size} application(s) have been restored, but with #{errors.length} error(s)."
      end

    end

  end

  def unlink

  end

end