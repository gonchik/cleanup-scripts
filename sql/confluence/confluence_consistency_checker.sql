/*
*  Review without relation records in Confluence
*/
select CONTENTID from EXTRNLNKS where CONTENTID not in (select CONTENTID from CONTENT);
select CONTENT from CONTENTLOCK where CONTENT not in (select CONTENTID from CONTENT);
select CONTENTID from BODYCONTENT where CONTENTID not in (select CONTENTID from CONTENT);
select CONTENTID from TRACKBACKLINKS where CONTENTID not in (select CONTENTID from CONTENT);
select CONTENT_ID from CONTENT_PERM_SET where CONTENT_ID not in (select CONTENTID from CONTENT);
select CONTENTID from CONTENT_LABEL where CONTENTID not in (select CONTENTID from CONTENT);
select PAGEID from NOTIFICATIONS where PAGEID not in (select CONTENTID from CONTENT);
select DESCENDENTID from CONFANCESTORS where DESCENDENTID not in (select CONTENTID from CONTENT);
select ANCESTORID from CONFANCESTORS where ANCESTORID not in (select CONTENTID from CONTENT);
select PREVVER from CONTENT where PREVVER not in (select CONTENTID from CONTENT);
select PARENTID from CONTENT where PARENTID not in (select CONTENTID from CONTENT);
select PAGEID from CONTENT where PAGEID not in (select CONTENTID from CONTENT);
select PARENTCOMMENTID from CONTENT where PARENTCOMMENTID not in (select CONTENTID from CONTENT);
select CPS_ID from CONTENT_PERM where CPS_ID not in (select ID from CONTENT_PERM_SET);
select LABELID from CONTENT_LABEL where LABELID not in (select LABELID from LABEL);
select group_id from os_user_group where group_id not in (select id from os_group);
select user_id from os_user_group where user_id not in (select id from os_user);
select userid from local_members where userid not in (select id from users);
select groupid from local_members where groupid not in (select id from groups);
select groupid from external_members where groupid not in (select id from groups);
select extentityid from external_members where extentityid not in (select id from external_entities);
select SPACEID from NOTIFICATIONS where SPACEID not in (select SPACEID from SPACES);
select SPACEID from SPACEPERMISSIONS where SPACEID not in (select SPACEID from SPACES);
select SPACEID from PAGETEMPLATES where SPACEID not in (select SPACEID from SPACES);
select SPACEID from CONTENT where SPACEID not in (select SPACEID from SPACES);
select PREVVER from PAGETEMPLATES where PREVVER not in (select TEMPLATEID from PAGETEMPLATES);
select HOMEPAGE from SPACES where HOMEPAGE not in (select CONTENTID from CONTENT);
select SPACEDESCID from SPACES where SPACEDESCID not in (select CONTENTID from CONTENT);
select SPACEGROUPID from SPACES where SPACEGROUPID is not null AND SPACEGROUPID not in (select SPACEGROUPID from SPACEGROUPS);