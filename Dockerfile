FROM  openjdk-8-rhel8:latest

USER root
#RUN chmod 777 /usr/lib/jvm/
#ENV         JAVA_HOME         /usr/lib/jvm/java-1.8.0
ENV         GLASSFISH_HOME    /usr/local/glassfish3 \
            PATH=$PATH:/usr/local/glassfish3/bin
#ENV      PATH              $PATH:$JAVA_HOME/bin:$GLASSFISH_HOME/bin

    

# Download and install GlassFish
          
USER root
#RUN          rm -rf /var/lib/apt/lists/*

USER root
RUN         curl -L -o /tmp/glassfish-3.1.zip https://download.oracle.com/glassfish/3.1.2/release/glassfish-3.1.2.zip && \
            unzip /tmp/glassfish-3.1.zip -d /usr/local && \
            # unzip /tmp/glassfish-3.1.zip -d /opt && \
            rm -f /tmp/glassfish-3.1.zip

# Ports being exposed
EXPOSE 4848 8080 8181
WORKDIR /usr/local/glassfish3

#chmod  777 /opt/glassfish3 && 
RUN chmod  777  /usr/local/glassfish3

WORKDIR /usr/local/glassfish3

# Copy in and set the entrypoint
COPY docker-entrypoint.sh $GLASSFISH_HOME/
USER root
RUN chmod 777 /usr/local/glassfish3/docker-entrypoint.sh
RUN chgrp -R 0 /usr/local/glassfish3 && \
    chmod -R g=u /usr/local/glassfish3
    
    RUN chmod g=u /etc/passwd

#RUN groupadd glassfish_grp && \
#useradd --system glassfish && \
#usermod -G glassfish_grp glassfish && \ 
#chown -R glassfish:glassfish_grp ${GLASSFISH_HOME} && \ 
#chmod -R 777 ${GLASSFISH_HOME}
#USER glassfish
#RUN chmod g=u /etc/passwd
ENTRYPOINT ["/usr/local/glassfish3/docker-entrypoint.sh"]
USER 1001 

# verbose causes the process to remain in the foreground so that docker can track it
CMD ["asadmin", "start-domain", "--verbose"]


LABEL maintainer="King Chung Huang <kchuang@ucalgary.ca>" \
      org.label-schema.schema-version="1.0" \
      org.label-schema.name="GlassFish" \
      org.label-schema.version="3.1.2.2" \
      org.label-schema.url="https://glassfish.java.net" \
      org.label-schema.vcs-url="https://github.com/Eliseo247/infosweb-glassfish3.1.git"
