#!/usr/bin/env bash

# My own colors to be safe of poluted variables
__prompt_black="\[\e[0;30m\]"
__prompt_red="\[\e[0;31m\]"
__prompt_green="\[\e[0;32m\]"
__prompt_yellow="\[\e[0;33m\]"
__prompt_blue="\[\e[0;34m\]"
__prompt_purple="\[\e[0;35m\]"
__prompt_cyan="\[\e[0;36m\]"
__prompt_white="\[\e[0;37m\]"
__prompt_orange="\[\e[0;91m\]"

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
  local ver_file="${GOENV_ROOT:-$HOME/.goenv}/version"
  [ -f "$ver_file" ] || return
  local goenv_version
  read -r goenv_version < "$ver_file"
  # Check for local .go-version override
  if [ -f ".go-version" ]; then
    read -r goenv_version < ".go-version"
    goenv_version="./${goenv_version}"
  fi
  echo " go:${goenv_version}"
}

__my_nvm_prompt() {
  [ -n "$NVM_BIN" ] || return
  local ver="${NVM_BIN%/bin}"
  echo -n " node:${ver##*/}"
}


__my_cf_prompt() {
  [ "${CF_HOME}" ] || return
  echo -n " cf:"
  basename "${CF_HOME}" 2> /dev/null
}

# https://github.com/dylanaraps/pure-bash-bible#get-the-current-cursor-position
# https://unix.stackexchange.com/a/647881
new_line_ps1() {
  IFS='[;' read -p $'\e[6n' -d R -rs _ y x _
  if [[ "$x" != 1 ]]; then
    printf "\n${__prompt_yellow}^^ no newline at end of output ^^\n${reset_color}"
  fi
}
# print a new line if the prompt is to long.
# workaround for the wrapping problem I had using new line
#
# Actually the problem is only on bash 5.0
#
# To test:
#
# docker run -ti bash:5.0-alpine3.18
# PROMPT_COMMAND=
# PS1="header of prompt...\n and a long long long long long long long long long long long long long long long long long long long long long long long long long long long long prompt after the newline$ "
#
# vs
#
# docker run -ti bash:5.1-alpine3.18
# PROMPT_COMMAND=
# PS1="header of prompt...\n and a long long long long long long long long long long long long long long long long long long long long long long long long long long long long prompt after the newline$ "
#
__cached_hostname="${HOSTNAME:-$(hostname)}"
new_line_long_path() {
  local possible_prompt="${USER}@${__cached_hostname}:${PWD}\$ "

  if [[ "${#possible_prompt}" -ge "${COLUMNS:-80}" ]]; then
    echo " ${__prompt_red}↵${reset_color}\n\$"
  fi
}

# --- Async SCM prompt infrastructure ---
__SCM_CACHE_DIR="/tmp/bash_scm_cache_$$"
mkdir -p "${__SCM_CACHE_DIR}" 2>/dev/null
trap 'rm -rf "${__SCM_CACHE_DIR}"' EXIT

# Resolve cache file path for current git repo (result cached in __scm_current_cache)
__scm_current_cache=""
__scm_resolve_cache() {
  local git_dir
  git_dir=$(git rev-parse --absolute-git-dir 2>/dev/null) || { __scm_current_cache=""; return 1; }
  # Use tr to replace / with _ for a safe filename (no fork to md5)
  __scm_current_cache="${__SCM_CACHE_DIR}/${git_dir//\//_}"
}

# Read cached SCM info (instant) — uses variable, no subshell
__scm_read_cache() {
  [[ -n "${__scm_current_cache}" && -f "${__scm_current_cache}" ]] || return
  cat "${__scm_current_cache}"
}

# Compute SCM info in background, guarded by flock (one update per repo)
__scm_update_async() {
  [[ -n "${__scm_current_cache}" ]] || return
  local cache_file="${__scm_current_cache}"
  local lock_file="${cache_file}.lock"
  (
    flock -n 9 || exit 0
    scm_prompt_info > "${cache_file}.tmp" 2>/dev/null
    mv "${cache_file}.tmp" "${cache_file}"
  ) 9>"${lock_file}" &
  disown
}

# Quick fallback: just branch name (fast, for first visit to a repo)
__scm_quick_branch() {
  local branch
  branch=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null) || return
  echo " (${branch} ...)"
}

prompt_command() {
  local return_code=$?
  local return_color
  [ "z${return_code}" == "z0" ] && return_color="" || return_color="${__prompt_red}"

  # Resolve cache path once, then read cached SCM info (instant)
  __scm_resolve_cache
  local scm_info
  scm_info=$(__scm_read_cache)
  if [[ -z "${scm_info}" ]]; then
    scm_info=$(__scm_quick_branch)
  fi
  # Kick off background update for next prompt
  __scm_update_async

  local head_ps1=""
  # head_ps1="${head_ps1}$(new_line_ps1)"
  head_ps1="${head_ps1}${return_color:-${__prompt_green}}\\\$?=${return_code}${reset_color}"
  head_ps1="${head_ps1}${scm_info}"
  head_ps1="${head_ps1}$(__my_rvm_prompt)$(__my_rbenv_prompt)$(__my_goenv_prompt)$(__my_gvm_prompt)$(__my_nvm_prompt)$(__my_cf_prompt)$(virtualenv_prompt)${reset_color}"
  head_ps1="${head_ps1}${AWS_ACCOUNT_NAME:+ aws:${AWS_ACCOUNT_NAME}}"
  head_ps1="${head_ps1}${AWS_PROFILE:+ aws:${AWS_PROFILE}}"

  local base_ps1="${__prompt_green}\u${reset_color}@${__prompt_yellow}\H${reset_color}:${__prompt_cyan}\w${reset_color}$"
  base_ps1="${base_ps1}$(new_line_long_path)"

  TITLEBAR="\[\033]0;${scm_info} \u@\H:\W\007\]"

  PS1="${TITLEBAR}${head_ps1}\n${base_ps1} "
  PS2='> '
  PS4='+ '

  # Save history
  history -a
  history -c
  history -r
}

# PROMPT_COMMAND=prompt_setter
PROMPT_COMMAND=prompt_command

# safe_append_prompt_command prompt_command

SCM_THEME_PROMPT_DIRTY_COLOR=" ${__prompt_red}✗${reset_color}"
SCM_THEME_PROMPT_DIRTY=" ✗"
SCM_THEME_PROMPT_CLEAN_COLOR=" ${__prompt_green}✓${reset_color}"
SCM_THEME_PROMPT_CLEAN=" ✓"
SCM_THEME_PROMPT_PREFIX=" ("
SCM_THEME_PROMPT_SUFFIX=")"
RVM_THEME_PROMPT_PREFIX=" rb:"
RVM_THEME_PROMPT_SUFFIX=""
VIRTUALENV_THEME_PROMPT_PREFIX=" py:"
VIRTUALENV_THEME_PROMPT_SUFFIX=""
