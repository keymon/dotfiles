
if [ -x "/usr/local/bin/python" ]; then
	VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python
else
	VIRTUALENVWRAPPER_PYTHON=/usr/bin/python
fi
if [ -f "$(which virtualenvwrapper.sh 2> /dev/null)" ]; then
	source $(which virtualenvwrapper.sh)
fi
