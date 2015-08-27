#!/bin/bash
export JPDA_ADDRESS=8000
export JPDA_TRANSPORT=dt_socket
/usr/local/opt/tomcat/libexec/bin/shutdown.sh -force || true 
/usr/local/opt/tomcat/libexec/bin/catalina.sh jpda start

