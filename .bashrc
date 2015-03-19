#!/bin/bash


[ -r "$HOME/bin/shell/bash_profile.sh" ] && source "$HOME/bin/shell/bash_profile.sh";

#Ruby stuff.
#Ok, I don't know if this would be better
#eval "$(rbenv init -)"
if which rbenv > /dev/null; then eval "$(rbenv init - --no-rehash)"; fi
#Python stuff
if [ -d ~/.virtualenvs ]; then
  export WORKON_HOME=~/.virtualenvs
fi

# Seemingly necessary for docker. Irritating the rest of the time. Don't have a good test if docker launched shell. Maybe Process name?
#$(boot2docker shellinit)
