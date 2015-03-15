#!/bin/bash
cd ~/Documents/svn/assessment-services/web
mvn exec:java -Dexec.mainClass="edu.umich.umms.assessment.services.clerkship.util.TestDataSetup"

#mvn exec:java -Dexec.mainClass="edu.umich.umms.assessment.services.clerkship.util.ResponseSetStatisticsDataSetup"
