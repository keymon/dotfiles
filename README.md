Versioned $HOME directory
=========================

This directory is versioned using git, but using  --git-dir=.config.git to avoid conflicts. 

See http://robescriva.com/blog/2009/01/06/manage-your-home-with-git/ for more details

Installation
------------

In order to clone this there are 2 options, clone it to a repo and move it

	git clone --git-dir=.config.git clone git@github.com:keymon/dotfiles.git dotfiles
	cp dotfiles/* $HOME/; mv dotfiles/.??* $HOME 

or this:

	cd $HOME
	git --git-dir=.config.git init
	git --git-dir=.config.git config --bool core.bare false
	git --git-dir=.config.git remote add origin git@github.com:keymon/dotfiles.git
	git --git-dir=.config.git fetch
	git --git-dir=.config.git reset --hard origin/master
	git --git-dir=.config.git branch --set-upstream master origin/master
	# get submodules, i.e. bash-it
	git --git-dir=.config.git submodule init
	git --git-dir=.config.git submodule update
	# Reload bash
	exec bash -l

NOTE: it will override your `.bashrc`, `.bash_profile`, etc

Use it
------

As the blog recommends, add this alias to `.bash_rc` or load the `.my_bash`:

	# Add the config command to version the $HOME
	alias config='git --git-dir=$HOME/.config.git/ --work-tree=$HOME'
	# Add bash completion for config
	[ type _git > /dev/null 2>&1 ] && complete -o default -o nospace -F _git config


Bash-it
-------

I am using bash-it  as git submodule. In order to keep it sync:
	
	git submodule init
	git submodule update
 
Reference: 

* https://github.com/keymon/bash-it
* https://github.com/revans/bash-it

`~/.my_bash`
--------------

In the `~/.my_bash` I keep some extensions, aliases, etc.

Just drop files there with `*.sh` and add in `~/.bash_profile`, after loading `bash-it`:

	# Load my own Bash extensions
	source ./.my_bash/load_all.sh
