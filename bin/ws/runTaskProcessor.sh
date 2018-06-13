#!/bin/sh
if [ -z "${COMPONENT}" ] ; then
  COMPONENT="worldspace-processor-html"
fi

if [ -z "${COMPONENT_VERSION}" ] ; then
  COMPONENT_VERSION="5.4-SNAPSHOT"
fi

if [ -z "${InstallDir}" ] ; then
  InstallDir="${HOME}/Documents/git/${COMPONENT}"
fi
BASE_DIR="${InstallDir}/build/libs"

#"${JAVA_HOME}/bin/java" -Xmx760m \
#-Dlog4j.debug \
#-Dlog4j.configuration="./log4j.properties" \
#-jar \
#"${InstallDir}/target/worldspace-processor-html-5.4-SNAPSHOT-jar-with-dependencies.jar" \
#start "${InstallDir}/env/TaskProcessor-dev.properties"

#"${JAVA_HOME}/bin/java" -Xmx760m -cp \
#"${InstallDir}/target/*:${InstallDir}/target/lib/*:${InstallDir}/" \
#-Dlog4j.debug \
#-Dlog4j.configuration="./log4j.properties" \
# com.deque.taskprocessor.TaskProcessor \
#start "${InstallDir}/env/TaskProcessor-dev.properties"

"${JAVA_HOME}/bin/java" -Xmx760m \
-Dlog4j.debug \
-Dlog4j.configuration="file:${HOME}/worldspace/log4j.properties" \
-jar "${BASE_DIR}/${COMPONENT}-${COMPONENT_VERSION}.jar" \
start "${InstallDir}/env/TaskProcessor-dev.properties"

echo "All done!"
