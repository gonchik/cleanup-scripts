#!/bin/bash -eux

# Function to detect the operating system
get_os() {
    if [[ -e /etc/debian_version ]]; then
        echo "debian"
    elif [[ -e /etc/redhat-release ]]; then
        echo "redhat"
    else
        echo "unsupported"
    fi
}

# Function to clean the package cache on Debian-based systems
clean_deb_based_packages() {
    echo "Cleaning package cache on Debian-based system..."
    # Cleanup of OS
    # Based on the: https://wiki.debian.org/ReduceDebian
    # clean debian based cache
    # apt-cache clean
    # Remove apt / apt-get files
    sudo apt clean
    sudo apt -s clean
    sudo apt clean all
    sudo apt autoremove
    sudo apt-get clean
    sudo apt-get -s clean
    sudo apt-get clean all
    sudo apt-get autoclean
}

# Function to clean the package cache on RedHat-based systems
clean_rpm_based_packages() {
    if rpm -q yum-utils > /dev/null; then
      echo "Package yum-utils already installed. Good."
    else
      echo "Going to install yum-utils..."
      yum -y install yum-utils
    fi
    echo "Cleaning yum caches..."
    yum clean all
    rm -rf /var/cache/yum
    rm -rf /var/tmp/yum-*

    echo "Check existing orphan packages"
    package-cleanup --quiet --leaves
    # if it's ok, we can clean orphan packages
    # package-cleanup --quiet --leaves | xargs yum remove -y

    echo "Removing old Linux kernels..."
    package-cleanup -y --oldkernels --count=1
}

# Function to clean  on MacOS-based systems
clean_macos() {
  find . -name ".DS_Store" -delete
}

# Main script
# Detect the OS
os=$(get_os)
case $os in
    "debian")
        clean_deb_based_packages
        ;;
    "redhat")
        clean_rpm_based_packages
        ;;
    *)
        echo "Unsupported operating system."
        exit 1
        ;;
esac


echo 'Log cleanup is started'
echo 'Trimming .log files larger than 50M...'
find /var/log -name "*.log" \( \( -size +50M -mtime +7 \) -o -mtime +30 \) -exec truncate {} --size 0 \;

echo 'Remove packed gzip files in /var/log'
find /var/log -type f -name '*.gz' -delete

echo 'Remove rotated logs in /var/log'
find /var/log/ -type f -name '*.log.*'  -delete

echo 'Cleanup messages files '
find /var/log/ -type f -name 'messages-*' -delete

find /var/log/ -type f -name 'secure-*' -delete

find /var/log/ -type f -name 'spooler-*' -delete
find /var/log/ -type f -name 'hawkey.log-*' -delete
find /var/log/ -type f -name 'cron-*' -delete
find /var/log/ -type f -name 'maillog-*' -delete
find /var/log/ -type f -name 'wtmp-*' -delete
find /var/log/ -type f -name 'btmp-*' -delete
echo 'Remove Boot log info'
find /var/log/ -type f -name 'boot.log-*' -delete
find /var/log/ -type f -name 'yum.log-*' -delete
echo 'VMWARE related logs'
find /var/log/ -type f -name 'vmware-vmsvc-root.*.log' -delete
find /var/log/ -type f -name 'vmware-network.*.log' -delete
find /var/log/ -type f -name 'vmware-vmsvc.*.log' -delete
find /var/log -type f -name '*.[0-9]' -delete


echo 'Remove rotated logs in /var/log of VMware network'
find /var/log/ -type f -name 'vmware-network.*.log' -delete

echo "Removing WP-CLI caches..."
rm -rf /root/.wp-cli/cache/*
rm -rf /home/*/.wp-cli/cache/*

echo "Removing Composer caches..."
rm -rf /root/.composer/cache
rm -rf /home/*/.composer/cache

echo "Removing core dumps..."
find -regex ".*/core\.[0-9]+$" -delete

echo "Removing cPanel error log files..."
find /home/*/public_html/ -name error_log -delete

echo "Removing Node.JS caches on root level ..."
rm -rf /root/.npm  /root/.node-gyp /tmp/npm-*

echo 'Removing mock caches...'
rm -rf /var/cache/mock/* /var/lib/mock/*

echo 'Removing root caches...'
rm -rf /root/.cache/*

echo 'Clean journalctl'
echo 'Set the Vacuum time 2 days and 50M'
journalctl --vacuum-time=2d
journalctl --vacuum-size=50M

echo 'Clean dmesg messages'
dmesg -c

echo "==> Cleaning up tmp"
rm -rf /tmp/*

echo " Remove Old Log Files"
sudo rm -f /var/log/*gz
echo "cleanup emails"
echo > /var/mail/root
rm -rf /var/cache
rm -rf /home/*/.cache/
rm -rf /root/.cache

