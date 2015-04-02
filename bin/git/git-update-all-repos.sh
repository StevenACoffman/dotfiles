#!/bin/bash

# Returns "*" if the current git branch is dirty.
function is_git_dirty {
  if [ -n "$(git diff --shortstat 2> /dev/null | tail -n1)" ]
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
  for CURRENT_DOT_GIT_DIR in $(find . -name ".git" | cut -c 3-); do
      echo "";

      CURRENT_GIT_DIR="$(dirname "$CURRENT_DOT_GIT_DIR")"

      # We have to go to the .git parent directory to call the pull command
      cd "$CURRENT_GIT_DIR";
      git checkout master > /dev/null 2>&1
      #if [ -n "$(git diff --shortstat 2> /dev/null | tail -n1)" ]
      if is_git_dirty
      then

        echo -e "${ORANGE}$CURRENT_GIT_DIR is ${RED}Dirty${ORANGE} so fetching${NO_COLOR}";
        git fetch

      else
        echo -e "${LIGHT_PURPLE}$CURRENT_GIT_DIR is ${LIGHT_BLUE}Clean${LIGHT_PURPLE} so pulling${NO_COLOR}";
        git pull origin master > /dev/null 2>&1
        #Should never happen, but just in case
        if [ $? -ne 0 ]
        then
          echo -e "${RED}Merge failed for ${WHITE}$CURRENT_GIT_DIR${WHITE} so aborting${NO_COLOR}"
          git merge --abort
        fi
      fi
      # lets get back to the CUR_DIR
      cd "$CUR_DIR"
  done

  echo -e "\n${GREEN}Complete!${NO_COLOR}"
}

update_git_repos
