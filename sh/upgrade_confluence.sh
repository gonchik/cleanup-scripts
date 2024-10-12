#!/usr/bin/env bash

cd /opt/atlassian/confluence || exit

wget -c https://www.atlassian.com/software/confluence/downloads/binary/atlassian-confluence-8.5.16.tar.gz
tar -xzvf atlassian-confluence-8.5.16.tar.gz

# Main variables
NEW_RELEASE=atlassian-confluence-8.5.16
OLD_RELEASE=atlassian-confluence-8.5.7
APP_USER=confluence
APP_HOME=/var/atlassian/application-data/confluence/


echo "Copying JRE"
if [ -d "${OLD_RELEASE}/jre" ]; then
  cp -rf {${OLD_RELEASE},${NEW_RELEASE}}/jre
else
  echo "The directory ${OLD_RELEASE}/jre does not exist."
fi

echo 'Rewrite setenv.sh file'
yes | cp {${OLD_RELEASE},${NEW_RELEASE}}/bin/setenv.sh
echo 'Rewrite server.xml'
yes | cp {${OLD_RELEASE},${NEW_RELEASE}}/conf/server.xml
echo "Rewrite home location properties"
yes | cp {${OLD_RELEASE},${NEW_RELEASE}}/confluence/WEB-INF/classes/confluence-init.properties

chown -R ${APP_USER}: ${NEW_RELEASE}/

systemctl stop confluence
unlink current
ln -s ${NEW_RELEASE} current

echo "Cleaning plugin cache"
rm -rf ${APP_HOME}/plugins-osgi-cache/*
rm -rf ${APP_HOME}/plugins-cache/*
rm -f ${APP_HOME}/lock

echo "Clean old logs from old installation"
rm -f ${OLD_RELEASE}/logs/*
rm -rf ${OLD_RELEASE}/temp/*

systemctl restart confluence

# Checking logs
# tail -f ${NEW_RELEASE}/logs/catalina.out
# tail -f ${APP_HOME}/logs/atlassian-confluence.log
