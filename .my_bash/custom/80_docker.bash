# Support for docker-machine
docker-machine-shellinit() {
	if which docker-machine &>/dev/null; then
		eval $(docker-machine env 2> /dev/null)
		# In order to map the port, just use this.
		VBOX_MAP_PORT=$(VBoxManage showvminfo $(docker-machine ls | grep virtualbox | awk '{print $1;}') --machinereadable 2> /dev/null | sed -n 's/Forwarding.*docker,tcp,127.0.0.1,\(.*\),,2376.*/\1/p')
		if [ ! -z "$VBOX_MAP_PORT" ]; then
			export DOCKER_HOST=tcp://127.0.0.1:$VBOX_MAP_PORT
			echo "Docker port is mapped in Virtual Box. Using localhost: DOCKER_HOST=$DOCKER_HOST"
		fi
	else
		echo "Not able to find docker-machine in the PATH, skipping"
	fi
}
docker-machine-shellinit > /dev/null
