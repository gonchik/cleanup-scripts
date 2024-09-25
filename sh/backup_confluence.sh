#!/usr/bin/env bash
echo "That's used only for schematic backup for creating test env"
echo "Just query to make a copy faster as possible"
# just one time script to share
CONFLUENCE_HOME="/var/atlassian/application-data/confluence"
CONFLUENCE_INSTALL="/opt/atlassian/confluence/"
cd ${CONFLUENCE_INSTALL}
tar --exclude="logs" --exclude="temp" --exclude="work" -czvf confluence_install.tgz ${CONFLUENCE_INSTALL}
CONFLUENCE_HOME="/var/atlassian/application-data/confluence"
cd ${CONFLUENCE_HOME}
tar -czvf confluence_home.tgz --exclude "shared-home" --exclude "logs" --exclude="analytics-logs" --exclude="temp" --exclude="webresource-temp" --exclude="backups" --exclude="journal/" --exclude="index" --exclude="viewfile" --exclude="sandbox" --exclude="plugins-cache" --exclude="plugins-osgi-cache" --exclude="thumbnails" --exclude="imgEffects" --exclude="log" --exclude="restore" --exclude="recovery" --exclude="bundled-plugins" --exclude="plugins-temp" ${CONFLUENCE_HOME}

echo "DB activity"
su postges
pg_dump -d confluencedb -f backup_file.sql
