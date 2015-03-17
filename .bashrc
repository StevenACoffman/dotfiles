#!/bin/bash
export JAVA_HOME=$(/usr/libexec/java_home -v 1.8)
#export JAVA_HOME='/System/Library/Frameworks/JavaVM.framework/Home'
#export JAVA_HOME=/System/Library/Frameworks/JavaVM.framework/Versions/Current/Home
#Possibly Problematic next line:
#export M3_HOME=/usr/local/opt/maven/libexec
export ANT_HOME=/usr/share/ant
export MAVEN_HOME=/usr/local/opt/maven/libexec
#export MAVEN_HOME=/Users/gears/apache-maven-3.0.5
export MAVEN_OPTS='-Xms256m -XX:MaxPermSize=1024m -Xmx1024m'
export JBOSS_HOME=/usr/local/opt/jboss-as/libexec
export SONAR_RUNNER_HOME=/usr/local/opt/sonar-runner/libexec
export NODE_PATH="/usr/local/lib/node_modules"
export PATH="/usr/local/opt/maven/libexec/bin:/usr/local/bin:/usr/local/sbin:~/bin:~/bin/git:/usr/local/share/npm/bin:$MAVEN_HOME/bin:~/.rbenv/shims:/usr/local/opt/subversion/libexec:$PATH"
export PYTHONPATH="/usr/local/lib/python2.7/site-packages:$PYTHONPATH"
export EDITOR='mate --wait'
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
