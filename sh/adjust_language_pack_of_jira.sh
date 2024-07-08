su jira
echo "Adjust existing bundle of translation"
cd /opt/atlassian/jira/atlassian-jira/WEB-INF/atlassian-bundled-plugins/
mkdir unpack
cd unpack
/usr/java/latest/bin/jar xvf ../jira-core-language-pack-ru_RU-9.8.0.v20230228123141.jar
vim com/atlassian/jira/web/action/JiraWebActionSupport_ru_RU.properties
/usr/java/latest/bin/jar cf ../jira-core-language-pack-ru_RU-9.8.0.v20230228123141.jar *
cd ..
rm -rf unpack/
