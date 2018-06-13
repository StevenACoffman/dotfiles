#!/bin/bash
containsElement () {
  local e
  for e in "${@:2}"; do [[ "$e" == "$1" ]] && return 0; done
  return 1
}

VALID_ENVIRONMENTS=("test" "acorn" "prod" "scoffman")
PUPPET_ENVIRONMENT=${1:-scoffman}
if containsElement "${PUPPET_ENVIRONMENT}" "${VALID_ENVIRONMENTS[@]}"; then
    echo Updating puppet environment on tier ${PUPPET_ENVIRONMENT}
else
   echo "Invalid environment ${PUPPET_ENVIRONMENT}" && exit 1
fi

ssh puppet.${PUPPET_ENVIRONMENT}.cirrostratus.org /bin/bash -vex << EOF
cd /opt/continuous-deployment/
sudo git pull origin master
EOF
