#GlassFish Server Open Source Edition 3.1.2 (build 23)
#-----------------------------RECORDAR CREAR LAS VARIABLES DE ENTORNO--------------
#AS_ADMIN_PASSWORD  Gla$fish2020
#AS_ADMIN_ENABLE_SECURE
#100GB /home/Digitalizados
#10GB /usr/local/glassfish3



#FROM openjdk:7u151-jdk-alpine
  
FROM openjdk-8-rhel8:latest


# Set environment variables

USER root
RUN chmod 777 /usr/lib/jvm/
ENV         JAVA_HOME         /usr/lib/jvm/java-1.8.0
ENV GLASSFISH_PKG=/tmp/glassfish-3.1.2.2.zip \
    GLASSFISH_URL=http://download.oracle.com/glassfish/3.1.2.2/release/glassfish-3.1.2.2.zip \
    GLASSFISH_HOME=/usr/local/glassfish3 \
    MD5=ae8e17e9dcc80117cb4b3928430
 ENV PATH  $PATH:$JAVA_HOME/bin:$GLASSFISH_HOME/bin
    #$PATH:$JAVA_HOME/bin:$GLASSFISH_HOME/bin
    #PATH=$PATH:/usr/local/glassfish3/bin

# Download and install GlassFish
RUN         curl -L -o /tmp/glassfish-3.1.zip https://download.oracle.com/glassfish/3.1.2/release/glassfish-3.1.2.zip && \
            unzip /tmp/glassfish-3.1.zip -d /usr/local && \
            unzip /tmp/glassfish-3.1.zip -d /opt && \
            rm -f /tmp/glassfish-3.1.zip
            
    # Remove Windows .bat and .exe files to save space
    #cd $GLASSFISH_HOME && \
    #find . -name '*.bat' -delete && \
    #find . -name '*.exe' -delete

# Ports being exposed
EXPOSE 4848 8080 8181

WORKDIR /usr/local/glassfish3

# Copy in and set the entrypoint
COPY docker-entrypoint.sh $GLASSFISH_HOME/
USER root
RUN chmod 777 /usr/local/glassfish3/docker-entrypoint.sh
RUN chgrp -R 0 /usr/local/glassfish3 && \
    chmod -R g=u /usr/local/glassfish3
RUN chmod 777 -R /usr/local/glassfish3
    
    RUN chmod g=u /etc/passwd
  
ENTRYPOINT ["/usr/local/glassfish3/docker-entrypoint.sh"]
USER 1001
# Start the GlassFish domain
CMD         asadmin start-domain --verbose

LABEL maintainer="King Chung Huang <kchuang@ucalgary.ca>" \
      org.label-schema.schema-version="1.0" \
      org.label-schema.name="GlassFish" \
      org.label-schema.version="3.1.2.2" \
      org.label-schema.url="https://glassfish.java.net" \
      org.label-schema.vcs-url="https://github.com/ucalgary/docker-glassfish"
