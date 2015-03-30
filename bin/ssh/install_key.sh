#!/bin/bash

if [ $# -eq 1 ]
then
  echo "installing public key for $1"
  cat ~/.ssh/id_rsa.pub | ssh "$1" "exec sh -c 'umask 077; test -d ~/.ssh || mkdir ~/.ssh ; cat >> .ssh/authorized_keys'"
else
  echo "You need to specify a server name"
fi
