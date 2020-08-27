#!/bin/sh
#############################################################################################################
#Copiar los archivos desde el backup si no existen en la ruta /opt/glassfish4/, previamente se hizo un backup cp -Rf * /home/digitalizados/backupbinarios-latest

#if [ ! -f /opt/glassfish4/bin/asadmin.bat]; then
 cp -Rf /home/digitalizados/backupbinarios-latest/* /opt/glassfish4/ 
 # fi
  


