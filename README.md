Codex
=====

[![Code Climate](https://codeclimate.com/github/gillesdemey/Codex.png)](https://codeclimate.com/github/gillesdemey/Codex)

Backup your application settings and dotfiles with ease.
----

Codex is a modular backup tool to help you backup and restore your application settings and dotfiles.

Installation
====

Coming to homebrew soon...

Clone the repository, use the following command

```
ruby bin/codex.rb
```

to access Codex functions.

Configuration
=====

Edit config/config.js however you want.

Usage
======

backup
----

```
ruby bin/codex.rb backup [optional: application]
```

This function will **move all the installed applications settings** that Codex has a Manuscript for to your codex folder **and link the folders**.

restore
----

```
ruby bin/codex.rb restore [optional: application]
```

This function will restore all your application settings from your codex folder to your local system and **link them**.

Usually this command is run on the second computer, to restore application settings.

Not necessary to run on the same computer unless something went wrong while unlinking.


unlink
----

```
ruby bin/codex.rb unlink [optional: application]
```

This function will restore all your application settings from your dropbox folder to your local system, **your settings will still be in your codex folder**, but they will no longer be linked.
