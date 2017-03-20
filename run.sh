#!/bin/bash

# Start tomcat
cd /opt/tomcat
ls -lart
./bin/startup.sh

sleep 3

echo "Tomcat started !!!"

tail /opt/logs/catalina.out

# Keeping the container running
while :; do echo ""; sleep 30; done