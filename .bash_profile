#!/usr/bin/env bash

# Path to the bash it configuration
export BASH_IT=$HOME/.bash_it

# Lock and Load a custom theme file
# location /.bash_it/themes/
export BASH_IT_THEME='keymon'

# Load Bash It
source $BASH_IT/bash_it.sh

# Load my own Bash extensions
source ~/.my_bash/load_all.sh
