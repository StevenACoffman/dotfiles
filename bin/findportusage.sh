#!/bin/bash
# This is an example, not really a working script
sudo lsof -i :"${1:-8000}"
