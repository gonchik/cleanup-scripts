#!/usr/bin/env bash

# Main variables
NEW_RELEASE=atlassian-crowd-7.1.0
OLD_RELEASE=atlassian-crowd-6.0.0
APP_USER=crowd
APP_HOME=/opt/atlassian/crowd/crowd_home
APP_INSTALL_DIR=/opt/atlassian/crowd

cd ${APP_INSTALL_DIR} || exit
# wget -c https://download.oracle.com/java/21/latest/jdk-21_linux-x64_bin.tar.gz
wget -c https://www.atlassian.com/software/crowd/downloads/binary/atlassian-crowd-7.1.0.tar.gz
tar -xzvf atlassian-crowd-7.1.0.tar.gz

echo 'Rewrite setenv.sh file'
yes | cp {${OLD_RELEASE},${NEW_RELEASE}}/apache-tomcat/bin/setenv.sh
echo 'Rewrite server.xml'
yes | cp {${OLD_RELEASE},${NEW_RELEASE}}/apache-tomcat/conf/server.xml
echo "Rewrite home location properties"
yes | cp {${OLD_RELEASE},${NEW_RELEASE}}/crowd-webapp/WEB-INF/classes/crowd-init.properties

chown -R ${APP_USER}: ${NEW_RELEASE}/
systemctl stop crowd
unlink current
ln -s ${NEW_RELEASE} current

echo "Clean old logs from old installation"
rm -f ${APP_HOME}/analytics-logs/*
rm -rf ${APP_HOME}/caches/*
# rm -f ${APP_HOME}/logs/*
rm -f  ${OLD_RELEASE}/apache-tomcat/logs/*
rm -rf ${OLD_RELEASE}/apache-tomcat/temp/*
rm -rf ${OLD_RELEASE}/apache-tomcat/work/*

systemctl restart crowd

# Checking logs
# tail -f ${APP_INSTALL_DIR}/${NEW_RELEASE}/apache-tomcat/logs/catalina.out
# tail -f ${APP_HOME}/logs/atlassian-crowd.log
