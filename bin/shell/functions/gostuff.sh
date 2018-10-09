#!/bin/bash

function gobuildlinux {
     GOOS=linux go build -ldflags='-s -w'
}
