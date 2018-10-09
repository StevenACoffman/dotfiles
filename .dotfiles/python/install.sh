#!/bin/bash

# This is bad to pollute system
#sudo easy_install pip
#sudo -H pip install beautysh
#sudo -H pip install yapf
#sudo -H pip install flake8
#sudo -H pip install --upgrade autopep8


# From https://gist.github.com/munhitsu/1034876
#brew install python3 --framework
#pip3 install virtualenv virtualenvwrapper

#brew install pypy3
brew install pyenv
brew install pyenv-virtualenv
brew install pyenv-pip-migrate
#unset PYTHONPATH
#brew postinstall pypy3
#pip_pypy3 install --upgrade pip setuptools


#### update/create your .bash_profile
#homebrew
export PATH=/usr/local/bin:/usr/local/sbin:${PATH}
if [ -n "$(type -t pyenv)" ] && [ "$(type -t pyenv)" = function ]; then
#    echo "pyenv is already initialized"
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

set -e
pyenv install 3.5.1
pyenv install 3.6.5
pyenv install 2.7.15
pyenv rehash
#pyenv global 3.5.1
#pyenv shell 3.5.1

pyenv virtualenv 3.6.5 ide
pyenv activate ide
pip install -U beautysh
pip install -U flake8
pip install -U jedi
pip install -U yapf
pip install -U pytest
#actually installs sqlformat for atom beautify plugin. Yes, this is is confusing.
pip install -U sqlparse
pip install -U proselint
pip install --upgrade pip
pyenv deactivate

pyenv virtualenv 2.7.15 venv-bless
pyenv activate venv-bless
pip install --ignore-installed six boto3 kmsauth
pip install --upgrade pip
pyenv deactivate

pyenv virtualenv 3.6.5 aws
pyenv activate aws
pip install awscli
pip install --upgrade pip
pyenv deactivate


#virtualenv wrapper
#if [ -d ~/.virtualenvs ]; then
#  export WORKON_HOME=~/.virtualenvs
#fi
#if [ -f /usr/local/bin/virtualenvwrapper.sh ]; then
#  source /usr/local/bin/virtualenvwrapper.sh
#fi

#### end of .bash_login

# start new shell and make sure you are using /usr/local/bin/python
# note that it will complain that /usr/local/bin/virtualenvwrapper.sh does not exist
# as we havent installed virtualenvwrapper yet

#which python
#python --version
# make sure its python >=2.7.5

# time to install virtualenvironment
#pip install virtualenvwrapper
#mkdir $HOME/.virtualenvs

# start new shell and from now on you will have access to mkvirtualenv

# NOTE: that the only time you should be asked for yout password is during homebrew installation
# if all goes correctly than none of above commands would ask you for your passoword / would want you to use sudo

exit 0
