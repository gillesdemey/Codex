CODEX_HELP = <<-EOS
Example usage:
  codex [info | home | options ] [FORMULA...]
  codex install FORMULA...
  codex uninstall FORMULA...
  codex search [foo]
  codex list [FORMULA...]
  codex update
  codex upgrade [FORMULA...]

Troubleshooting:
  codex doctor
  codex install -vd FORMULA
  codex [--env | --config]

Codexing:
  codex create [URL [--no-fetch]]
  codex edit [FORMULA...]
  open https://github.com/mxcl/homecodex/wiki/Formula-Cookbook

Further help:
  man codex
  codex home
EOS

# NOTE Keep the lenth of vanilla --help less than 25 lines!
# This is because the default Terminal height is 25 lines. Scrolling sucks
# and concision is important. If more help is needed we should start
# specialising help like the gem command does.
# NOTE Keep lines less than 80 characters! Wrapping is just not cricket.
# NOTE The reason the string is at the top is so 25 lines is easy to measure!

module Codex extend self
  def help
    puts CODEX_HELP
  end
  def help_s
    CODEX_HELP
  end
end
