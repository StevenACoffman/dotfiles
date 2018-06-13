#!/bin/bash
# Source: https://gist.github.com/isaacs/579814

function program_is_installed {
  # set to 1 initially
  local return_=1
  # set to 0 if not found
  type "$1" >/dev/null 2>&1 || { local return_=0; }
  # return value
  echo "$return_"
}
isNpmPackageInstalled() {
  npm list --depth 1 -g "$1" > /dev/null 2>&1
}

if [ "$(program_is_installed node)" == 0 ]; then

  # take ownership of the folders that npm/node use
  # please don't do this if you don't know what it does!
  sudo mkdir -p /usr/local/{share/man,bin,lib/node,lib/node_modules,include/node}
  sudo chown -R "$USER" /usr/local/{share/man,bin,lib/node,lib/node_modules,include/node}

  # now just a pretty vanilla node install
  # let it use the default paths, but don't use sudo, since there's no need
  mkdir node-install
  curl http://nodejs.org/dist/node-latest.tar.gz | tar -xzf - -C node-install
  cd node-install/*
  ./configure
  make install

  # now the npm easy-install
  curl https://www.npmjs.org/install.sh | sh
else
    echo node is already installed, so skipping
fi
if [ "$(program_is_installed npm)" == 0 ]; then
  sudo mkdir -p /usr/local/lib/node_modules
  sudo chown -R "$USER" /usr/local/lib/node_modules
  curl https://www.npmjs.org/install.sh | sh
else
    echo node is already installed, so skipping
fi

#probably redundant, but harmless
sudo chown -R "$USER" /usr/local/lib/node_modules
sudo chown -R "$USER" /usr/local/lib/dtrace/node.d
sudo chown -R "$USER" /usr/local/share/systemtap/tapset/node.stp
sudo chown -R "$USER" /usr/local/include/node
sudo chown -R "$USER" ~/.config
sudo chown -R "$USER" ~/.npm
#Does not hurt to install twice, but might as well avoid it
if isNpmPackageInstalled n
  then
      echo n is alreadyinstalled globally so skipping
  else
      npm install -g n
  fi
