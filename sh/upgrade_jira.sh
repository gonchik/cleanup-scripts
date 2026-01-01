#!/usr/bin/env bash

# Main variables
NEW_RELEASE=atlassian-jira-software-10.3.15-standalone
OLD_RELEASE=atlassian-jira-software-9.4.22-standalone
APP_USER=jira
APP_HOME=/var/atlassian/application-data/jira
APP_INSTALL_DIR=/opt/atlassian/jira

cd ${APP_INSTALL_DIR} || exit

wget -c https://www.atlassian.com/software/jira/downloads/binary/atlassian-jira-software-10.3.15.tar.gz
tar -xzvf atlassian-jira-software-10.3.15.tar.gz




echo "Copying JRE"
cp -rf {${OLD_RELEASE},${NEW_RELEASE}}/jre
echo 'Rewrite setenv.sh file'
yes | cp {${OLD_RELEASE},${NEW_RELEASE}}/bin/setenv.sh
echo 'Rewrite server.xml'
yes | cp {${OLD_RELEASE},${NEW_RELEASE}}/conf/server.xml
echo "Rewrite home location properties"
yes | cp {${OLD_RELEASE},${NEW_RELEASE}}/atlassian-jira/WEB-INF/classes/jira-application.properties

echo "Copying drivers"
yes | cp {${OLD_RELEASE},${NEW_RELEASE}}/lib/mysql-connector-j-8.0.31.jar
yes | cp {${OLD_RELEASE},${NEW_RELEASE}}/lib/vertica-jdbc-11.0.1-0.jar

echo "custom images"
mkdir -p ${NEW_RELEASE}/atlassian-jira/images/custom_images/
cp {${OLD_RELEASE},${NEW_RELEASE}}/atlassian-jira/images/custom_images/flow.png
cp {${OLD_RELEASE},${NEW_RELEASE}}/atlassian-jira/images/icons/statuses/flow.png
cp {${OLD_RELEASE},${NEW_RELEASE}}/atlassian-jira/images/icons/flow.png

echo "Custom mail logo"
cp {${OLD_RELEASE},${NEW_RELEASE}}/atlassian-jira/images/mail/logo.png

echo "Custom language pack"
yes | cp {${OLD_RELEASE},${NEW_RELEASE}}/atlassian-jira/WEB-INF/atlassian-bundled-plugins/jira-core-language-pack-ru_RU-10.0.0.v20240619070432.jar
echo "Removed cached backup files"
rm -f ${APP_HOME}/customisations-backup/atlassian-jira/WEB-INF/atlassian-bundled-plugins/jira-core-language-pack-ru_RU-9.8.0.v20230228123141.jar
rm -f ${APP_HOME}/customisations/atlassian-jira/WEB-INF/atlassian-bundled-plugins/jira-core-language-pack-ru_RU-9.8.0.v20230228123141.jar

chown -R ${APP_USER}: ${NEW_RELEASE}/

systemctl stop jira
unlink current
ln -s ${NEW_RELEASE} current

echo "Cleaning plugin cache"
rm -rf ${APP_HOME}/plugins/.bundled-plugins
rm -rf ${APP_HOME}/plugins/.osgi-plugins
rm -f  ${APP_HOME}/.jira.home.lock
echo "Clean old logs from old installation"
rm -f  ${OLD_RELEASE}/logs/*
rm -rf ${OLD_RELEASE}/temp/*


# extra step if you have JSM and Software on the same installation
# https://confluence.atlassian.com/adminjiraserver/upgrading-jira-data-center-with-zero-downtime-938846953.html
# https://marketplace.atlassian.com/apps/1213632/jira-service-desk/version-history?includeHiddenVersions=1
# @todo make function
# mkdir jsm
# cd jsm
# wget -c https://marketplace.atlassian.com/download/apps/1213632/version/1050170005
# unzip 1050170005
#
# cp *.jar dependencies/*.jar ${APP_HOME}/sharedhome/plugins/installed-plugins/
# cd ..
# rm -rf jsm/


systemctl restart jira

# Checking logs
# tail -f ${NEW_RELEASE}/logs/catalina.out
# tail -f ${APP_HOME}/log/atlassian-jira.log
