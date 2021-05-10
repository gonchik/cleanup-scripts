# check number active sessions
cat atlassian-jira-perf.log* | egrep 'dbcp.numActive","value":"[0-9]*"' | sed -E 's/,[0-9]{3}.*dbcp.numActive",/ /g' | sed -E 's/\},\{.*$//g' | sed 's/"value"://g' | sed 's/"//g' | cut -d" " -f-3  |sort  |awk  '{if ($3 >20) {print $1" "$2" "$3 } }'

# check number of active HTTP sessions
cat atlassian-jira-perf.log* | egrep 'http.sessions","value":"[0-9]*"' | sed -E 's/,[0-9]{3}.*http.sessions",/ /g' | sed -E 's/\},\{.*$//g' | sed 's/"value"://g' | sed 's/"//g' | cut -d" " -f-3  |sort  |awk  '{if ($3 >1300) {print $1" "$2" "$3 } }'
