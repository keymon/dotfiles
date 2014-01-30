# Create casper-pass alias to override the PASSWORD_STORE_DIR env variable
alias casper-pass='PASSWORD_STORE_DIR=~/.casper-pass pass'

# Load the bash completion definition
[ -f /etc/bash_completion.d/password-store ] && source /etc/bash_completion.d/password-store
[ -f /usr/local/etc/bash_completion.d/password-store ] && source /usr/local/etc/bash_completion.d/password-store
[ -f ~/tools/password-store/contrib/pass.bash-completion ] && source ~/tools/password-store/contrib/pass.bash-completion
# Small hack to allow use alternate path for PASSWORD_STORE_DIR in bash completion
if type _pass > /dev/null 2>&1; then
	_casper_pass_completion() { PASSWORD_STORE_DIR=$HOME/.casper-pass/ _pass; }
	complete -o filenames -o nospace -F _casper_pass_completion casper-pass
fi 

