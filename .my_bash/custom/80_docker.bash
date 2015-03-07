# Support for boot2docker
boot2docker-shellinit() {
	if which boot2docker &>/dev/null; then
		$(boot2docker shellinit 2> /dev/null)
		# In order to map the port, just use this. 
		VBOX_MAP_PORT=$(VBoxManage showvminfo boot2docker-vm --machinereadable | sed -n 's/Forwarding.*docker,tcp,127.0.0.1,\(.*\),,2376.*/\1/p')
		if [ ! -z "$VBOX_MAP_PORT" ]; then
			export DOCKER_HOST=tcp://127.0.0.1:$VBOX_MAP_PORT
			echo "Docker port is mapped in Virtual Box. Using localhost: DOCKER_HOST=$DOCKER_HOST"
		fi
	else 
		echo "Not able to find boot2docker in the PATH, skipping"
	fi
}
boot2docker-shellinit > /dev/null
