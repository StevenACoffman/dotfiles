#!/bin/bash

pmr() {
        #Django, really.
  python ./manage.py runserver
}

pmt() {
        #Django, really.
  python ./manage.py test
}

pmm() {
    #Django, really.
  python ./manage.py migrate
}

pirr() {
  pip install --upgrade pip
  pip install -r requirements.txt
}
gojstor() {
  cd "$HOME/Documents/git/jstor" || return 1
}
# Start an HTTP server from a directory, optionally specifying the port
pyserver() {
    # Get port (if specified)
    local port="${1:-8000}"

    # Open in the browser
    open "http://localhost:${port}/"

    # Redefining the default content-type to text/plain instead of the default
    # application/octet-stream allows "unknown" files to be viewable in-browser
    # as text instead of being downloaded.
    #
    # Unfortunately, "python -m SimpleHTTPServer" doesn't allow you to redefine
    # the default content-type, but the SimpleHTTPServer module can be executed
    # manually with just a few lines of code.
    python -c $'import SimpleHTTPServer;\nSimpleHTTPServer.SimpleHTTPRequestHandler.extensions_map[""] = "text/plain";\nSimpleHTTPServer.test();' "$port"
}

gopy() {
    #activates pyenv and pyenv-virtualenv
    #export PATH="$PYENV_ROOT/bin:$PATH"
    export PATH="$HOME/.pyenv/bin:$PATH"
    if [ -n "$(type -t pyenv)" ] && [ "$(type -t pyenv)" = function ]; then
        echo "pyenv is already initialized"
        true
    else
		if which pyenv > /dev/null 2>&1; then
        	eval "$(pyenv init -)"
		else
          echo "You do not have pyenv installed"
		fi
        if which pyenv-virtualenv-init > /dev/null; then
		  eval "$(pyenv virtualenv-init -)"
		else
          echo "You do not have pyenv-virtualenv installed"
		fi
    fi
}
workon() {
    gopy
	export PYENV_VIRTUALENV_DISABLE_PROMPT=1
    pyenv activate "$1"
}

workdone() {
    gopy
    export PYENV_VIRTUALENV_DISABLE_PROMPT=1
    pyenv deactivate
}

lsvirtualenv() {
    gopy
    pyenv virtualenvs
}

mkvirtualenv() {
    # For pycharm use:
# pyenv virtualenv <specific python version> <environment name> --copies

    PYTHON_VERSION=${2:-3.6.5}
    echo "Python version $PYTHON_VERSION"
    gopy
    pyenv virtualenv "${PYTHON_VERSION}" "$1"
}

showpythons() {
    #Show available installed python versions
    pyenv versions
}

show-remote-pythons() {
    #Show python versions that are remotely avaialable for installation
    pyenv install --list
}
install-python() {
    PYTHON_VERSION=${1:-3.6.5}
    echo "Installing Python version $PYTHON_VERSION"
    pyenv install "${PYTHON_VERSION}"
}
