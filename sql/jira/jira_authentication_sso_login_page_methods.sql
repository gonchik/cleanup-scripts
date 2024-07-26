/*
    Jira's authentication methods are easily accessible via the UI via Jira Admin → System → Authentication methods
    This article describes how to obtain this information from the database or REST API
    Please note that both the REST API and database schema are subject to change in future versions.
    link: https://confluence.atlassian.com/jirakb/how-to-obtain-authentication-methods-via-a-database-sql-query-or-rest-api-in-jira-datacenter-1319567431.html
*/

-- Username and password (Product login form)
select p.property_key, ps.propertyvalue
from propertystring ps
         join propertyentry p ON ps.id = p.id
WHERE p.property_key = 'com.atlassian.plugins.authentication.sso.config.show-login-form';

-- SSO login page methods
select *
from "AO_ED669C_IDP_CONFIG";
