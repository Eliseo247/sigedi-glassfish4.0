#!/bin/sh
#############################################################################################################
#Copiar los archivos desde el backup si no existen en la ruta /opt/glassfish4/, previamente se hizo un backup cp -Rf * /home/digitalizados/backupbinarios-latest

#if [ ! -f /opt/glassfish4/bin/asadmin.bat]; then
 cp -Rf /home/digitalizados/backupbinarios-latest/* /opt/glassfish4/ 
 # fi
  

if ! whoami &> /dev/null; then
  if [ -w /etc/passwd ]; then
    echo "${USER_NAME:-default}:x:$(id -u):0:${USER_NAME:-default} user:${HOME}:/sbin/nologin" >> /etc/passwd
  fi
fi


           asadmin start-domain            
           
   


exec "$@"
