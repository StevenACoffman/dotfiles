#!/bin/bash
function install_peer_deps() {
  export PKG="${1:-eslint-config-airbnb}"
  npm info "$PKG@latest" peerDependencies --json | command sed 's/[\{\},]//g ; s/: /@/g' | xargs npm install --save-dev "$PKG@latest"
}

function install_global_peer_deps() {
  export PKG="${1:-eslint-config-airbnb}"
  npm info "$PKG@latest" peerDependencies --json | command sed 's/[\{\},]//g ; s/: /@/g' | xargs npm install -g "$PKG@latest"
}
