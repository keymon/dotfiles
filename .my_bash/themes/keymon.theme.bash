#!/usr/bin/env bash

__my_rvm_prompt() {
	if type rvm-prompt > /dev/null 2>&1; then
		echo -n " rb:"
		rvm-prompt | sed 's/ruby-//'
	else
		type __my_rvm_ruby_version > /dev/null 2>&1 || return
		echo -n " rb:"
		local gemset=$(echo $GEM_HOME | awk -F'@' '{print $2}')
		[ "$gemset" != "" ] && gemset="@$gemset"
		local version=$(echo $MY_RUBY_HOME | awk -F'-' '{print $2}')
		echo "$version$gemset"
	fi
}

__my_rbenv_prompt() {
  type rbenv > /dev/null 2>&1 || return
  echo -n " rb:"
  rbenv version 2>&1 | cut -f 1 -d " "
}

__my_gvm_prompt() {
  local gvm_version=${GVM_OVERLAY_PREFIX}
  gvm_version=${gvm_version##*/pkgsets/}
  gvm_version=${gvm_version%%/*}
  gvm_version=${gvm_version##go};
  echo "${gvm_version:+ go:${gvm_version}}"
}

__my_goenv_prompt() {
  if [ -f "$HOME/.goenv/version" ] && which goenv > /dev/null 2>&1; then
    goenv_version="$(goenv version | cut -f 1 -d ' ')"
    # note that is a local version
    if ! goenv version | grep -q $HOME/.goenv/version; then
      goenv_version="./${goenv_version}"
    fi
  fi
  echo "${goenv_version:+ go:${goenv_version}}"
}

__my_nvm_prompt() {
  type nvm > /dev/null 2>&1 || return
  echo -n " node:"
  nvm current
}


__my_cf_prompt() {
  [ "${CF_HOME}" ] || return
  echo -n " cf:"
  basename "${CF_HOME}" 2> /dev/null
}

prompt_setter() {
  local return_code=$?
  local return_color
  [ "z${return_code}" == "z0" ] && return_color="" || return_color=$red

  local scm_info=$(scm_prompt_info)

  local head_ps1="${return_color:-${green}}\\\$?=${return_code} \t${reset_color}${scm_info}$(__my_rvm_prompt)$(__my_rbenv_prompt)$(virtualenv_prompt)$(__my_goenv_prompt)$(__my_gvm_prompt)$(__my_nvm_prompt)$(__my_cf_prompt)${reset_color}${AWS_ACCOUNT_NAME:+ aws:${AWS_ACCOUNT_NAME}}"
  local base_ps1="${green}\u${reset_color}@${yellow}\H${reset_color}:${cyan}\w${reset_color}\$"

  TITLEBAR="\033]0;${scm_info} \u@\H:\W\007"

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
RVM_THEME_PROMPT_PREFIX=" rb:"
RVM_THEME_PROMPT_SUFFIX=""
VIRTUALENV_THEME_PROMPT_PREFIX=" py:"
VIRTUALENV_THEME_PROMPT_SUFFIX=""
