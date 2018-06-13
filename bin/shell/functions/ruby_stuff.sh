#!/bin/bash


show-remote-rubies() {
    #Show ruby versions that are remotely avaialable for installation
    rbenv install --list
}

showpythons() {
    #Show available installed ruby versions
    rbenv versions
}
