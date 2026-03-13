#!/bin/sh

#Created by @gonchik 2015-04-27
#This is a simple backup script  for backing up jira mysql, jira home & jira current folders.

DATE=`/bin/date '+%Y-%m-%d_%H-%M'`
BDIR=/pub/jira_backup
USR=root
PW=*****
DB=jira_6315
EMAIL_SUBJECT="JIRA Backup Alert"
EMAIL_TO=gonchik.tsymzhitov@example.com
EMAIL_SERVER="mailrelay.example.com"

send_mail(){
/usr/bin/mail -S smtp=$EMAIL_SERVER -s "$EMAIL_SUBJECT" "$EMAIL_TO" < $EMAIL_MESSAGE
}


rm -f ${BDIR}/snapshot_time/*
touch ${BDIR}/snapshot_time/start_`/bin/date '+%Y-%m-%d_%H-%M'`


touch ${BDIR}/snapshot_time/mysqldump_start_`/bin/date '+%Y-%m-%d_%H-%M'`
/usr/bin/mysqldump --single-transaction -u$USR -p$PW $DB | gzip >   ${BDIR}/jira_mysql_dumps/jiraprod-${DATE}.sql.gz
touch ${BDIR}/snapshot_time/mysqldump__finish_`/bin/date '+%Y-%m-%d_%H-%M'`

#sync jirafolder
touch ${BDIR}/snapshot_time/sync_work_dir_start_`/bin/date '+%Y-%m-%d_%H-%M'`
rsync -Pa  --delete --force  --exclude=work/Catalina --exclude=temp --exclude=logs  /jira/jira-6.4.14 ${BDIR}/jiradir/
touch ${BDIR}/snapshot_time/sync_work_dir__finish_`/bin/date '+%Y-%m-%d_%H-%M'`


rsync -Pa --delete --force --exclude=import --exclude=plugins/.bundled-plugins --exclude=plugins/.osgi-plugins/ --exclude=log  --exclude=tmp /jira/home ${BDIR}/jiradir/

touch ${BDIR}/snapshot_time/finish_`/bin/date '+%Y-%m-%d_%H-%M'`


ls -l  ${BDIR}/snapshot_time/ | awk  '{print $9 "\t\t" $8;}' > ${BDIR}/snapshot_time/backup.log
EMAIL_MESSAGE=${BDIR}/snapshot_time/backup.log

send_mail

#Delete mysql dumps older than 60 days.
#Volume is protected by snapshots aswell
find /pub/jira_backup/jira_mysql_dumps/* -mtime +60 -delete


#https://advantage.ibm.com/2015/09/22/lightweight-java-servers-and-developer-view-on-the-app-server-update/
