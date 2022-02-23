/*
    How many tickets has  exact issue link types in Jira
 */

select ist.linkname, count(ist.linkname)
from issuelink il
         join issuelinktype ist on ist.id = il.linktype
group by ist.linkname
order by 2;
