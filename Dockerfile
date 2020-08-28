FROM        openjdk-8-rhel8:latest

USER root
RUN chmod 777 /usr/lib/jvm/
ENV JAVA_HOME /usr/lib/jvm/java-1.8.0
ENV GLASSFISH_HOME /opt/glassfish4
ENV PATH  $PATH:$JAVA_HOME/bin:$GLASSFISH_HOME/bin

USER root
RUN          rm -rf /var/lib/apt/lists/*

# Download and install GlassFish
USER root
######################################Descargar los binarios##################################3#
 RUN         curl -L -o /tmp/glassfish-4.0.zip https://download.oracle.com/glassfish/4.0/release/glassfish-4.0.zip && \
           unzip /tmp/glassfish-4.0.zip -d /opt && \
           rm -f /tmp/glassfish-4.0.zip
   
   # Remove Windows .bat and .exe files to save space
   # cd $GLASSFISH_HOME && \
   # find . -name '*.bat' -delete && \
   # find . -name '*.exe' -delete

# Ports being exposed
EXPOSE 4848 8080 8181
VOLUME /home/digitalizados
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

LABEL maintainer="Josue Ramirez <josue.ramirez@ansp.edu.sv>" \
      org.label-schema.schema-version="1.0" \
      org.label-schema.name="GlassFish" \
      org.label-schema.version="4.0" \
      org.label-schema.url="https://glassfish.java.net" \
      org.label-schema.vcs-url="https://github.com/Eliseo247/infosweb-glassfish4.1.git"
LABEL
      io.k8s.description="Glassfish" \
      io.k8s.display-name="Glassfish " \
      io.openshift.min-memory="8Gi" \
      io.openshift.min-cpu="8" \
      io.openshift.non-scalable="false"
