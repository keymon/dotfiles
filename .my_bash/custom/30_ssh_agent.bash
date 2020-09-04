
SSH_AGENT_INFO=~/.ssh/ssh-agent.sh
if [ -f "${SSH_AGENT_INFO}" ]; then
  source "${SSH_AGENT_INFO}" > /dev/null
fi

if ! ssh-add -l > /dev/null 2>&1; then
  if ! ssh-add -l 2> /dev/null | grep -q "The agent has no identities."; then
    echo "Starting SSH agent"
    eval "$(ssh-agent | tee "${SSH_AGENT_INFO}")"
  fi
fi
