#!/bin/bash
#https://github.com/hackedd/f5vpn-login
if hash f5vpn-login 2>/dev/null
then
  f5vpn-login $(whoami)@vpn1010-macc.msis.med.umich.edu
else
  echo "  Please install f5vpn-login from https://github.com/hackedd/f5vpn-login"
fi
