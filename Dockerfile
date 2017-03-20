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

# Insalling tomcat https://www.linode.com/docs/websites/frameworks/apache-tomcat-on-ubuntu-16-04
#RUN apt-get -y install tomcat8 tomcat8-docs tomcat8-examples tomcat8-admin
#ENV JAVA_HOME=/usr/lib/jvm/java-8-oracle

# Installing tomcat https://www.digitalocean.com/community/tutorials/how-to-install-apache-tomcat-8-on-ubuntu-16-04
RUN groupadd tomcat; \
    useradd -s /bin/false -g tomcat -d /opt/tomcat tomcat;

RUN mkdir -p /opt/tomcat8; \
    cd /opt/tomcat8; \
    curl -O http://apache.mirrors.ionfish.org/tomcat/tomcat-8/v8.5.5/bin/apache-tomcat-8.5.5.tar.gz; \
    tar xzvf apache-tomcat-8*tar.gz -C /opt/tomcat --strip-components=1

RUN cd /opt/tomcat8; \
    chgrp -R tomcat /opt/tomcat; \
    chmod -R g+r conf; \
    chmod g+x conf; \
    chown -R tomcat webapps/ work/ temp/ logs/




## Set tomcat admin
RUN ls -la /var/lib/tomcat8
ENV TOMCAT_ADMIN_CONF="<role rolename="manager-gui"/><role rolename="admin-gui"/><user username="$TOMCAT_ADMIN_USER" password="$TOMCAT_ADMIN_PASSWORD" roles="manager-gui,admin-gui"/>";
RUN C=$(echo $TOMCAT_ADMIN_CONF | sed 's/\//\\\//g');sed "/<\/Students>/ s/.*/${C}\n&/" /var/lib/tomcat8/conf/tomcat-users.xml

# Installing Git tool
RUN echo "Installing Git tools";apt-get -y install git-core build-essential

ADD run.sh /

CMD /run.sh