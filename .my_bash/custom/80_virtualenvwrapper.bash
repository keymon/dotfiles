VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python
if [ -f "$(which virtualenvwrapper.sh 2> /dev/null)" ]; then
	source $(which virtualenvwrapper.sh)
fi
