# Add MacOSX npm path if exists
[ -d /usr/local/share/npm/bin ] && PATH=$PATH:/usr/local/share/npm/bin
[ -d $HOME/local/bin ] && PATH=$PATH:$HOME/local/bin
[ -d $HOME/bin ] && PATH=$PATH:$HOME/bin
[ -d ~/.local/bin ] && PATH=$PATH:~/.local/bin
