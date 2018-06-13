#!/bin/bash



[ -r "$HOME/bin/shell/bash_profile.sh" ] && source "$HOME/bin/shell/bash_profile.sh";
#Ruby stuff.
#Ok, I don't know if this would be better
#eval "$(rbenv init -)"
if which rbenv > /dev/null; then eval "$(rbenv init - --no-rehash)"; fi
#export PYENV_ROOT="/usr/local/var/pyenv"
#export PATH="$PYENV_ROOT/bin:$PATH"
#if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi
#if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi

#Python stuff
#VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python3
# Setting PATH for Python 3.4
# The orginal version is saved in .bash_profile.pysave
# This is a terrible hack and I need to go home or I'd fix it
#VIRTUALENVWRAPPER_PYTHON=$(pyenv which python)
#export VIRTUALENVWRAPPER_PYTHON
#PATH="$(dirname "${VIRTUALENVWRAPPER_PYTHON}"):/Library/Frameworks/Python.framework/Versions/3.4/bin:${PATH}"
#export PATH
#VIRTUALENVWRAPPER_VIRTUALENV=$(which virtualenv)
#export VIRTUALENVWRAPPER_VIRTUALENV
#VIRTUALENVWRAPPER_VIRTUALENV_SHELL_SCRIPT="$(which virtualenvwrapper.sh)"

#if [ -f $VIRTUALENVWRAPPER_VIRTUALENV_SHELL_SCRIPT ]; then
#  source "$VIRTUALENVWRAPPER_VIRTUALENV_SHELL_SCRIPT"
#else
#  echo "Cannot find $VIRTUALENVWRAPPER_VIRTUALENV_SH"
#fi

#if [ -d ~/.virtualenvs ]; then
#  export WORKON_HOME=~/.virtualenvs
#fi

# Seemingly necessary for docker. Irritating the rest of the time. Don't have a good test if docker launched shell. Maybe Process name?
#$(boot2docker shellinit)

#These are here instead of bash_exports since to avoid messing path order. Irritating.
#if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi
#if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
#export SDKMAN_DIR="/Users/scoffman/.sdkman"
#[[ -s "/Users/scoffman/.sdkman/bin/sdkman-init.sh" ]] && source "/Users/scoffman/.sdkman/bin/sdkman-init.sh"

export NVM_DIR="/Users/scoffman/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Perl? really?
#PATH="/Users/scoffman/perl5/bin${PATH+:}${PATH}"; export PATH;
#PERL5LIB="/Users/scoffman/perl5/lib/perl5${PERL5LIB+:}${PERL5LIB}"; export PERL5LIB;
#PERL_LOCAL_LIB_ROOT="/Users/scoffman/perl5${PERL_LOCAL_LIB_ROOT+:}${PERL_LOCAL_LIB_ROOT}"; export PERL_LOCAL_LIB_ROOT;
#PERL_MB_OPT="--install_base \"/Users/scoffman/perl5\""; export PERL_MB_OPT;
#PERL_MM_OPT="INSTALL_BASE=/Users/scoffman/perl5"; export PERL_MM_OPT;

# Do not do this twice
#[ -f /usr/local/etc/bash_completion.d ] && . /usr/local/etc/bash_completion.d

# tabtab source for serverless package
# uninstall by removing these lines or running `tabtab uninstall serverless`
[ -f /Users/scoffman/.nvm/versions/node/v8.1.3/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.bash ] && . /Users/scoffman/.nvm/versions/node/v8.1.3/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.bash
# tabtab source for sls package
# uninstall by removing these lines or running `tabtab uninstall sls`
[ -f /Users/scoffman/.nvm/versions/node/v8.1.3/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.bash ] && . /Users/scoffman/.nvm/versions/node/v8.1.3/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.bash
