# Support for docker-osx
# Add $DOCKER_HOST if localdocker is in /etc/hosts
grep -q localdocker /etc/hosts && export DOCKER_HOST="tcp://localdocker:4243"

# Load bash completion if docker is in the path
# which docker 2>&1 >/dev/null && . ~/.my_bash/completions/docker
