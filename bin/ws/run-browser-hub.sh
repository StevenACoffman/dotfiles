#!/bin/bash
#Browser Hub - Running before Service
BASE_DIR="${HOME}/worldspace"
cd "${BASE_DIR}" || exit

java -jar "${BASE_DIR}/selenium-server-standalone-2.47.1.jar" \
-role hub \
-host localhost \
-timeout 600000 \
-browserTimeout 600000 \
-debug \
-log hub.log
