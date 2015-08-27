#!/bin/bash

for man in 1 3 5 7; do
  ln -sf /usr/local/lib/node_modules/npm/man/man${man}/* /usr/local/share/man/man${man}
done

ln -sf /usr/local/lib/node_modules/npm/bin/npm-cli.js /usr/local/bin/npm

npm update npm -g
