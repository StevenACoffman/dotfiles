#!/bin/bash
# From https://gist.github.com/munhitsu/1034876

brew install python --framework

#### update/create your .bash_profile
#homebrew
export PATH=/usr/local/bin:/usr/local/sbin:${PATH}

#virtualenv wrapper
if [ -d ~/.virtualenvs ]; then
  export WORKON_HOME=~/.virtualenvs
fi
if [ -f /usr/local/bin/virtualenvwrapper.sh ]; then
  source /usr/local/bin/virtualenvwrapper.sh
fi

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
