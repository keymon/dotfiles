# Add the config command to version the $HOME
alias config='git --git-dir=$HOME/.config.git/ --work-tree=$HOME'
# Add bash completion for config
[ type _git > /dev/null 2>&1 ] && complete -o default -o nospace -F _git config

