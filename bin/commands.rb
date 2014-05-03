# encoding: utf-8

#####################
# Command Functions #
#####################

module Codex extend self

  def executeCommand(cmd)

    if not $loaded_apps.empty?

      $loaded_apps.each do |app|

        if Codex.isInstalled app

          case cmd
            when 'backup'
              backup(app)
            when 'restore'
              restore(app)
            when 'unlink'
              unlink(app)
          end

          #TODO: verbose output that everything was ok, or errors happend

        end

      end

    end

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
  #
  def backup(app)

    errors = []

    if not Codex.alreadyBackedUp app

      app['paths'].each do |path|

        path = Codex.tildeToHomeFolder(path)
        codex_path = Codex.getCodexPath(path)

        begin
          # move file to codex folder
          FileUtils.move(path, codex_path)
          # link back to original location
          FileUtils.symlink(codex_path, Codex.parentDirectory(path))
          # done!
          puts "\u2714 #{app['name']} is secured in the cloud!"
        rescue
          # TODO: write rescue code to ensure no data was lost!
          puts "\u2757 something went wrong! #{$!}"
          errors << $!
          $loaded_apps.delete(app)
        end

      end

    else
      puts "\u2714 #{app['name']} is already safe in the cloud."
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
  def restore(app)

    errors = []

    # check if application is installed
    if Codex.isInstalled app

      if not Codex.alreadyRestored app

        # check if local files exist, overwrite with cloud-synced files?
        app['paths'].each_with_index do |path, index|

          path = Codex.tildeToHomeFolder path
          codex_path = Codex.getCodexPath(path)
          type = Codex.getType(path)

          begin
            # remove local file/folder
            if type === 'file'
              FileUtils.rm path
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

        end

      else
        puts "\u2714 #{app['name']} is already restored and linked."
      end

    end

  end

  # This function will remove the symlink and COPY the codex file/folder to the local system
  def unlink(app)

    app['paths'].each do |path|

      path = Codex.tildeToHomeFolder path
      codex_path = Codex.getCodexPath(path)
      type = Codex.getType(path)

      begin

        # remove linked file on local system
        if type === 'folder'
          FileUtils.rm(path)
          # copy the codex file to the local system
          FileUtils.cp_r(codex_path, path)
        elsif type === 'file'
          FileUtils.rm(path)
          # copy the codex file to the local system
          FileUtils.copy(codex_path, path)
        end

      rescue
        # TODO: write rescue code to ensure no data was lost!
        puts "\u2757 something went wrong! #{$!}"
      end

    end

  end

end