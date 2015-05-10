#!/bin/bash
cd ~/Documents/git/assessment_services/web
echo Executing TestDataSetup
mvn exec:java -Dexec.mainClass="edu.umich.umms.assessment.services.clerkship.util.TestDataSetup"

#mvn exec:java -Dexec.mainClass="edu.umich.umms.assessment.services.clerkship.util.ResponseSetStatisticsDataSetup"
