test -d /opt/homebrew && export PATH=/opt/homebrew/bin:$PATH
# Linuxbrew
for brew_prefix in /home/linuxbrew/.linuxbrew "$HOME/.linuxbrew"; do
	if [ -x "$brew_prefix/bin/brew" ]; then
		eval "$("$brew_prefix/bin/brew" shellenv)"
		break
	fi
done
unset brew_prefix
