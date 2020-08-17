FROM openjdk-8-rhel8:latest

# Set environment variables
ENV 
   
    GLASSFISH_HOME=/opt/glassfish4 \
 
    PATH=$PATH:/opt/glassfish4/bin

# Download and install GlassFish
USER root
RUN         curl -L -o /tmp/glassfish-4.1.zip http://download.java.net/glassfish/4.1/release/glassfish-4.1.zip && \
            unzip /tmp/glassfish-4.1.zip -d /usr/local && \
             unzip /tmp/glassfish-4.1.zip -d /opt && \
            rm -f /tmp/glassfish-4.1.zip
    
    # Remove Windows .bat and .exe files to save space
   # cd $GLASSFISH_HOME && \
   # find . -name '*.bat' -delete && \
   # find . -name '*.exe' -delete

# Ports being exposed
EXPOSE 4848 8080 8181

WORKDIR /opt/glassfish4

# Copy in and set the entrypoint
COPY docker-entrypoint.sh $GLASSFISH_HOME/
USER root
RUN chmod 777 /opt/glassfish4/docker-entrypoint.sh
RUN chgrp -R 0 /opt/glassfish4 && \
    chmod -R g=u /opt/glassfish4
    
    RUN chmod g=u /etc/passwd
  
ENTRYPOINT ["/opt/glassfish4/docker-entrypoint.sh"]
USER 1001
# Start the GlassFish domain
CMD ["asadmin", "start-domain", "--verbose"]

LABEL maintainer="King Chung Huang <kchuang@ucalgary.ca>" \
      org.label-schema.schema-version="1.0" \
      org.label-schema.name="GlassFish" \
      org.label-schema.version="3.1.2.2" \
      org.label-schema.url="https://glassfish.java.net" \
      org.label-schema.vcs-url="https://github.com/ucalgary/docker-glassfish"
