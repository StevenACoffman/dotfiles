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

### How to update it
```bash
vcsh dotfiles add README.md
vcsh dotfiles commit -m "Message goes here"
vcsh dotfiles push -u origin master
```

### How to restore it
0. Get your ssh keys where they need to be, and install [homebrew](https://brew.sh/). 
1. `brew install vcsh git`
2. Run these commands
```bash
vcsh init dotfiles
vcsh dotfiles remote add origin https://github.com/StevenACoffman/dotfiles.git
vcsh dotfiles pull origin master
```

# Mac OS X 10.10 Yosemite

Custom recipe to get OS X 10.10 Yosemite running from scratch, setup applications and developer environment. I use this gist to keep track of the important software and steps required to have a functioning system after a semi-annual fresh install.

## Install Software

The software selected is software that is "tried and true" --- software I need after any fresh install. I often install other software not listed here, but is handled in a case-by-case basis.

## XCode

Start with installing xcode command line tools and agreeing to the license
```bash
xcode-select --install
sudo xcodebuild -license
```
## OS Tweaks
OSX has a ridiculously low limit on the maximum number of open files. If you use OSX to develop Node applications -- or even if you just use Node tools like grunt or gulp -- you've no doubt run into this issue.

```
echo kern.maxfiles=65536 | sudo tee -a /etc/sysctl.conf
echo kern.maxfilesperproc=65536 | sudo tee -a /etc/sysctl.conf
sudo sysctl -w kern.maxfiles=65536
sudo sysctl -w kern.maxfilesperproc=65536
ulimit -n 65536 65536
```

### Install from App Store

* [Pages](https://itunes.apple.com/us/app/pages/id409201541?mt=12&uo=4)
* [Keynote](https://itunes.apple.com/us/app/keynote/id361285480?mt=8)
* [Pomodoro One](https://itunes.apple.com/us/app/pomodoro-one/id907364780?mt=12)
* [Skitch](https://itunes.apple.com/us/app/skitch-snap.-mark-up.-share./id425955336?mt=12&uo=4)
* [WiFi Explorer](https://itunes.apple.com/us/app/wifi-explorer/id494803304?mt=12&uo=4)
* [WiFi Signal](https://itunes.apple.com/us/app/wifi-signal/id525912054?mt=12&uo=4)
* [Todoist](https://itunes.apple.com/us/app/todoist-to-do-list-task-list/id585829637?mt=12&uo=4)
* [Xcode](https://itunes.apple.com/us/app/xcode/id497799835?mt=12&uo=4)
* [MousePose](https://itunes.apple.com/us/app/mousepose/id405904955?mt=12)
* [BreakTime](http://breaktimeapp.com/)
* WunderList - been meaning to try it. It's on my TodoList.
* EverNote - yep
* iBoostUp - meh
* PomodoroTodo


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
 * [Sublime Text 3](http://www.sublimetext.com/3)

* Utilities
  * [1Password](https://agilebits.com/onepassword/mac)
  * iTerm 2 (installed via Cask)
  * [Quicksilver](http://qsapp.com)
  * [Skype](http://www.skype.com/en/download-skype/skype-for-computer/)
	* [Transmit](http://panic.com/transmit)
  * Alfred (installed via Cask)

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
brew install
brew install legit
brew install caskroom/cask/brew-cask
```

## Install Git-Legit git aliases
```
legit install
```
This will install:
* git switch     '!legit switch "$@"'
* git branches   '!legit branches'
* git sprout     '!legit sprout "$@"'
* git unpublish  '!legit unpublish "$@"'
* git harvest    '!legit harvest "$@"'
* git sync       '!legit sync "$@"'
* git publish    '!legit publish "$@"'
* git graft      '!legit graft "$@"'

# Ruby Stuff \(Don't forget to add eval to .bashrc \)
```bash
brew install rbenv ruby-build rbenv-gem-rehash rbenv-default-gems
eval "$(rbenv init -)"
rbenv install 2.1.5
rbenv global 2.1.5
gem install compass
```

* Node Stuff
```bash
brew cask install node
sudo npm install -g n
sudo n latest
sudo chown -R "$USER" /usr/local/lib/node_modules
sudo chown -R "$USER" ~/.npm
#Node Utilities
sudo npm install -g yo
sudo npm install -g bower
sudo npm install -g browserify
sudo npm install -g csscomb
sudo npm install -g csslint
sudo npm install -g eslint
sudo npm install -g fixmyjs
sudo npm install -g grunt-cli
sudo npm install -g gulp
sudo npm install -g htmlhint
sudo npm install -g jshint
sudo npm install -g jsinspect
sudo npm install -g jsxhint
sudo npm install -g less
sudo npm install -g mocha
#Yeoman Generators
sudo npm install -g generator-jhipster
sudo npm install -g generator-mocha
#NodeSchool workshops
sudo npm install -g 6to5
sudo npm install -g bacon-love
sudo npm install -g browserify-adventure
sudo npm install -g bug-clinic
sudo npm install -g count-to-6
sudo npm install -g expressworks
sudo npm install -g functional-javascript-workshop
sudo npm install -g git-it
sudo npm install -g javascripting
sudo npm install -g kick-off-koa
sudo npm install -g learn-generators
sudo npm install -g learnyoumongodb
sudo npm install -g learnyounode
sudo npm install -g lololodash
sudo npm install -g planetproto
sudo npm install -g promise-it-wont-hurt
```

## Install applications via Homebrew Cask
```bash
brew cask install java
brew cask install eclipse
brew cask install intellij-idea
brew cask install atom
brew cask install iterm2
brew cask install google-chrome
brew cask install firefox
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
brew cask install beyond-compare
brew cask install xquartz
```

## Install Homebrew apps that require java to be installed first
```bash
brew install tomcat
brew install tomcat-native
brew install --with-java subversion
brew install maven
```

* Fonts
```bash
brew tap caskroom/fonts
brew cask install font-inconsolata
brew cask install font-source-code-pro
brew cask install font-open-sans
brew cask install font-dejavu-sans
```
  * [Mensch coding font](http://robey.lag.net/2010/06/21/mensch-font.html)
  * Consolas

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
ssh-keygen -t rsa -C "$(whoami)@umich.edu"
chmod 700 ~
chmod 700 ~/.ssh
chmod 700 ~/.ssh/id_rsa
# start the ssh-agent in the background
eval "$(ssh-agent -s)"
ssh-add -K
# Copies the contents of the id_rsa.pub file to your clipboard
pbcopy < ~/.ssh/id_rsa.pub
# Copy ssh key to github.com as per https://help.github.com/articles/generating-ssh-keys/

# Test connection
ssh -T git@github.com

# Set git config values
git config --global user.name "Steve Coffman"
git config --global user.email "$(whoami)@umich.edu"
git config --global github.user StevenACoffman
#git config --global github.token your_token_here
git config --global diff.tool bc
git config --global difftool.bc trustExitCode true
git config --global merge.tool bc
git config --global mergetool.bc trustExitCode true
git config --global core.editor "mate --wait"
git config --global color.ui true
```
# SourceTree
* Install License
* Install Command Line Tools:
`SourceTree > Install Command Line Tools`

# Atom (this list is out of date, see .dotfiles scripts)
* Install Linter (linter-jscs, linter-jshint, linter-shellcheck, linter-scss, linter-htmlhint )
* Install atom-beautify
* Install fixmyjs package
* Install AutoComplete-plus
* Install color-picker
* Install file-icons
* Install project-manager


## Sublime Text

Add Sublime Text CLI
--------------------

```bash
mkdir -p ~/bin && ln -s "/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl" ~/bin/subl
```
## Firefox extensions
* Sage
* Saved Password editor
* ShareMeNot

## Chrome
* install postman
* install jetpack
* install advanced rest client
* install form filler
* install uxcheck
* install colorzilla
* install ruul
* install perfect pixel
* install page load timer
* install WAVE Evaluation Tool

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
