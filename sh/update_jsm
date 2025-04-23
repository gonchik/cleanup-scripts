#!/usr/bin/env bash

cd /opt/atlassian/jira || exit

echo 'Get installer from https://www.atlassian.com/software/jira/service-management/download-archives'
echo 'Download jdk 17 if you need https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.15%2B6/OpenJDK17U-jdk_x64_linux_hotspot_17.0.15_6.tar.gz'
curl -LO https://www.atlassian.com/software/jira/downloads/binary/atlassian-servicedesk-5.12.22.tar.gz
tar -xzvf atlassian-servicedesk-5.12.22.tar.gz


# Main variables
NEW_RELEASE=atlassian-jira-servicedesk-5.12.22-standalone
OLD_RELEASE=atlassian-jira-servicedesk-5.4.26-standalone
JIRA_USER=jira
JIRA_HOME=/var/atlassian/jira/


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
yes | cp {${OLD_RELEASE},${NEW_RELEASE}}/atlassian-jira/WEB-INF/atlassian-bundled-plugins/jira-core-language-pack-ru_RU-9.8.0.v20230228123141.jar
echo "Removed cached backup files"
rm -f ${JIRA_HOME}/customisations-backup/atlassian-jira/WEB-INF/atlassian-bundled-plugins/jira-core-language-pack-ru_RU-9.8.0.v20230228123141.jar
rm -f ${JIRA_HOME}/customisations/atlassian-jira/WEB-INF/atlassian-bundled-plugins/jira-core-language-pack-ru_RU-9.8.0.v20230228123141.jar

chown -R ${JIRA_USER}: ${NEW_RELEASE}/

systemctl stop jira
unlink current
ln -s ${NEW_RELEASE} current

echo "Cleaning plugin cache"
rm -rf ${JIRA_HOME}/plugins/.bundled-plugins
rm -rf ${JIRA_HOME}/plugins/.osgi-plugins
rm -f ${JIRA_HOME}/.jira.home.lock
echo "Clean old logs from old installation"
rm -f ${OLD_RELEASE}/logs/*
rm -rf ${OLD_RELEASE}/temp/*


systemctl restart jira

# Checking logs
# tail -f ${NEW_RELEASE}/logs/catalina.out
# tail -f ${JIRA_HOME}/log/atlassian-jira.log
