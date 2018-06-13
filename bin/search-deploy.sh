#!/bin/bash
NOW=$(date +%Y%m%dT%H%M)
echo "search_$NOW"
./deploy.sh --version "search_$NOW"
echo "search_$NOW"
