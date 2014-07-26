# Support for docker-osx
if which docker-osx &>/dev/null; then
	# Add $DOCKER_HOST if localdocker is in /etc/hosts
	grep -q localdocker /etc/hosts && export DOCKER_HOST="tcp://localdocker:4243"
elif which boot2docker &>/dev/null; then
	export DOCKER_HOST=$(boot2docker cfg 2> /dev/null | awk '/LowerIP/ { gsub(/"/, "", $3); ip=$3 } /DockerPort/ { port=$3 }  END { print "tcp://" ip ":" port }')
fi
