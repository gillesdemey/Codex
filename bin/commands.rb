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
  def backup

    if $supported_apps.instance_of? Array

      $supported_apps.each do |app|
        puts "Backing up #{app['name']}..."

        app['paths'].each do |path|

          path = Codex.tildeToHomeFolder path
          codex_path = Codex.getCodexPath(path)

          file = File.basename path

          type = Codex.getType path

          #puts "#{path} is a #{type.nil? ? 'not found' : type}"

          if not type.nil?

            # Check if file does not already exist
            if alreadyBackedUp codex_path
              #puts "#{type} #{path} is already backed up. Continue?"
              puts "#{app['name']} is already safe in the cloud."
            else
              # move file to codex folder
              FileUtils.move(path, codex_path)
              # link back to original location
              FileUtils.symlink(codex_path, File.expand_path("..", path))
              # done!
              puts "#{app['name']} is secured in the cloud!"
            end

          end

        end

      end

    end

  end

end