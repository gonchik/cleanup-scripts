#!/usr/bin/env bash

# Main variables
NEW_RELEASE=atlassian-bamboo-10.2.3
OLD_RELEASE=atlassian-bamboo-9.6.0
APP_USER=bamboo
APP_INSTALL_DIR=/opt/atlassian/bamboo
APP_HOME=/var/atlassian/application-data/bamboo


cd ${APP_INSTALL_DIR} || exit
echo "Downloading installation from https://www.atlassian.com/software/bamboo/download-archives"
wget -c https://www.atlassian.com/software/bamboo/downloads/binary/atlassian-bamboo-10.2.3.tar.gz
tar -xzvf atlassian-bamboo-10.2.3.tar.gz
echo 'Download jdk 17 if you need https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.15%2B6/OpenJDK17U-jdk_x64_linux_hotspot_17.0.15_6.tar.gz'


echo "Copying JRE"
cp -rf {${OLD_RELEASE},${NEW_RELEASE}}/jre
echo 'Rewrite setenv.sh file'
yes | cp {${OLD_RELEASE},${NEW_RELEASE}}/bin/setenv.sh
echo 'Rewrite server.xml'
yes | cp {${OLD_RELEASE},${NEW_RELEASE}}/conf/server.xml

echo "Rewrite home location properties"
yes | cp {${OLD_RELEASE},${NEW_RELEASE}}/atlassian-bamboo/WEB-INF/classes/bamboo-init.properties


chown -R ${APP_USER}: ${NEW_RELEASE}/

systemctl stop bamboo
unlink current
ln -s ${NEW_RELEASE} current

echo "Cleaning lock files"
rm -rf ${APP_HOME}/bamboo.lock
echo "Cleaning old logs from old installation"
rm -f ${OLD_RELEASE}/logs/*
rm -rf ${OLD_RELEASE}/temp/*

echo "Cleaning old caches"
rm -rf ${APP_HOME}/caches/*

systemctl restart bamboo

# Checking logs
# tail -f ${APP_INSTALL_DIR}/${NEW_RELEASE}/logs/catalina.out
#  tail -f ${APP_HOME}/logs/atlassian-bamboo.log
