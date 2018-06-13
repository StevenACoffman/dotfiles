#!/bin/bash
if [ -z "${COMPONENT}" ] ; then
  COMPONENT="worldspace-loadcontroller"
fi

if [ -z "${COMPONENT_VERSION}" ] ; then
  COMPONENT_VERSION="5.4-SNAPSHOT"
fi

if [ -z "${InstallDir}" ] ; then
  InstallDir="${HOME}/Documents/git/${COMPONENT}"
fi
BASE_DIR="${InstallDir}/build/libs"

"${JAVA_HOME}/bin/java" -Xmx760m \
-Dlog4j.debug \
-Dlog4j.configuration="file:${InstallDir}/target/classes/log4j.properties" \
-jar \
"${BASE_DIR}/${COMPONENT}-${COMPONENT_VERSION}.jar" \
start "${InstallDir}/LoadController.properties"

echo "All done!"
