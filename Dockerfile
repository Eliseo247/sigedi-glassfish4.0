FROM openjdk-8-rhel8:latest

# Set environment variables
ENV GLASSFISH_PKG=/tmp/glassfish-3.1.2.2.zip \
    GLASSFISH_URL=http://download.oracle.com/glassfish/3.1.2.2/release/glassfish-3.1.2.2.zip \
    GLASSFISH_HOME=/usr/local/glassfish3 \
    MD5=ae8e17e9dcc80117cb4b39284302763f \
    PATH=$PATH:/usr/local/glassfish3/bin

# Download and install GlassFish
RUN wget https://download.oracle.com/glassfish/3.1.2/release/glassfish-3.1.2.zip &&\
         unzip /tmp/glassfish-3.1.2.zip -d /usr/local && \
         rm -f /glassfish-3.1.2.zip
    \
    # Remove Windows .bat and .exe files to save space
   # cd $GLASSFISH_HOME && \
   # find . -name '*.bat' -delete && \
   # find . -name '*.exe' -delete

# Ports being exposed
EXPOSE 4848 8080 8181

WORKDIR /usr/local/glassfish3

# Copy in and set the entrypoint
COPY docker-entrypoint.sh $GLASSFISH_HOME/
USER root
RUN chmod 777 /usr/local/glassfish3/docker-entrypoint.sh
RUN chgrp -R 0 /usr/local/glassfish3 && \
    chmod -R g=u /usr/local/glassfish3
    
    RUN chmod g=u /etc/passwd
  
ENTRYPOINT ["/usr/local/glassfish3/docker-entrypoint.sh"]
USER 1001
# Start the GlassFish domain
CMD ["asadmin", "start-domain", "--verbose"]

LABEL maintainer="King Chung Huang <kchuang@ucalgary.ca>" \
      org.label-schema.schema-version="1.0" \
      org.label-schema.name="GlassFish" \
      org.label-schema.version="3.1.2.2" \
      org.label-schema.url="https://glassfish.java.net" \
      org.label-schema.vcs-url="https://github.com/ucalgary/docker-glassfish"
