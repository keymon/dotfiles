# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific aliases and functions

# Load my own Bash extensions
[ -n "$PS1" ] && source ~/.my_bash/load.sh
