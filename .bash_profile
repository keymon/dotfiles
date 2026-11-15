#!/usr/bin/env bash

source ~/.bashrc

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init.bash 2>/dev/null || :

alias assume=". assume"

# mise shims for non-interactive login shells (.bashrc skips ~/.my_bash there)
source ~/.my_bash/custom/80_mise.bash
