#!/bin/bash
#Browser Service - Run after hub is running
BASE_DIR="${HOME}/worldspace"
cd "${BASE_DIR}" || exit

java -jar "${BASE_DIR}/selenium-server-standalone-2.47.1.jar" \
-role rc \
-host localhost \
-hub http://localhost:4444/grid/register \
-maxSession 2 \
-maxBrowsers 3 \
-trustAllSSLCertificates \
-avoidProxy
