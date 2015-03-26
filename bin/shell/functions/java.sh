#!/bin/bash

#From http://www.jayway.com/2014/01/15/how-to-switch-jdk-version-on-mac-os-x-maverick/
function setjdk() {
  if [ $# -ne 0 ]; then
    removeJavaFromPath '/System/Library/Frameworks/JavaVM.framework/Home/bin'
    #Bash expansion will be "x" if JAVA_HOME set, emptystring if unset
    #http://wiki.bash-hackers.org/syntax/pe#use_an_alternate_value
    if [ -n "${JAVA_HOME+x}" ]; then
      removeJavaFromPath "${JAVA_HOME}/bin"
     fi
    export JAVA_HOME=$(/usr/libexec/java_home -v "$@")
    export PATH=$JAVA_HOME/bin:$PATH
  else
    echo "No argument (i.e. java version e.g. 1.7) specified"
  fi
}
function removeJavaFromPath() {
  if [ $# -ne 0 ]; then
    export PATH="$(echo "$PATH" | sed -E -e "s;:$1;;" -e "s;$1:?;;")"
  else
    echo "No argument (java path) specified"
  fi
}
