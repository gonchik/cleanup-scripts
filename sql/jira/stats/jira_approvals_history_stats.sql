-- get stats
/*
    https://confluence.atlassian.com/jirakb/how-to-find-the-request-type-of-an-issue-using-sql-query-1180150449.html

 */
select issue.ID                                                                 as "id"
     , (select CAST(CONCAT(pkey, '-', issue.issuenum) as CHAR(255)) ::text
        from project pkey
        where pkey.id = issue.PROJECT)                                          as "key"
     , issue.summary                                                            as "Summary"
     -- , issue.reporter                                                           as "Reporter"
     -- , issue.assignee                                                           as "Assignee"
     -- , issue.creator                                                            as "Creator"
--Dates
     , issue.created                                                            as "Created"
     , issue.updated                                                            as "Updated"
--Status
     , (select pname from issuestatus where issuestatus.ID = issue.issuestatus) as "Status.name"
     , (select pname from issuetype where issuetype.ID = issue.issuetype)       as "Issue Type.name"
--Resolution
     , (select pname from resolution where resolution.ID = issue.resolution)    as "Resolution.name"
     , issue.resolutiondate                                                     as "Resolved"
--customfields
     , (select request."NAME"
        from customfieldvalue cfv
                 inner join "AO_54307E_VIEWPORTFORM" request on position(request."KEY" in cfv.stringvalue) > 0
        where customfield = 10010 -- customer request type
          and issue = issue.id
                                                                                   limit
    1)                                                                as "Request Type.name"
--Channel
     , (select ep.json_value::json ->> 'value' as "channel"
        FROM entity_property ep
        where ep.entity_id = issue.id
          and ep.property_key = 'request.channel.type')                         as "Channel"
from jiraissue issue
where issue.PROJECT = (select id from project where pkey = 'EXSD');

-- get approval history

select ap."ISSUE_ID"     as issue_id
     , u.lower_user_name as approver
     , apd."DECISION"    as approval_decision
     , to_timestamp(ap."COMPLETED_DATE" / 1000) ::TIMESTAMP WITHOUT TIME ZONE as approval_time
from "AO_56464C_APPROVAL" ap
    join "AO_56464C_APPROVERDECISION" apd
on ap."ID" = apd."APPROVAL_ID"
    join app_user u on u.user_key=apd."USER_KEY"
    join jiraissue issue on issue.id=ap."ISSUE_ID"
where issue.project = (select id from project where pkey = 'EXSD');