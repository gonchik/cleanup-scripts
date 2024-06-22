#!/usr/bin/env bash

cd /opt/atlassian/jira

wget -c https://www.atlassian.com/software/jira/downloads/binary/atlassian-jira-software-9.4.22.tar.gz
tar -xzvf atlassian-jira-software-9.4.22.tar.gz

# Main variables
NEW_RELEASE=atlassian-jira-software-9.4.22-standalone
OLD_RELEASE=atlassian-jira-software-9.4.15-standalone
JIRA_USER=jira
JIRA_HOME=/var/atlassian/application-data/jira


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

chown -R ${JIRA_USER}: ${NEW_RELEASE}/

systemctl stop jira
unlink current
ln -s ${NEW_RELEASE} current

echo "Cleaning plugin cache"
rm -rf ${JIRA_HOME}/plugins/.bundled-plugins
rm -rf ${JIRA_HOME}/plugins/.osgi-plugins

echo "Clean old logs from old installation"
rm -f ${OLD_RELEASE}/logs/*
rm -rf ${OLD_RELEASE}/temp/*


# extra step if you have JSM and Software on the same installation
# https://confluence.atlassian.com/adminjiraserver/upgrading-jira-data-center-with-zero-downtime-938846953.html
#
# mkdir jsm
# cd jsm
# wget -c https://marketplace.atlassian.com/download/apps/1213632/version/1050040022
# unzip 1050040022
#
# cp *.jar dependencies/*.jar ${JIRA_HOME}/sharedhome/plugins/installed-plugins/
# cd ..
# rm -rf jsm/


systemctl restart jira

# Checking logs
# tail -f ${NEW_RELEASE}/logs/catalina.out
# tail -f ${JIRA_HOME}/log/atlassian-jira.log
