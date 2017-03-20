FROM ubuntu:16.04

#
# Insatll tomcat https://www.digitalocean.com/community/tutorials/how-to-install-apache-tomcat-8-on-ubuntu-16-04
#

ENV TOMCAT_ADMIN_USER admin
ENV TOMCAT_ADMIN_PASSWORD admin

# Upgrade OS image
RUN apt-get update;apt-get upgrade -y

# Installing java 8 JDK
## Adding the repository
RUN apt-get -y install software-properties-common
RUN add-apt-repository ppa:webupd8team/java
RUN apt-get update
## Enabling silent install
RUN echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections
RUN echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections
## Installing Oracle JDK 8
RUN apt-get -y install oracle-java8-installer
RUN update-java-alternatives -s java-8-oracle
RUN apt-get install -y oracle-java8-set-default

# Installing maven
RUN apt-get -y install maven curl

# Installing tomcat 
RUN mkdir -p /opt/tomcat; \
    groupadd tomcat; \
    useradd -s /bin/false -g tomcat -d /opt/tomcat tomcat;

COPY apache-tomcat-8.5.12.tar.gz /

RUN ls -la /; tar -xvzf /apache-tomcat-8.5.12.tar.gz -C /opt/tomcat --strip-components=1

RUN cd /opt/tomcat; \
    ls -la ; ls -la ./bin/ \
    chgrp -R tomcat /opt/tomcat; \
    chmod -R g+r conf; \
    chmod g+x conf; \
    chown -R tomcat webapps/ work/ temp/ logs/ ;
    
## Set tomcat admin
COPY tomcat-users.xml /opt/tomcat/conf/
RUN sed -i "s/TOMCAT_ADMIN_USER/${TOMCAT_ADMIN_USER}/g" /opt/tomcat/conf/tomcat-users.xml
RUN sed -i "s/TOMCAT_ADMIN_PASSWORD/${TOMCAT_ADMIN_PASSWORD}/g" /opt/tomcat/conf/tomcat-users.xml

# Installing Git tool
RUN echo "Installing Git tools";apt-get -y install git-core build-essential

ADD run.sh /

CMD /run.sh