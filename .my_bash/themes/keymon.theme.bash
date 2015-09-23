#!/usr/bin/env bash

__my_rvm_ruby_version() {
  local gemset=$(echo $GEM_HOME | awk -F'@' '{print $2}')
  [ "$gemset" != "" ] && gemset="@$gemset"
  local version=$(echo $MY_RUBY_HOME | awk -F'-' '{print $2}')
  echo "$version$gemset"
}

# From answer in: http://stackoverflow.com/a/2575525/395686 by Dennis Williamson
get_tty_cursor_position() {
    # based on a script from http://invisible-island.net/xterm/xterm.faq.html
    exec < /dev/tty
    local oldstty=$(stty -g)
    stty raw -echo min 0
    # on my system, the following line can be replaced by the line below it
    echo -en "\033[6n" > /dev/tty
    # tput u7 > /dev/tty    # when TERM=xterm (and relatives)
    IFS=';' read -r -d R -a pos
    stty $oldstty
    # change from one-based to zero based so they work with: tput cup $row $col
    __cursor_row=$((${pos[0]:2} - 1))    # strip off the esc-[
    __cursor_col=$((${pos[1]} - 1))
}

prompt_setter() {
  local return_code=$?
  local return_color
  [ "z${return_code}" == "z0" ] && return_color="" || return_color=$red

  local scm_info=$(scm_prompt_info)

  local head_ps1="${return_color:-${green}}\\\$?=${return_code} \t${reset_color}${scm_info} rb:$(__my_rvm_ruby_version) ${reset_color}"
  local base_ps1="${green}\u${reset_color}@${yellow}\H${reset_color}:${cyan}\w${reset_color}\$"


  TITLEBAR="\033]0;${scm_info} \u@\H:\W\007"

  # Add a new line if the line in last command does not end in new line
  get_tty_cursor_position
  if [[ "$__cursor_col" -gt 0 ]]; then
        TITLEBAR="\n$TITLEBAR"
  fi

  PS1="$TITLEBAR${head_ps1}\n${base_ps1} "
  PS2='> '
  PS4='+ '


  # Save history
  history -a
  history -c
  history -r
}

PROMPT_COMMAND=prompt_setter

SCM_THEME_PROMPT_DIRTY=" ✗"
SCM_THEME_PROMPT_CLEAN=" ✓"
SCM_THEME_PROMPT_PREFIX=" ("
SCM_THEME_PROMPT_SUFFIX=")"
