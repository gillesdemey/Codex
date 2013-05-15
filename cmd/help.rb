MACKUP_HELP = <<-EOS
Example usage:
  mackup [info | home | options ] [FORMULA...]
  mackup install FORMULA...
  mackup uninstall FORMULA...
  mackup search [foo]
  mackup list [FORMULA...]
  mackup update
  mackup upgrade [FORMULA...]

Troubleshooting:
  mackup doctor
  mackup install -vd FORMULA
  mackup [--env | --config]

mackuping:
  mackup create [URL [--no-fetch]]
  mackup edit [FORMULA...]
  open https://github.com/mxcl/homemackup/wiki/Formula-Cookbook

Further help:
  man mackup
  mackup home
EOS

# NOTE Keep the lenth of vanilla --help less than 25 lines!
# This is because the default Terminal height is 25 lines. Scrolling sucks
# and concision is important. If more help is needed we should start
# specialising help like the gem command does.
# NOTE Keep lines less than 80 characters! Wrapping is just not cricket.
# NOTE The reason the string is at the top is so 25 lines is easy to measure!

module Mackup extend self
  def help
    puts MACKUP_HELP
  end
  def help_s
    MACKUP_HELP
  end
end
