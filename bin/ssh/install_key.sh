#!/bin/bash
echo "installing public key for $1"
cat ~/.ssh/id_rsa.pub | ssh "$1" "exec sh -c 'umask 077; test -d ~/.ssh || mkdir ~/.ssh ; cat >> .ssh/authorized_keys'"
