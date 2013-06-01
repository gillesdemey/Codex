Codex
=====

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
ruby bin/codex.rb backup
```

This function will move all the installed applications that are compatible with Codex to your dropbox folder

Single application functions are also available.

```
ruby bin/codex.rb backup zsh
```

restore
----

```
ruby bin/codex.rb restore
```

This function will restore all your application settings from your dropbox folder to your local system

```
ruby bin/codex.rb restore sublimetext2
```

Single application functions are also available.