#!/bin/bash
export JAVA_HOME
JAVA_HOME=$(/usr/libexec/java_home -v 1.8)
export PATH=$JAVA_HOME/bin:$PATH
export SGK_ENVIRONMENT=test
export SGK_BASE_DOMAIN=cirrostratus.org
# Local Service Locator Magic: https://github.com/ithaka/Quercus/blob/master/service-locator/ReadMe.md
export DISABLE_LEGACY_SERVICE_LOCATOR=true
export sagoku_domain=cirrostratus.org
export sagoku_environment=test
export sagoku_index=01
export sagoku_region=us-east-1
export sagoku_service
sagoku_service="sidecar-$(echo "$(whoami)" | tr -d '[:blank:]')"
export sagoku_name=$sagoku_service$sagoku_index
export sagoku_hostname=$sagoku_name.$sagoku_environment.$sagoku_domain
export SGK_EUREKA_SKIP_REGISTRATION=true  # **
java -Djava.security.egd=file:/dev/./urandom -server -Xms128m -Xmx256m -jar "$HOME/Documents/sidecar/sidecar-2.7.9-SNAPSHOT.war" --sidecar.watchablesEnabled=true --server.port=8888
# export JAVA_HOME
# JAVA_HOME=$(/usr/libexec/java_home -v 1.8)
# export SGK_ENVIRONMENT=test
# export SGK_BASE_DOMAIN=cirrostratus.org
# export PATH="$JAVA_HOME/bin:${PATH}"
# # This option makes your local invocation of Sidecar to not register itself as an ec2 instance, which will cause service discovery issues if it tries and fails.
# export SGK_EUREKA_SKIP_REGISTRATION=true
#java -Djava.security.egd=file:/dev/./urandom -server -Xms128m -Xmx256m -jar "$HOME/Documents/sidecar/sidecar-2.5.3.war" --sidecar.watchablesEnabled=true --server.port=8888
