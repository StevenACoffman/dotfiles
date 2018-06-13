#!/bin/bash

function pyfind() {
  find . -name '*.py' -type f -exec grep -H "$1" {} \;
}

function htmlfind() {
  find . -name '*.html' -type f -exec grep -H "$1" {} \;
}

function jsfind() {
  find . -name '*.js' -name '*.jsx' -type f -exec grep -H "$1" {} \;
}

function reqfind() {
  find . -name 'requirements.txt' -type f -exec grep -H "$1" {} \;
}

function sassfind() {
  find . -type f \( -name '*.sass' -o -name '*.scss' \) -exec grep -H "$1" {} \;
}

function javafind() {
  find . -name '*.java' -type f -exec grep -H "$1" {} \;
}

function groovyfind() {
  find . -name '*.groovy' -type f -exec grep -H "$1" {} \;
}

function jspfind() {
  find . -name '*.jsp' -type f -exec grep -H "$1" {} \;
}

function xmlfind() {
  find . -name '*.xml' -type f -exec grep -H "$1" {} \;
}

function pomfind() {
  find . -name 'pom.xml' -type f -exec grep -H "$1" {} \;
}

function rubyfind() {
    find . -name '*.rb' -type f -exec grep -H "$1" {} \;
}

function featurefind() {
    find . -name '*.feature' -type f -exec grep -H "$1" {} \;
}

function propertiesfind() {
  find . -name '*.properties' -type f -exec grep -H "$1" {} \;
}

function shfind() {
  find . -name '*.sh' -type f -exec grep -H "$1" {} \;
}

function yamlfind() {
  find . -type f \( -name '*.yaml' -o -name '*.yml' \) -exec grep -H "$1" {} \;
}

function mdfind() {
  find . -type f -name '*.md' -exec grep -H "$1" {} \;
}
