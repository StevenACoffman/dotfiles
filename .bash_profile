#!/bin/bash

if [ -f ~/.bashrc ]; then . ~/.bashrc; fi

for f in /usr/local/etc/bash_completion.d/*; do
   . "$f"
done
# Add gogit and gosvn as bash functions
source ~/bin/bash_functions.sh
source ~/.bash_aliases
