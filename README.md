# dotfiles
There are many dotfiles repos, and this one is mine

### How to create a similar dotfiles repo
1. Set up a github repo
2. Install vcsh (via homebrew as below)
3. Run these commands
```bash
vcsh init dotfiles
vcsh dotfiles add ~/.js*
vcsh dotfiles add .gitignore
vcsh dotfiles add .bash_profile
vcsh dotfiles add .bashrc
vcsh dotfiles add .bash_aliases
vcsh dotfiles add -f bin/bash_functions.sh
vcsh dotfiles add -f bin/execmvn.sh
vcsh dotfiles add -f bin/updateall.sh
vcsh dotfiles add .atom
vcsh dotfiles remote add origin https://github.com/StevenACoffman/dotfiles.git
vcsh dotfiles commit -m 'Initial config files'
vcsh dotfiles pull origin master
vcsh dotfiles push -u origin master
```

### How to restore it
1. Install vcsh and git, github (as below)
2. Run these commands
```bash
vcsh init dotfiles
vcsh dotfiles remote add origin https://github.com/StevenACoffman/dotfiles.git
vcsh dotfiles pull origin master
```

# Mac OS X 10.9 Mavericks

Custom recipe to get OS X 10.9 Mavericks running from scratch, setup applications and developer environment. I use this gist to keep track of the important software and steps required to have a functioning system after a semi-annual fresh install.

## Install Software

The software selected is software that is "tried and true" --- software I need after any fresh install. I often install other software not listed here, but is handled in a case-by-case basis.

## XCode

Start with installing xcode command line tools
```bash
xcode-select --install
```

### Install from App Store

* [Pages](https://itunes.apple.com/us/app/pages/id409201541?mt=12&uo=4)
* [Pomodoro One](https://itunes.apple.com/us/app/pomodoro-one/id907364780?mt=12)
* [Skitch](https://itunes.apple.com/us/app/skitch-snap.-mark-up.-share./id425955336?mt=12&uo=4)
* [Twitter](https://itunes.apple.com/us/app/twitter/id409789998?mt=12&uo=4)
* [WiFi Explorer](https://itunes.apple.com/us/app/wifi-explorer/id494803304?mt=12&uo=4)
* [WiFi Signal](https://itunes.apple.com/us/app/wifi-signal/id525912054?mt=12&uo=4)
* [Todoist](https://itunes.apple.com/us/app/todoist-to-do-list-task-list/id585829637?mt=12&uo=4)
* [Xcode](https://itunes.apple.com/us/app/xcode/id497799835?mt=12&uo=4)

### Install from Third-Party Websites

* Browsers
  * Chrome \(installed via Cask\)
  * [Chrome Canary](https://www.google.com/chrome/browser/canary.html)
  * [Firefox](http://firefox.com)
  * Opera (installed via App Store)
  * [Webkit](http://webkit.org)

* Development
  * [Dropbox](https://www.dropbox.com/install2)
  * [GitHub](http://mac.github.com)
  * [LiveReload](http://livereload.com)
 * [LiveReload Extensions](http://help.livereload.com/kb/general-use/browser-extensions)
 * [Sublime Text 3](http://www.sublimetext.com/3)

* Utilities
  * [1Password](https://agilebits.com/onepassword/mac)
  * iTerm 2 (installed via Cask)
  * [Quicksilver](http://qsapp.com)
  * [Skype](http://www.skype.com/en/download-skype/skype-for-computer/)
  * [Spotify](https://www.spotify.com/us/download/mac/)
	* [Transmit](http://panic.com/transmit)

* Ruby Stuff \(Don\'t forget to add eval to .bashrc \)
```bash
brew install rbenv ruby-build rbenv-gem-rehash rbenv-default-gems
eval "$(rbenv init -)"
rbenv install 2.1.5
rbenv global 2.1.5
gem install compass
```

Fonts
-----
[Mensch coding font](http://robey.lag.net/2010/06/21/mensch-font.html)
Consolas
OpenSans
DejaVu Sans
Source Code Pro
Consolas


#Xcode Command Line Tools

`Xcode > Preferences > Downloads > Command Line Tools`


#Homebrew

## Install Homebrew
```bash
ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
```

## Install Homebrew extension Cask
```bash
brew install caskroom/cask/brew-cask
```

## Install common applications via Homebrew
```bash
brew install git curl lynx mongodb pandoc phantomjs redis shellcheck springboot ssh-copy-id wget
brew install caskroom/cask/brew-cask

```

## Install applications via Homebrew Cask
```bash
brew cask install java
brew cask install eclipse
brew cask install atom
brew cask install iterm2
brew cask install google-chrome
brew cask install textmate
brew cask install skype
brew cask install screenhero
brew cask install keka
brew cask install sublime-text
brew cask install anki
brew cask install tunnelbear
brew cask install vlc
brew cask install sourcetree
brew cask install stellarium
brew cask install intellij-idea
brew cask install beyond-compare
```

## Install Homebrew apps that require java
```bash
brew install tomcat
brew install tomcat-native
brew install --with-java subversion
brew install maven
```

# OS X Preferences

```bash

#Set a blazingly fast keyboard repeat rate
defaults write NSGlobalDomain KeyRepeat -int 0.02

#Set a shorter Delay until key repeat
defaults write NSGlobalDomain InitialKeyRepeat -int 12

#Add a context menu item for showing the Web Inspector in web views
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

#Show the ~/Library folder
chflags nohidden ~/Library

#Store screenshots in subfolder on desktop
mkdir ~/Desktop/Screenshots
defaults write com.apple.screencapture location ~/Desktop/Screenshots
```

Set hostname
------------
`sudo scutil --set HostName geardreams`


#Git

Setup Github
------------
```bash
ssh-keygen -t rsa -C "gears@umich.edu"

# Copy ssh key to github.com
subl ~/.ssh/id_rsa.pub

# Test connection
ssh -T git@github.com

# Set git config values
git config --global user.name "Steve Coffman"
git config --global user.email "gears@umich.edu"
git config --global github.user StevenACoffman
#git config --global github.token your_token_here
git config --global diff.tool bc3
git config --global difftool.bc3 trustExitCode true
git config --global merge.tool bc3
git config --global mergetool.bc3 trustExitCode true
git config --global core.editor "mate --wait"
git config --global color.ui true
```
# SourceTree
* Install License
* Install Command Line Tools:
`SourceTree > Install Command Line Tools`


# Sublime Text

Add Sublime Text CLI
--------------------

```bash
mkdir -p ~/bin && ln -s "/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl" ~/bin/subl
```

## Tomcat
* bin/setenv.sh
* conf/context.xml
* conf/tomcat-users.xml

### Docker
```bash
brew install docker boot2docker
boot2docker init
boot2docker up
```
