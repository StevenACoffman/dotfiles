#!/bin/bash
export JAVA_HOME=$(/usr/libexec/java_home -v 1.7)
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
#export MAVEN_HOME=/usr/share/maven/
export PATH="/usr/local/opt/maven/libexec/bin:/usr/local/bin:/usr/local/sbin:~/bin:/usr/local/share/npm/bin:$MAVEN_HOME/bin:$JBOSS_HOME/bin:/usr/local/opt/subversion/libexec:$PATH"
export EDITOR='mate --wait'


$(boot2docker shellinit)
