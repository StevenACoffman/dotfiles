#!/bin/bash

homebrew/install.sh
java/install.sh
ruby/install.sh
python/install.sh

# gitconfig is wrong and needs maintenance, but we don't need to recreate it
#gitconfig/install.sh

#This would require homebrew to be first
#set -e

#cd "$(dirname $0)"/..

# find the installers and run them iteratively
#find . -name install.sh | while read installer ; do sh -c "${installer}" ; done
