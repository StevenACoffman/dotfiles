#!/bin/bash

function cassandra-start() {
    launchctl start homebrew.mxcl.cassandra
}

function cassandra-stop() {
    launchctl stop homebrew.mxcl.cassandra
}
