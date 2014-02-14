# Load bash_it

# Path to the bash it configuration
export BASH_IT=$HOME/.bash_it

# Lock and Load a custom theme file
# location /.bash_it/themes/
export BASH_IT_THEME='keymon'

# Load Bash It
source $BASH_IT/bash_it.sh

# Load all my enabled plugins, alias and completions
for file_type in "aliases" "completion" "plugins" "custom"; do
	for config_file in $(dirname -- $BASH_SOURCE)/$file_type/*.bash; do
		[ -e "${config_file}" ] && source $config_file
	done
done

