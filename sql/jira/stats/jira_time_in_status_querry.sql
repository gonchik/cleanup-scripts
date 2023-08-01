with statusHistory as
         (select jiraissue.ID,
                 p.pname,
                 p.pkey,
                 jiraissue.issuenum,
                 jiraissue.priority,
                 pri.pname         as                           priorityname,
                 c.cname           as                           componentname,
                 pv.id             as                           fixversionId,
                 pv.vname          as                           fixversion,
                 jiraissue.created as                           issueCreated,
                 jiraissue.resolutiondate,
                 changeitem.OLDSTRING                           OldStatus,
                 changeitem.NEWSTRING                           NewStatus,
                 changegroup.CREATED                            Executed,
                 changegroup.CREATED - lag(changegroup.CREATED) over (partition by jiraissue.ID order by changegroup.CREATED) as MinutesInStatus, row_number() over (partition by jiraissue.ID order by changegroup.CREATED) StatusOrder
          from changeitem
                   inner join changegroup on changeitem.groupid = changegroup.id
                   inner join jiraissue on jiraissue.id = changegroup.issueid
                   inner join project p on jiraissue.project = p.id
                   inner join nodeassociation na on na.SOURCE_NODE_ID = jiraissue.ID
                   inner join projectversion pv on pv.id = na.SINK_NODE_ID
                   join priority pri on pri.id = jiraissue.priority
                   inner join component c on na.sink_node_id = c.id
          where changeitem.field = 'status'
            and changeitem.FIELDTYPE = 'jira'
            and pkey = 'HM')
select *
from statusHistory;