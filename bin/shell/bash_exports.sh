#!/bin/bash

# bash_config

# Make vim the default editor
export EDITOR="mate --wait"

# Set Java to a nice reasonable version
export JAVA_HOME=$(/usr/libexec/java_home -v 1.8)
#export JAVA_HOME='/System/Library/Frameworks/JavaVM.framework/Home'

#Possibly Problematic next line:
export ANT_HOME=/usr/share/ant
export MAVEN_HOME=/usr/local/opt/maven/libexec
export MAVEN_OPTS='-Xms256m -XX:MaxPermSize=1024m -Xmx1024m'
export JBOSS_HOME=/usr/local/opt/jboss-as/libexec
export SONAR_RUNNER_HOME=/usr/local/opt/sonar-runner/libexec
export NODE_PATH="/usr/local/lib/node_modules"
export PYTHONPATH="/usr/local/lib/python2.7/site-packages:$PYTHONPATH"
export HOMEBREW_CASK_OPTS="--appdir=/Applications"

# Ignore duplicate commands in the history
export HISTCONTROL=ignoredups

# Increase the maximum number of lines contained in the history file
# (default is 500)
export HISTFILESIZE=10000

# Increase the maximum number of commands to remember
# (default is 500)
export HISTSIZE=10000

# Don't clear the screen after quitting a manual page
export MANPAGER="less -X"

# Export PhantomJS bin location (be explicit in case Homebrew is not installed
# in the default location)
export PHANTOMJS_BIN="$(brew --prefix)/bin/phantomjs"

# Make new shells get the history lines from all previous
# shells instead of the default "last window closed" history
export PROMPT_COMMAND="history -a; $PROMPT_COMMAND"
