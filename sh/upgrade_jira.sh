#!/usr/bin/env bash

cd /opt/atlassian/

wget -c https://www.atlassian.com/software/jira/downloads/binary/atlassian-jira-software-9.12.5.tar.gz
tar -xzvf atlassian-jira-software-9.12.5.tar.gz

NEW_RELEASE=atlassian-jira-software-9.12.5-standalone
OLD_RELEASE=atlassian-jira-software-9.4.12-standalone

echo "copy jre"
cp -f {${OLD_RELEASE},${NEW_RELEASE}}/jre
echo 'Rewrite setenv.sh file'
yes | cp {${OLD_RELEASE},${NEW_RELEASE}}/bin/setenv.sh
echo 'Rewrite server.xml'
yes | cp {${OLD_RELEASE},${NEW_RELEASE}}/conf/server.xml
echo "Rewrite home location"
cp {current,atlassian-jira-software-8.20.29-standalone}/atlassian-jira/WEB-INF/classes/jira-application.properties

yes | cp {${OLD_RELEASE},${NEW_RELEASE}}/atlassian-jira/WEB-INF/classes/jira-application.properties
echo "Copying drivers"
cp {${OLD_RELEASE},${NEW_RELEASE}}/lib/mysql-connector-j-8.0.31.jar
cp {${OLD_RELEASE},${NEW_RELEASE}}/lib/vertica-jdbc-11.0.1-0.jar

echo "custom images"
mkdir -p ${NEW_RELEASE}/atlassian-jira/images/custom_images/
cp {${OLD_RELEASE},${NEW_RELEASE}}/atlassian-jira/images/custom_images/flow.png
cp {${OLD_RELEASE},${NEW_RELEASE}}/atlassian-jira/images/icons/statuses/flow.png
cp {${OLD_RELEASE},${NEW_RELEASE}}/atlassian-jira/images/icons/flow.png

chown -R jira: ${NEW_RELEASE}/

systemctl stop jira
unlink jira
ln -s ${NEW_RELEASE} jira

echo "Cleaning plugin cache"
JIRA_HOME=/var/atlassian/application-data/jira
rm -rf ${JIRA_HOME}/plugins/.bundled-plugins
rm -rf ${JIRA_HOME}/plugins/.osgi-plugins

systemctl restart jira

# Checking logs
# tail -f /opt/atlassian/jira/logs/catalina.out
# tail -f /var/atlassian/application-data/jira/log/atlassian-jira.log
