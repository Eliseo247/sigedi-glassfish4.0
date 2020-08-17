FROM  openjdk-8-rhel8:latest
#USER root
#RUN chmod 777 /usr/lib/jvm/
#ENV JAVA_HOME /usr/lib/jvm/java-1.8.0
ENV GLASSFISH_HOME /usr/local/glassfish3
#ENV PATH $PATH:$JAVA_HOME/bin:$GLASSFISH_HOME/bin
ENV PATH=$PATH:/usr/local/glassfish3/bin

USER root
RUN  rm -rf /var/lib/apt/lists/*

USER root
RUN curl -L -o /tmp/glassfish-3.1.zip https://download.oracle.com/glassfish/3.1.2/release/glassfish-3.1.2.zip && \
    unzip /tmp/glassfish-3.1.zip -d /usr/local && \
    unzip /tmp/glassfish-3.1.zip -d /opt && \
  
  
   rm -f $GLASSFISH_PKG && \
    \
    # Remove Windows .bat and .exe files to save space
    cd $GLASSFISH_HOME && \
    find . -name '*.bat' -delete && \
    find . -name '*.exe' -delete


VOLUME /usr/local/glassfish3
VOLUME /home/Digitalizados
# Ports being exposed
EXPOSE 4848 8080 8181

WORKDIR /usr/local/glassfish3

# Copy in and set the entrypoint
COPY docker-entrypoint.sh $GLASSFISH_HOME/
RUN chmod 777 /usr/local/glassfish3/docker-entrypoint.sh
RUN chgrp -R 0 /usr/local/glassfish3 && \
    chmod -R g=u /usr/local/glassfish3
    
RUN chmod g=u /etc/passwd
  
ENTRYPOINT ["/usr/local/glassfish4/docker-entrypoint.sh"]
USER 1001
# Start the GlassFish domain
CMD ["asadmin", "start-domain", "--verbose"]

LABEL maintainer="King Chung Huang <josue.ramriez@ansp.edu.sv>" \
      org.label-schema.schema-version="1.0" \
      org.label-schema.name="GlassFish" \
      org.label-schema.version="3.1" \
      org.label-schema.url="https://glassfish.java.net" \
      org.label-schema.vcs-url="https://github.com/Eliseo247/glassfish41.git"
