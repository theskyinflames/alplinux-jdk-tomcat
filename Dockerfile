FROM anapsix/alpine-java:8_jdk_unlimited

RUN apk update

# Installing maven
RUN mkdir -p /opt/maven
ADD apache-maven-3.3.9-bin.tar.gz /opt/maven/
RUN chmod -R 777 /opt/maven;sync
RUN ls -lart /opt/maven/apache-maven-3.3.9
ENV MAVEN_HOME=/opt/maven/apache-maven-3.3.9
ENV PATH=$PATH:/opt/maven/apache-maven-3.3.9/bin

# Install tomcat
RUN mkdir -p /opt/tomcat; \
    addgroup tomcat; \
    adduser -G tomcat -h /opt/tomcat -D tomcat;

COPY apache-tomcat-8.5.12.tar.gz /

RUN ls -la /; tar -xvzf /apache-tomcat-8.5.12.tar.gz -C /opt/tomcat

RUN cd /opt/tomcat/apache-tomcat-8.5.12; \
    mv * ..; \
    cd ..; \
    rm -rf  apache-tomcat-*; \
    pwd ; \
    ls -la ; \
    chgrp -R tomcat /opt/tomcat; \
    chmod -R g+r conf; \
    chmod g+x conf; \
    chown -R tomcat webapps/ work/ temp/ logs/


# Installing Git tool
RUN echo "Installing Git tools";apk add git

ADD run.sh /

CMD /run.sh
