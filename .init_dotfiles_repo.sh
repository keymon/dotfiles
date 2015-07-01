#!/bin/bash

# Env variables for automation
DOTFILES_GIT_REPO=${DOTFILES_GIT_REPO:-git@github.com:keymon/dotfiles.git}
FORCE=${FORCE:-0}

# Open the real terminal
exec 3<>/dev/tty

if [ "$FORCE" != "1" ]; then
	cat <<EOF >&3

WARNING: This will setup $DOTFILES_GIT_REPO to manage your home dot files.

It will override your existing files in your home directory!

EOF

	# Read from stdin
	read -u 3 -p "Do you want to continue? [y/N] " continue
	[ "$continue" == "y" -o "$continue" == "Y" ] || exit 1
fi

set -e
cd $HOME

if [ -d .config.git ]; then
	git_repo_dir_backup=.config.git.$(date +%Y%m%d-%H%M)
	echo "Directory .config.git already exists, cloning it to $git_repo_dir_backup"
	mv .config.git $git_repo_dir_backup
fi

echo "Cloning remote repo $DOTFILES_GIT_REPO in ~/.config.git"
git --git-dir=.config.git init
git --git-dir=.config.git config --bool core.bare false
git --git-dir=.config.git remote add -f origin $DOTFILES_GIT_REPO
git --git-dir=.config.git fetch

echo "Checking out code. This will override your home files"
git --git-dir=.config.git reset --hard origin/master
git --git-dir=.config.git branch --set-upstream master origin/master

echo "Getting submodules"
# get submodules, i.e. bash-it
git --git-dir=.config.git submodule init
git --git-dir=.config.git submodule update
git --git-dir=.config.git pull --recurse-submodules

# Setup configuration
git --git-dir=.config.git config --local core.excludesfile ~/.configignore


# Reload bash
cat <<EOF
Job done! Now reload your shell by running:

	exec bash -l

EOF

