#!/bin/bash
#mvn test -Dit.test=AcademicPeriodRepositoryIT verify
mvn -pl web test -Dit.test=${ITCLASS} verify
#mvn verify -pl web -Dmaven.failsafe.debug
#unit test
#mvn -Dtest=${UNITTESTCLASS} test
#mvn -pl web test -Dtest=AssessmentTestRenderingControllerTest -Djetty.skip=true -Dliquibase.should.run=false
