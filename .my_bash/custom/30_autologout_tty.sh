# via https://askubuntu.com/a/408474
# autologout on tty1-6 after 10 minutes
if [[ $(tty) =~ /dev\/tty[1-6] ]]; then TMOUT=600; fi

