/*
 *
 * clean automation rules items logs for Jira Service Management
 * it helps for the large installations
 *
 */
select count(*) from "AO_9B2E3B_EXEC_RULE_MSG_ITEM";
truncate "AO_9B2E3B_EXEC_RULE_MSG_ITEM";

select count(*) from "AO_9B2E3B_IF_COND_EXECUTION";
truncate "AO_9B2E3B_IF_COND_EXECUTION" CASCADE ;

-- remove all history of running
truncate "AO_9B2E3B_RULE_EXECUTION" CASCADE ;



