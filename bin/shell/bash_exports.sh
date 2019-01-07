#!/bin/bash

# bash_config

# Make vim the default editor
export EDITOR="mate --wait"

# Set Java to a nice reasonable version

JAVA_HOME=$(/usr/libexec/java_home -v 1.8)
export JAVA_HOME
#export JAVA_HOME='/System/Library/Frameworks/JavaVM.framework/Home'
export GOPATH=$HOME/go
#Possibly Problematic next line:
export ANT_HOME=/usr/local/opt/ant/libexec
export MAVEN_HOME=/usr/local/opt/maven/libexec
export MAVEN_OPTS='-Xms256m -XX:MaxPermSize=1024m -Xmx1024m'
export JBOSS_HOME=/usr/local/opt/jboss-as/libexec
export SONAR_RUNNER_HOME=/usr/local/opt/sonar-runner/libexec
export NODE_PATH="/usr/local/lib/node_modules"
export PYENV_ROOT=/usr/local/var/pyenv
export SCALA_HOME=/usr/local/opt/scala
export AWS_REGION="us-east-1"
export AWS_DEFAULT_REGION="us-east-1"
export AWS_DEFAULT_OUTPUT="json"
export AWS_VAULT_DEFAULT_PROFILE='core'
export AWS_VAULT_KEYCHAIN_NAME='login'
export AWS_MFA_NAME='aws-ithakasequoia'
# 3600s is max for chainging roles, but 14400s is mfa policy
export AWS_ASSUME_ROLE_TTL='3600s'
export AWS_SESSION_TTL='12h'
export AWS_FEDERATION_TOKEN_TTL='12h'
#export PYTHONPATH="/usr/local/opt/pypy3/libexec/site-packages:$PYTHONPATH"
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
PHANTOMJS_BIN="$(brew --prefix)/bin/phantomjs"
export PHANTOMJS_BIN

# Make new shells get the history lines from all previous
# shells instead of the default "last window closed" history
export PROMPT_COMMAND="history -a; $PROMPT_COMMAND"

#Set shell to have reasonable limits, see http://docs.basho.com/riak/latest/ops/tuning/open-files-limit/#Mac-OS-X
ulimit -n 65536
#ulimit -u 2048
#ulimit -u unlimited

source "$HOME/secret/secret_exports.sh"
