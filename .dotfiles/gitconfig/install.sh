#!/bin/bash
# This will set up Git config defaults. Assumes you already installed XCode and your diff and merge tools.

# If you run this, it will overwrite some existing values.
echo ''

info () {
  printf "  [ \033[00;34m..\033[0m ] %s" "$1"
}

user () {
  printf "\r  [ \033[0;33m?\033[0m ] %s " "$1"
}

success () {
  printf "\r\033[2K  [ \033[00;32mOK\033[0m ] %s\n" "$1"
}

fail () {
  printf "\r\033[2K  [\033[0;31mFAIL\033[0m] %s\n" "$1"
  echo ''
  exit
}

install_git () {
  if [ -z "$(brew ls --versions git)" ]
  then
    brew install git
  fi
}

setup_ssh () {
  if [ ! -f ~/.ssh/id_rsa ]; then
    ssh-keygen -t rsa -C "${USER_SHORTNAME}@umich.edu"
    chmod 700 ~
    chmod 700 ~/.ssh
    chmod 700 ~/.ssh/id_rsa
    # start the ssh-agent in the background
    eval "$(ssh-agent -s)"
    ssh-add -K
  # Copies the contents of the id_rsa.pub file to your clipboard
  pbcopy < ~/.ssh/id_rsa.pub
  info "You can paste your public key to gitlab and github now"
  fi
}