echo "Remove Thumbnail Cache"
rm -rf ~/.cache/thumbnails/*
echo "All Done!"



atlassian_jira_cleanup() {
   # check folder exists for Atlassian

  echo 'Clean Jira logs and temp files'
  JIRA_HOME=/var/atlassian/application-data/jira
  JIRA_INSTALL=/opt/atlassian/jira/current
  echo "Reviewing the ${JIRA_HOME}"
  find ${JIRA_HOME}/log -type f -name '*.log.*' -delete
  rm -f ${JIRA_HOME}/log/atlassian-jira.log.*
  rm -f ${JIRA_HOME}/log/atlassian-servicedesk.log.*
  rm -f ${JIRA_HOME}/log/insight_automation.log.*
  rm -f ${JIRA_HOME}/log/insight_import.log.*
  rm -f ${JIRA_HOME}/log/atlassian-jira-perf.log.*
  rm -f ${JIRA_HOME}/log/atlassian-jira-slow-queries.log.*
  rm -f ${JIRA_HOME}/log/atlassian-jira-app-monitoring.log.*
  rm -f ${JIRA_HOME}/log/insight_audit.log.*
  rm -f ${JIRA_HOME}/log/atlassian-jira-security.log.*
  rm -f ${JIRA_HOME}/log/atlassian-jira-ipd-monitoring.log.*
  rm -f ${JIRA_HOME}/log/atlassian-jira-incoming-mail.log.*
  rm -f ${JIRA_HOME}/log/atlassian-jira-outgoing-mail.log.*
  rm -f ${JIRA_HOME}/log/atlassian-jira-sql.log.*
  rm -f ${JIRA_HOME}/log/atlassian-jira-slow-querydsl-queries.log.*
  rm -f ${JIRA_HOME}/log/atlassian-jira-xsrf.log.*
  rm -f ${JIRA_HOME}/log/atlassian-jira-http-access.log.*
  rm -f ${JIRA_HOME}/log/insight_objectschema_export.log.*
  rm -f ${JIRA_HOME}/log/jira-diagnostics.log.*
  find ${JIRA_HOME}/log/nfj-jira-* -type f -mtime +2 -delete
  rm -f ${JIRA_HOME}/log/jfr/*
  rm -f ${JIRA_HOME}/sharedhome/analytics-logs/*
  find ${JIRA_HOME}/sharedhome/log -type f -name '*.log.*' -delete
  find ${JIRA_HOME}/tmp -mtime +1 -type f -delete
  echo  'Cleaning tmp attachments based on the https://jira.atlassian.com/browse/JRASERVER-71824'
  find ${JIRA_HOME}/caches/tmp_attachments -mtime +1 -type f -delete
  find ${JIRA_HOME}/caches/indexesV2/snapshots -mtime +1 -type f -delete
  echo "Reviewing the ${JIRA_INSTALL}"
  find ${JIRA_INSTALL}/temp -mtime +1 -type f -delete
  find ${JIRA_INSTALL}/logs/access_log.* -type f -mtime +1 -delete
  rm -f ${JIRA_INSTALL}/logs/atlassian-jira-gc-*log.*
  rm -f ${JIRA_INSTALL}/logs/catalina.*.log
}

atlassian_confluence_cleanup() {
  # check folder exists for Atlassian
  echo 'Clean Confluence logs and temp files'
  CONF_HOME=/var/atlassian/application-data/confluence
  CONF_INSTALL=/opt/atlassian/confluence/current
  rm -f ${CONF_HOME}/logs/atlassian-confluence.log.*
  rm -f ${CONF_HOME}/logs/atlassian-synchrony.log.*
  rm -f ${CONF_HOME}/logs/atlassian-confluence-sql.log.*
  rm -f ${CONF_HOME}/logs/atlassian-confluence-outgoing-mail.log.*
  rm -f ${CONF_HOME}/logs/atlassian-confluence-jmx.log.*
  rm -f ${CONF_HOME}/logs/atlassian-confluence-profiler.log.*
  rm -f ${CONF_HOME}/logs/atlassian-confluence-security.log.*
  rm -f ${CONF_HOME}/logs/atlassian-confluence-security.log.*
  rm -f ${CONF_HOME}/analytics-logs/*
  find ${CONF_INSTALL}/temp -mtime +1 -type f -delete
  echo  'Cleaning tmp attachments based on the https://jira.atlassian.com/browse/JRASERVER-71824'
  rm -f ${CONF_INSTALL}/logs/catalina.*.log
}


atlassian_bitbucket_cleanup() {
  # check folder exists for Atlassian
  echo 'Clean Bitbucket logs and temp files'
  BITBUCKET_HOME=/var/atlassian/application-data/bitbucket
  find ${BITBUCKET_HOME}/log -type f -name '*.gz' -delete
  # Remove old search log files
  echo "Removing old search log files in ${BITBUCKET_HOME}/log/search"
  find ${BITBUCKET_HOME}/log/search -type f -mtime +30 -delete
  echo "Remove old temp files"
  find ${BITBUCKET_HOME}/temp -type f -mtime +1 -delete
}

posgresql_cleanup() {
  echo 'Truncate logs of PostgreSQL'
  find /var/lib/pgsql/11/data/pg_log/ -name "*.log"  -exec truncate {} --size 0 \;
}