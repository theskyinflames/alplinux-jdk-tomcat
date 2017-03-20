#!/bin/bash

# Start tomcat
cd /opt/tomcat
ls -lart
su -c ./bin/startup.sh tomcat

# Keeping the container running
while :; do echo ""; sleep 30; done