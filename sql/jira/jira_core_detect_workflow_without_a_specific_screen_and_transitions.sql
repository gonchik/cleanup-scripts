/*
    How to use SQL query to look for workflows without a specific screen in any transition
    link:https://confluence.atlassian.com/jirakb/how-to-use-sql-query-to-look-for-workflows-without-a-specific-screen-in-any-transition-1141475246.html
 */

select j.id,
       j.workflowname,
       workflow_action.name as transition_name,
       workflow_action.view,
       workflow_action.fieldscreen,
       workflow_step.name   as statusname,
       workflow_step.statusid
from jiraworkflows j,
     XMLTABLE('//workflow/common-actions/action'
                  passing xmlparse(document descriptor)
	columns
		id int path '@id',
              name text path '@name',
         view text path '@view' default null,
              fieldscreen int path 'meta[@name = "jira.fieldscreen.id" and text() != ""]' default null,
              next_step int path 'results/unconditional-result/@step'
     ) as workflow_action
         join
     XMLTABLE('//workflow/steps/step'
                  passing xmlparse(document descriptor)
	columns
		id int path '@id',
              name text path '@name',
              statusid text path 'meta[@name = "jira.status.id"]' default null
     ) as workflow_step on workflow_action.next_step = workflow_step.id
         join
     issuestatus i on workflow_step.statusid = i.id
where i.statuscategory = 3
  and workflow_action.fieldscreen is null;
