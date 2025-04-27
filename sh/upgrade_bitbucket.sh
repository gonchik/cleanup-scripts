#!/usr/bin/env bash

# Main variables
NEW_RELEASE=atlassian-bitbucket-9.4.5
OLD_RELEASE=atlassian-bitbucket-7.17.9
APP_USER=atlbitbucket
APP_INSTALL_DIR=/opt/atlassian/bitbucket
APP_HOME=/var/atlassian/application-data/bitbucket


cd ${APP_INSTALL_DIR} || exit
echo "Downloading installation from https://www.atlassian.com/software/bitbucket/download-archives"
wget -c https://www.atlassian.com/software/stash/downloads/binary/atlassian-bitbucket-9.4.5.tar.gz
tar -xzvf atlassian-bitbucket-9.4.5.tar.gz
echo 'Download jdk 17 if you need https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.15%2B6/OpenJDK17U-jdk_x64_linux_hotspot_17.0.15_6.tar.gz'


echo "Copying JRE location"
cp -rf {${OLD_RELEASE},${NEW_RELEASE}}/bin/set-jre-home.sh
echo "Copy customized Bitbucket Home location"
cp -rf {${OLD_RELEASE},${NEW_RELEASE}}/bin/set-bitbucket-home.sh
echo 'Rewrite setenv.sh file'
yes | cp {${OLD_RELEASE},${NEW_RELEASE}}/bin/_start-webapp.sh


chown -R ${APP_USER}: ${NEW_RELEASE}/

systemctl stop bitbucket
unlink current
ln -s ${NEW_RELEASE} current

echo "Cleaning lock files"
rm -f ${APP_HOME}/bitbucket.lock
rm -f ${APP_HOME}/shared/.lock
rm -f ${APP_HOME}/plugins/.osgi-plugins

systemctl restart bitbucket

# Checking logs
#  tail -f ${APP_HOME}/logs/atlassian-bamboo.log
