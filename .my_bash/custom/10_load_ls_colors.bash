export LS_OPTIONS='-F'
if ls --help 2> /dev/null | grep 'color' > /dev/null && [ -f ~/.LS_COLORS ]; then
  export LS_COLORS=`< ~/.LS_COLORS`
  export LS_OPTIONS="$LS_OPTIONS --color=auto"
fi
alias ls='ls $LS_OPTIONS'

