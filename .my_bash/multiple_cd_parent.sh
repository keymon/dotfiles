alias cd..='cd ..'
alias cd...='cd ...'
alias cd....='cd ....'
alias cd.....='cd .....'

function mcd {
  if P=`expr "$1" : '\.\.\(\.\+\)'`; then
    command cd ..
    mcd ".$P"
  else
    command cd "$1"
  fi
}
function cd {
[ $# = 0 ] && command cd && return 0
[ "$1" = "/" -o "$1" = "-" ] && command cd $1 && return 0
if expr "$1" : '\(\.\.\.\+\)' > /dev/null; then
        OLDPWD_=`pwd`
        mcd "$1"
        OLDPWD=$OLDPWD_
else
        command cd "$1"
fi 
}

