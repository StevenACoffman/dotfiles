#!/bin/bash
function check_status {
  STATUS=$?
  echo $STATUS
  if [ $STATUS -gt 0 ]; then
  echo "Failed. I'm out, yo."
  exit 1
  fi

}
BASE_DIR="${HOME}/Documents/git"
cd "${BASE_DIR}" || exit
cd "${BASE_DIR}/worldspace-commons" || exit
gradle publishToMavenLocal --refresh-dependencies -PuseMavenLocal
check_status
cd "${BASE_DIR}/worldspace-processor-base" || exit
gradle publishToMavenLocal --refresh-dependencies -PuseMavenLocal
check_status
cd "${BASE_DIR}/worldspace-processor-html" || exit
gradle uberJar --refresh-dependencies -PuseMavenLocal
check_status
#mvn clean package assembly:single -DskipTests
