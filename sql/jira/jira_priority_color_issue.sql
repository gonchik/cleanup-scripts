/*
    It's possible to confirm if you're being affected by this bug by running the query below:

    SELECT id, pname, status_color FROM priority ;
    If the value of status_color returned for any of the rows returned is different
    from a '#' character followed by six hexadecimal characters,
    please edit the corresponding priority through the Administration » Issues » Priorities page.
    link: https://jira.atlassian.com/browse/JRASERVER-32328
 */

SELECT id, pname, status_color
FROM priority
where length(status_color) <> 7;