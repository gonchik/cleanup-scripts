/*
 Auditing user email domains by querying the application database
 Purpose
    If you are migrating to the Cloud or just auditing your users for security purposes, a good way to ensure that
    only authorized users will have access to your instance is to audit their email domains.
    Emails can be used to reset a user password and therefore are a key component to be assessed to keep your user base safe.
    This article provides steps to help you obtain an aggregate list of email domains and how many users use each domain.
    With this information, you can then work with your security team to audit it.

 Solution
    Step 1: In your instance database, run the following SQL query to retrieve a report containing
    all the domains used in user emails and the user count for each domain:


    link: https://confluence.atlassian.com/migrationkb/auditing-user-email-domains-by-querying-the-application-database-1180146477.html
 */
select right(cwd_user.email_address, strpos(reverse(cwd_user.email_address), '@') - 1), count(*)
from cwd_user
    inner join cwd_directory cd on cd.id = cwd_user.directory_id
where cd.active = 'T'
group by 1
order by 2 desc;