
if [ -x "/usr/local/bin/python" ]; then
	VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python
else
	VIRTUALENVWRAPPER_PYTHON="$(which python python2 python3  | head -n1)"
fi
if [ -f "$(which virtualenvwrapper.sh 2> /dev/null)" ]; then
	source $(which virtualenvwrapper.sh)
elif [ -f /usr/share/bash-completion/completions/virtualenvwrapper ]; then
	source  /usr/share/bash-completion/completions/virtualenvwrapper
fi

if [[ -z "${VIRTUAL_ENV}" ]]; then
	workon default 2>&1 > /dev/null || true
fi
