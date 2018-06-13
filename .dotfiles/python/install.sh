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
if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi
if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi
pyenv install 3.5.1
pyenv rehash
#pyenv global 3.5.1
#pyenv shell 3.5.1
pyenv virtualenv 3.5.1 ide-virtualenv-3.5.1
pyenv activate 3.5.1
pip install -U beautysh
pip install -U flake8
pip install -U jedi
pip install -U yapf
pip install -U pytest
#actually installs sqlformat for atom beautify plugin. Yes, this is is confusing.
pip install -U sqlparse
pip install -U proselint
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
