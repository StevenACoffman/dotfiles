#!/bin/bash
export TOTP="$(2fa ${AWS_MFA_NAME:-aws-edgewiseinannarbor})"
if [[ -n "${TOTP:-}" ]]
then
  aws-vault exec --mfa-token=${TOTP} -j scoffman
else
    echo "No MFA TOTP! 2fa did not find a MFA TOTP."
fi
