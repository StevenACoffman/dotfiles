#!/bin/bash
# -pl chose module (e.g. web)
# -Dtest=${UNITTESTCLASS} specify unit test class
# -Djetty.skip=true skip starting jetty
# -Dliquibase.should.run=false skip running liquibase
#mvn -Dtest=${UNITTESTCLASS} test
mvn -pl web test -Dtest="$1" -Dliquibase.should.run=false
#-Dmaven.surefire.debug