setup_gitconfig () {
  USER_SHORTNAME="$(whoami)"
  #USER_FULLNAME=""
  USER_FULLNAME="$(finger "$(whoami)" | awk -F: '{ print $3 }' | head -n1 | sed 's/^ //')"

  # if user.name is empty, then add an user.name
  if [[ -z "$(git config --global --get user.name)" ]]
  then
    git config --global user.name "${USER_FULLNAME}"
  fi

  # if user.email is empty, then add an email
  if [[ -z "$(git config --global --get user.email)" ]]
  then
      git config --global user.email "${USER_SHORTNAME}@umich.edu"
  fi

  # if github.user is empty, then add a github.user
  if [[ -z "$(git config --global --get github.user)" ]]
  then
    user ' - What is your github user id?'
    read -e github_userid
    if [[ -n "$github_userid" ]]
    then
      git config --global github.user "$github_userid"
    else
      info "Skipping setting github user (might cause cask problems)"
    fi
  fi

  # yeah, not going to commit my token here.
  #git config --global github.token your_token_here

  # Make `git rebase` safer on OS X
  # More info: <http://www.git-tower.com/blog/make-git-rebase-safe-on-osx/>
  git config --global core.trustctime false

  # Prevent showing files whose names contain non-ASCII symbols as unversioned.
  # http://michael-kuehnel.de/git/2014/11/21/git-mac-osx-and-german-umlaute.html
  git config --global core.precomposeunicode false

  # Stop typing passwords for HTTPS cloned repos
  # More info: https://help.github.com/articles/caching-your-github-password-in-git/
  git config --global credential.helper osxkeychain

  git config --global color.ui true

  # Most people have XCode installed
  if hash opendiff 2> /dev/null; then
    echo "You don't have XCode installed?"
  else
    info "Setting XCode OpenDiff (FileMerge) as diff and merge tool"
    #Opendiff (FileMerge) to resolve merge conflicts:
    git config --global merge.tool opendiff
    git config --global mergetool.opendiff trustExitCode true
    #Opendiff (FileMerge) as diff tool
    git config --global diff.tool opendiff
    git config --global difftool.opendiff trustExitCode true
  fi

  # Some people like kdiff3
  if hash kdiff3 2>/dev/null; then
    info "You don't have kdiff3 installed (that's normal)"
  else
    git config --global diff.tool kdiff3
    git config --global difftool.kdiff3 trustExitCode true
    git config --global merge.tool kdiff3
    git config --global mergetool.kdiff3 trustExitCode true
  fi

  #Beyond Compare rocks
  if hash bcomp 2>/dev/null; then
    info "You don't have beyond compare installed (it's great, btw)"
  else
    info "Setting Beyond Compare as diff and merge tool"
    git config --global difftool.prompt false
    git config --global diff.tool bc
    git config --global difftool.bc trustExitCode true
    git config --global merge.tool bc
    git config --global mergetool.bc trustExitCode true

  # If you want to define a custom version (might be nice to ensure read only)
  #  git config --global merge.tool bcomp
  #  git config --global mergetool.bcomp.cmd '/usr/local/bin/bcomp \"$BASE\" \"$LOCAL\" \"$REMOTE\" \"$MERGED\"'
  #  git config --global mergetool.bcomp.trustExitCode true
  #  git config --global difftool.bcomp.cmd '/usr/local/bin/bcomp -ro "$LOCAL" "$REMOTE"'
  #  git config --global difftool.bcomp.trustExitCode true

  fi

  # We don't want all those .orig files after a merge that end up getting staged/committed accidentally
  git config --global mergetool.keepBackup false

  # When I say merge, don't ask me if I meant it
  git config --global difftool.prompt false

  if hash edit 2>/dev/null; then
    info "You do not have text wranger installed (that's ok)"
  else
    #TextWrangler as the default editor
    git config --global core.editor "edit -w"
  fi

  if hash mate 2>/dev/null; then
    info "You do not have textmate installed (that's sad)"
  else
    #TextMate as the default editor
    git config --global core.editor "mate -w"
  fi

  #I do not have a license, so nope.
  #git config --global alias.ks "difftool -y -t Kaleidoscope"

  # I do not use command line diffs, so nope on this bit.
  # This gives us 'ours', 'base', and 'theirs', instead of just 'ours' and
  # 'theirs'. More details:
  #   http://psung.blogspot.com/2011/02/reducing-merge-headaches-git-meets.html
  #git config --global merge.conflictstyle diff3

  # Prevents us from having to do merge resolution for things we've already
  # resolved before; see http://git-scm.com/blog/2010/03/08/rerere.html
  git config --global rerere.enabled true

  # With this, "git pull --rebase" is the default form of pull FOR NEWLY CREATED
  # BRANCHES; for branches created before this config option is set, pull.rebase
  # true handles that
  git config --global branch.autosetuprebase always

  # "git pull --rebase" is now the default for pull no matter what
  git config --global pull.rebase true

  # This makes sure that push pushes only the current branch, and pushes it to the
  # same branch pull would pull from
  git config --global push.default upstream

  # This converts CRLF endings to LF endings on Mac & Lin and also keeps them in
  # the repo, but for Windows checkouts it converts LF to CRLF (and back to LF on
  # commits)
  git config --global core.autocrlf input

  #You did set the .gitignore, right?
  # Go to https://github.com/github/gitignore or https://www.gitignore.io/
  # Add anything until you stop getting irritated by files you don't want to track
  git config --global core.excludesfile ~/.gitignore

  # Forces the use of SSH instead of HTTPS for any URLs that point to github.
  # This means that if a repo uses "https://github/..." for "origin", we will
  # automatically use SSH. No more password prompts!
  git config --global url.ssh://git@github.com/.insteadOf https://github.com/

  # WARNING: Will remove all aliases if unstage not set
  if [[ -z "$(git config --global --get alias.unstage)" ]]
  then
    info "Adding git aliases"
    git config --global --remove-section alias
    git config --global alias.unstage 'reset HEAD --'
    git config --global alias.unstash "stash pop"
    git config --global alias.co checkout
    git config --global alias.ci commit
    git config --global alias.br branch

    #  git config --global alias.d difftool
    #  git config --global alias.h help
    #  git config --global alias.sub submodule
    #  git config --global alias.dst "diff --staged"
    #  git config --global alias.dc "!git diff | cdiff -s"
    #  git config --global alias.dcs "!git diff --staged | cdiff -s"
    #  git config --global alias.cp "cherry-pick"
    if hash legit 2>/dev/null; then
      info "You do not have legit installed (and that is ok)"
    else
      legit install
    fi
    #  git config --global alias.lg "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative"
      # This only works if the alias section is at the end.
      #cat ./git_aliases.txt >> ~/.gitconfig
  fi
  ## Git Legit: You did install git legit, right?
  # More info: http://www.git-legit.org/
  # pip install https://github.com/kennethreitz/legit/zipball/master
}

setup_ssh
install_git
setup_gitconfig
