#! /bin/sh
# ==================================================================
#    ______                           __     ____
#   /_  __/___  ____ ___  _________ _/ /_   ( __ )
#    / / / __ \/ __ `__ \/ ___/ __ `/ __/  / __  |
#   / / / /_/ / / / / / / /__/ /_/ / /_   / /_/ /
#  /_/  \____/_/ /_/ /_/\___/\__,_/\__/   \____/
#
# Multi-instance Apache Tomcat installation with a focus
# on best-practices as defined by Apache, SpringSource, and MuleSoft
# and enterprise use with large-scale deployments.

# Credits:
#       Google -> Couldn't survive without it
#       Stackoverflow.com -> Community support
#       SpringSource -> Specifically best-practices and seminars (Expert Series)

# Based On:
#       http://www.springsource.com/files/uploads/tomcat/tomcatx-performance-tuning.pdf
#       http://www.springsource.com/files/u1/PerformanceTuningApacheTomcat-Part2.pdf
#       http://www.springsource.com/files/uploads/tomcat/tomcatx-large-scale-deployments.pdf

# Created By: Terrance A. Snyder
# URL: http://www.terranceasnyder.com, http://shutupandcode.net

# Best Practice Documentation:
# http://terranceasnyder.com/2011/05/tomcat-best-practices/

# Looking for the latest version?
# github @ https://github.com/terrancesnyder

# ==================================================================

# discourage address map swapping by setting Xms and Xmx to the same value
# http://confluence.atlassian.com/display/DOC/Garbage+Collector+Performance+Issues

export CATALINA_OPTS="$CATALINA_OPTS -Xms64m"
export CATALINA_OPTS="$CATALINA_OPTS -Xmx512m"

# Increase maximum perm size for web base applications to 4x the default amount
# http://wiki.apache.org/tomcat/FAQ/Memory
export CATALINA_OPTS="$CATALINA_OPTS -XX:MaxPermSize=256m"

# Reset the default stack size for threads to a lower value (by 1/10th original)
# By default this can be anywhere between 512k -> 1024k depending on x32 or x64
# bit Java version.
# http://www.springsource.com/files/uploads/tomcat/tomcatx-large-scale-deployments.pdf
# http://www.oracle.com/technetwork/java/hotspotfaq-138619.html
export CATALINA_OPTS="$CATALINA_OPTS -Xss192k"

# Oracle Java as default, uses the serial garbage collector on the
# Full Tenured heap. The Young space is collected in parallel, but the
# Tenured is not. This means that at a time of load if a full collection
# event occurs, since the event is a 'stop-the-world' serial event then
# all application threads other than the garbage collector thread are
# taken off the CPU. This can have severe consequences if requests continue
# to accrue during these 'outage' periods. (specifically webservices, webapps)
# [Also enables adaptive sizing automatically]
export CATALINA_OPTS="$CATALINA_OPTS -XX:+UseParallelGC"

# This is interpreted as a hint to the garbage collector that pause times
# of <nnn> milliseconds or less are desired. The garbage collector will
# adjust the  Java heap size and other garbage collection related parameters
# in an attempt to keep garbage collection pauses shorter than <nnn> milliseconds.
# http://java.sun.com/docs/hotspot/gc5.0/ergo5.html
export CATALINA_OPTS="$CATALINA_OPTS -XX:MaxGCPauseMillis=1500"

# A hint to the virtual machine that it.s desirable that not more than:
# 1 / (1 + GCTimeRation) of the application execution time be spent in
# the garbage collector.
# http://themindstorms.wordpress.com/2009/01/21/advanced-jvm-tuning-for-low-pause/
export CATALINA_OPTS="$CATALINA_OPTS -XX:GCTimeRatio=9"

# The hotspot server JVM has specific code-path optimizations
# which yield an approximate 10% gain over the client version.
export CATALINA_OPTS="$CATALINA_OPTS -server"

# Disable remote (distributed) garbage collection by Java clients
# and remove ability for applications to call explicit GC collection
export CATALINA_OPTS="$CATALINA_OPTS -XX:+DisableExplicitGC"

#added by gears
#add tomcat native
TOMCAT_NATIVE_DIR="/usr/local/opt/tomcat-native/lib/"
if [  -d "${TOMCAT_NATIVE_DIR}" ]; then
 CATALINA_OPTS="$CATALINA_OPTS -Djava.library.path=${TOMCAT_NATIVE_DIR}"
fi
#gears addition is done
# Check for application specific parameters at startup
if [ -r "$CATALINA_BASE/bin/appenv.sh" ]; then
  . "$CATALINA_BASE/bin/appenv.sh"
fi

echo "Using CATALINA_OPTS:"
for arg in $CATALINA_OPTS
do
    echo ">> " $arg
done
echo ""

echo "Using JAVA_OPTS:"
for arg in $JAVA_OPTS
do
    echo ">> " $arg
done
echo "_______________________________________________"
echo ""
#added by gears

#set catalina_pid to help shutdown errant processes
CATALINA_PID=/usr/local/opt/tomcat/libexec/bin/tomcat80.pid
#Server more likely to use this path
#CATALINA_PID=/var/run/tomcat80.pid
