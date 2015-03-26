#!/bin/bash
#next line prevents accidentally run this
exit 1

vcsh dotfiles filter-branch --tree-filter 'rm -rf .atom/.apm' HEAD
vcsh dotfiles remote remove origin
vcsh dotfiles remote add origin git@github.com:StevenACoffman/dotfiles.git
