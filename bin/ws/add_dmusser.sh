#!/bin/bash
for dir in "${HOME}/Documents/git/worldspace"*
do
    dir=${dir%*/}
    #echo ${dir##*/}
    cd ${dir##*/}
    #pwd
    git remote add dmusser git@bitbucket.org:dmusser/${dir##*/}.git
    git fetch dmusser
    #git checkout -b upgrade dmusser/upgrade
    #git branch --track upgrade origin/upgrade
    git branch upgrade -u origin/upgrade
    #git config user.email "steve.coffman@deque.com"
    #git branch --track upgrade origin/upgrade
    cd ..
done
