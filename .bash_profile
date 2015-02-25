#!/bin/bash

if [ -f ~/.bashrc ]; then . ~/.bashrc; fi
#Ruby stuff.
eval "$(rbenv init - --no-rehash)"
#Ok, I don't know if this would be better
#if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

for f in /usr/local/etc/bash_completion.d/*; do
   . $f
done
# Add gogit and gosvn as bash functions
source ~/bin/bash_functions.sh
source ~/.bash_aliases
