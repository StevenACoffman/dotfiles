#!/bin/bash
PATH="/Library/Frameworks/Python.framework/Versions/3.4/bin:${PATH}"
export PATH
VIRTUALENVWRAPPER_PYTHON=$(which python3)
export VIRTUALENVWRAPPER_PYTHON
VIRTUALENVWRAPPER_VIRTUALENV=$(which virtualenv)
export VIRTUALENVWRAPPER_VIRTUALENV
VIRTUALENVWRAPPER_VIRTUALENV_SHELL_SCRIPT="$(which virtualenvwrapper.sh)"

if [ -f $VIRTUALENVWRAPPER_VIRTUALENV_SHELL_SCRIPT ]; then
  source "$VIRTUALENVWRAPPER_VIRTUALENV_SHELL_SCRIPT"
else
  echo "Cannot find $VIRTUALENVWRAPPER_VIRTUALENV_SH"
fi

if [ -d ~/.virtualenvs ]; then
  export WORKON_HOME=~/.virtualenvs
fi
# Returns "*" if the current git branch is dirty.
function does_virtualenv_exist () {
  if [ ! -d "$WORKON_HOME/$1" ]
  then
  #Dirty
    return 0
  else
  #Clean
    return 1
  fi
}

function update_git_repos {
  # store the current dir
  BLACK="\033[0;30m"
  BLUE="\033[0;34m"
  ORANGE="\033[0;33m"
  CYAN="\033[0;36m"
  DARK_GRAY="\033[1;30m"
  GREEN="\033[0;32m"
  LIGHT_BLUE="\033[1;34m"
  LIGHT_CYAN="\033[1;36m"
  LIGHT_GRAY="\033[0;37m"
  LIGHT_GREEN="\033[1;32m"
  LIGHT_PURPLE="\033[1;35m"
  LIGHT_RED="\033[1;31m"
  PURPLE="\033[0;35m"
  RED="\033[0;31m"
  WHITE="\033[1;37m"
  YELLOW="\033[1;33m"
  NO_COLOR="\033[0m" # No Color

  CUR_DIR=$(pwd)
  # Let the person running the script know what's going on.
  echo -e "\n${WHITE}Pulling in latest changes for all repositories...${NO_COLOR}"

  # Find all git repositories and update it to the master latest revision
  for CURRENT_DOT_GIT_DIR in $(find . -name "requirements.txt" | cut -c 3-); do
      #CURRENT_DOT_GIT_DIR=$(sed 's/.\{17\}$//' <<< "${CURRENT_DOT_GIT_DIR}")
      echo "";

      CURRENT_GIT_DIR="$(dirname "$CURRENT_DOT_GIT_DIR")"

      # We have to go to the .git parent directory to call the pull command
      cd "$CURRENT_GIT_DIR" || exit;
      if does_virtualenv_exist "$CURRENT_GIT_DIR"
      then
        echo -e "${LIGHT_GREEN}${CURRENT_GIT_DIR}${YELLOW} virtualenv does not exist so creating${NO_COLOR}";
        mkvirtualenv "$CURRENT_GIT_DIR"
      else
        echo -e "${ORANGE}${CURRENT_GIT_DIR} virtualenv already exists${NO_COLOR}";
        workon "$CURRENT_GIT_DIR"
      fi
      echo -e "${LIGHT_PURPLE}Installing requirements for ${LIGHT_GREEN}${CURRENT_GIT_DIR}${NO_COLOR}";
      #pip install -r requirements.txt
      #if [ ! -f "$BASEDIR/ve/updated" -o $BASEDIR/requirements.pip -nt $BASEDIR/ve/updated ]; then

          pip install -r requirements.txt
          #touch $BASEDIR/ve/updated
          echo "Requirements installed."
      #fi

      # lets get back to the CUR_DIR
      cd "$CUR_DIR" || exit
  done

  echo -e "\n${GREEN}Complete!${NO_COLOR}"
}

update_git_repos
