/*
 How to remove all shared drafts and start with a clean state using Collaborative Editing
 Purpose: Important Definitions
    To understand more about this KB, the following definitions are necessary:
    CE: Collaborative Editing.
    Personal draft: a draft that is visible only by its creator and was saved while Collaborative Editing was disabled.
    Shared draft: a draft that can be shared with collaborators other than just its creator and was saved while Collaborative Editing was enabled.
    More information about drafts can be found in How Do Drafts Work on Confluence.
    Link: https://confluence.atlassian.com/confkb/how-to-remove-all-shared-drafts-and-start-with-a-clean-state-using-collaborative-editing-974360865.html
 */

/******* Make child of drafts orphan pages *******/
/* SQL query to count affected records */
select count(c.CONTENTID) from CONTENT c join CONTENT d on d.CONTENTID=c.PARENTID where d.content_status='draft';

/* SQL query to update affected records */
create temporary table TEMP_CONTENTID (select c.CONTENTID from CONTENT c join CONTENT d on d.CONTENTID=c.PARENTID where d.content_status='draft' order by c.CONTENTID);
update CONTENT set PARENTID=null where CONTENTID in (select CONTENTID from TEMP_CONTENTID);
drop temporary table TEMP_CONTENTID;



/******* Delete notifications related to drafts *******/
/* SQL query to count affected records */
select count(*) from NOTIFICATIONS where CONTENTID in (select d.CONTENTID from CONTENT d where d.CONTENT_STATUS = 'draft' and d.CONTENTTYPE = 'PAGE');

/* SQL query to update affected records */
delete from NOTIFICATIONS where CONTENTID in (select d.CONTENTID from CONTENT d where d.CONTENT_STATUS = 'draft' and d.CONTENTTYPE = 'PAGE');



/******* Delete drafts that are child in CONFANCESTORS *******/
/* SQL query to count affected records */
select count(*) from CONFANCESTORS where DESCENDENTID in (select d.CONTENTID from CONTENT d where d.CONTENT_STATUS = 'draft' and d.CONTENTTYPE = 'PAGE');

/* SQL query to update affected records */
delete from CONFANCESTORS where DESCENDENTID in (select d.CONTENTID from CONTENT d where d.CONTENT_STATUS = 'draft' and d.CONTENTTYPE = 'PAGE');



/******* Delete drafts that are ancestors in CONFANCESTORS *******/
/* SQL query to count affected records */
select count(*) from CONFANCESTORS where ANCESTORID in (select d.CONTENTID from CONTENT d where d.CONTENT_STATUS = 'draft' and d.CONTENTTYPE = 'PAGE');

/* SQL query to update affected records */
delete from CONFANCESTORS where ANCESTORID in (select d.CONTENTID from CONTENT d where d.CONTENT_STATUS = 'draft' and d.CONTENTTYPE = 'PAGE');



/******* Delete body of drafts *******/
/* SQL query to count affected records */
select count(CONTENTID) from BODYCONTENT where CONTENTID in (select d.CONTENTID from CONTENT d where d.CONTENT_STATUS = 'draft' and d.CONTENTTYPE = 'PAGE');

/* SQL query to update affected records */
delete from BODYCONTENT where CONTENTID in (select d.CONTENTID from CONTENT d where d.CONTENT_STATUS = 'draft' and d.CONTENTTYPE = 'PAGE');



/******* Delete links related to drafts *******/
/* SQL query to count affected records */
select count(*) from LINKS where CONTENTID in (select d.CONTENTID from CONTENT d where d.CONTENT_STATUS = 'draft' and d.CONTENTTYPE = 'PAGE');

/* SQL query to update affected records */
delete from LINKS where CONTENTID in (select d.CONTENTID from CONTENT d where d.CONTENT_STATUS = 'draft' and d.CONTENTTYPE = 'PAGE');



/******* Delete labels relation to drafts *******/
/* SQL query to count affected records */
select count(*) from CONTENT_LABEL where CONTENTID in (select d.CONTENTID from CONTENT d where d.CONTENT_STATUS = 'draft' and d.CONTENTTYPE = 'PAGE');

/* SQL query to update affected records */
delete from CONTENT_LABEL where CONTENTID in (select d.CONTENTID from CONTENT d where d.CONTENT_STATUS = 'draft' and d.CONTENTTYPE = 'PAGE');


/* SQL query to count affected records */
select count(*) from CONTENT_LABEL where CONTENTID in (select c.CONTENTID from CONTENT c join CONTENT_LABEL cl on cl.CONTENTID=c.CONTENTID where c.CONTENTID in (select a.CONTENTID from CONTENT a join CONTENT d on d.CONTENTID=a.PAGEID where a.CONTENTTYPE='ATTACHMENT' and d.CONTENT_STATUS = 'draft' and d.CONTENTTYPE = 'PAGE'));

/* SQL query to update affected records */
delete from CONTENT_LABEL where CONTENTID in (select c.CONTENTID from CONTENT c join CONTENT_LABEL cl on cl.CONTENTID=c.CONTENTID where c.CONTENTID in (select a.CONTENTID from CONTENT a join CONTENT d on d.CONTENTID=a.PAGEID where a.CONTENTTYPE='ATTACHMENT' and d.CONTENT_STATUS = 'draft' and d.CONTENTTYPE = 'PAGE'));



/******* Delete users relation to drafts *******/
/* SQL query to count affected records */
select count(*) from USERCONTENT_RELATION where TARGETCONTENTID in (select d.CONTENTID from CONTENT d where d.CONTENT_STATUS = 'draft' and d.CONTENTTYPE = 'PAGE');

/* SQL query to update affected records */
delete from USERCONTENT_RELATION where TARGETCONTENTID in (select d.CONTENTID from CONTENT d where d.CONTENT_STATUS = 'draft' and d.CONTENTTYPE = 'PAGE');


--- !! THIS TABLE DOES NOT EXIST AFTER CONFLUENCE 7.X !! ---
/******* Delete external links related to drafts *******/
/* SQL query to count affected records */
select count(*) from EXTRNLNKS where CONTENTID in (select d.CONTENTID from CONTENT d where d.CONTENT_STATUS = 'draft' and d.CONTENTTYPE = 'PAGE');

/* SQL query to update affected records */
delete from EXTRNLNKS where CONTENTID in (select d.CONTENTID from CONTENT d where d.CONTENT_STATUS = 'draft' and d.CONTENTTYPE = 'PAGE');



/******* Delete likes related to drafts *******/
/* SQL query to count affected records */
select count(*) from LIKES where CONTENTID in (select d.CONTENTID from CONTENT d where d.CONTENT_STATUS = 'draft' and d.CONTENTTYPE = 'PAGE');

/* SQL query to update affected records */
delete from LIKES where CONTENTID in (select d.CONTENTID from CONTENT d where d.CONTENT_STATUS = 'draft' and d.CONTENTTYPE = 'PAGE');



/******* Delete attachment properties related to drafts *******/
/* SQL query to count affected records */
select count(PROPERTYID) from CONTENTPROPERTIES where CONTENTID in (select a.CONTENTID from CONTENT a join CONTENT d on d.CONTENTID=a.PAGEID where a.CONTENTTYPE='ATTACHMENT' and d.CONTENT_STATUS = 'draft' and d.CONTENTTYPE = 'PAGE');

/* SQL query to update affected records */
delete from CONTENTPROPERTIES where CONTENTID in (select a.CONTENTID from CONTENT a join CONTENT d on d.CONTENTID=a.PAGEID where a.CONTENTTYPE='ATTACHMENT' and d.CONTENT_STATUS = 'draft' and d.CONTENTTYPE = 'PAGE');



/******* Delete image properties related to drafts *******/
/* SQL query to count affected records */
select count(*) from IMAGEDETAILS where ATTACHMENTID in (select a.CONTENTID from CONTENT a join CONTENT d on d.CONTENTID=a.PAGEID where a.CONTENTTYPE='ATTACHMENT' and d.CONTENT_STATUS = 'draft' and d.CONTENTTYPE = 'PAGE');

/* SQL query to update affected records */
delete from IMAGEDETAILS where ATTACHMENTID in (select a.CONTENTID from CONTENT a join CONTENT d on d.CONTENTID=a.PAGEID where a.CONTENTTYPE='ATTACHMENT' and d.CONTENT_STATUS = 'draft' and d.CONTENTTYPE = 'PAGE');



/******* Delete previous versions of attachments related to drafts *******/
/* SQL query to count affected records */
select count(a.CONTENTID) from CONTENT a join CONTENT d on d.CONTENTID=a.PAGEID where a.CONTENTTYPE='ATTACHMENT' and a.PREVVER is not NULL and d.CONTENT_STATUS = 'draft' and d.CONTENTTYPE = 'PAGE';

/* SQL query to update affected records */
create temporary table TEMP_CONTENTID (select a.CONTENTID from CONTENT a join CONTENT d on d.CONTENTID=a.PAGEID where a.CONTENTTYPE='ATTACHMENT' and a.PREVVER is not NULL and d.CONTENT_STATUS = 'draft' and d.CONTENTTYPE = 'PAGE' order by a.CONTENTID);
delete from CONTENT where CONTENTID in (select CONTENTID from TEMP_CONTENTID);
drop temporary table TEMP_CONTENTID;



/******* Delete attachments related to drafts *******/
/* SQL query to count affected records */
select count(CONTENTID) from CONTENT where CONTENTID in (select a.CONTENTID from CONTENT a join CONTENT d on d.CONTENTID=a.PAGEID where a.CONTENTTYPE='ATTACHMENT' and d.CONTENT_STATUS = 'draft' and d.CONTENTTYPE = 'PAGE');

/* SQL query to update affected records */
create temporary table TEMP_CONTENTID (select CONTENTID from CONTENT where CONTENTID in (select a.CONTENTID from CONTENT a join CONTENT d on d.CONTENTID=a.PAGEID where a.CONTENTTYPE='ATTACHMENT' and d.CONTENT_STATUS = 'draft' and d.CONTENTTYPE = 'PAGE') order by CONTENTID);
delete from CONTENT where CONTENTID in (select CONTENTID from TEMP_CONTENTID);
drop temporary table TEMP_CONTENTID;



/******* Delete properties of comments related to drafts *******/
/* SQL query to count affected records */
select count(cp.PROPERTYID) from CONTENTPROPERTIES cp join CONTENT c on c.CONTENTID=cp.CONTENTID join CONTENT d on d.CONTENTID=c.PAGEID where c.CONTENTTYPE='COMMENT' and d.CONTENT_STATUS = 'draft' and d.CONTENTTYPE = 'PAGE';

/* SQL query to update affected records */
create temporary table TEMP_PROPERTYID (select cp.PROPERTYID from CONTENTPROPERTIES cp join CONTENT c on c.CONTENTID=cp.CONTENTID join CONTENT d on d.CONTENTID=c.PAGEID where c.CONTENTTYPE='COMMENT' and d.CONTENT_STATUS = 'draft' and d.CONTENTTYPE = 'PAGE' order by cp.PROPERTYID);
delete from CONTENTPROPERTIES where PROPERTYID in (select PROPERTYID from TEMP_PROPERTYID);
drop temporary table TEMP_PROPERTYID;



/******* Delete body of comments related to drafts *******/
/* SQL query to count affected records */
select count(bc.BODYCONTENTID) from BODYCONTENT bc join CONTENT c on c.CONTENTID=bc.CONTENTID join CONTENT d on d.CONTENTID=c.PAGEID where c.CONTENTTYPE='COMMENT' and d.CONTENT_STATUS = 'draft' and d.CONTENTTYPE = 'PAGE';

/* SQL query to update affected records */
create temporary table TEMP_BODYCONTENTID (select bc.BODYCONTENTID from BODYCONTENT bc join CONTENT c on c.CONTENTID=bc.CONTENTID join CONTENT d on d.CONTENTID=c.PAGEID where c.CONTENTTYPE='COMMENT' and d.CONTENT_STATUS = 'draft' and d.CONTENTTYPE = 'PAGE' order by bc.BODYCONTENTID);
delete from BODYCONTENT where BODYCONTENTID in (select BODYCONTENTID from TEMP_BODYCONTENTID);
drop temporary table TEMP_BODYCONTENTID;



/******* Delete any other contents related to drafts *******/
/* SQL query to count affected records */
select count(CONTENTID) from CONTENT where PAGEID in (select d.CONTENTID from CONTENT d where d.CONTENT_STATUS = 'draft' and d.CONTENTTYPE = 'PAGE');

/* SQL query to update affected records */
create temporary table TEMP_CONTENTID (select CONTENTID from CONTENT where PAGEID in (select d.CONTENTID from CONTENT d where d.CONTENT_STATUS = 'draft' and d.CONTENTTYPE = 'PAGE') order by CONTENTID);
delete from CONTENT where CONTENTID in (select CONTENTID from TEMP_CONTENTID);
drop temporary table TEMP_CONTENTID;



/******* Delete restrictions related to drafts – first query *******/
/* SQL query to count affected records */
select count(cp.ID) from CONTENT_PERM cp join CONTENT_PERM_SET cps on cps.ID=cp.CPS_ID join CONTENT d on d.CONTENTID=cps.CONTENT_ID where d.CONTENT_STATUS = 'draft' and d.CONTENTTYPE = 'PAGE';

/* SQL query to update affected records */
create temporary table TEMP_CONTENT_PERM_ID (select cp.ID from CONTENT_PERM cp join CONTENT_PERM_SET cps on cps.ID=cp.CPS_ID join CONTENT d on d.CONTENTID=cps.CONTENT_ID where d.CONTENT_STATUS = 'draft' and d.CONTENTTYPE = 'PAGE' order by cp.ID);
delete from CONTENT_PERM where ID in (select ID from TEMP_CONTENT_PERM_ID);
drop temporary table TEMP_CONTENT_PERM_ID;



/******* Delete restrictions related to drafts – second query *******/
/* SQL query to count affected records */
select count(cps.ID) from CONTENT_PERM_SET cps join CONTENT d on d.CONTENTID=cps.CONTENT_ID where d.CONTENT_STATUS = 'draft' and d.CONTENTTYPE = 'PAGE';

/* SQL query to update affected records */
create temporary table TEMP_CONTENT_PERM_SET_ID (select cps.ID from CONTENT_PERM_SET cps join CONTENT d on d.CONTENTID=cps.CONTENT_ID where d.CONTENT_STATUS = 'draft' and d.CONTENTTYPE = 'PAGE' order by cps.ID);
delete from CONTENT_PERM_SET where ID in (select ID from TEMP_CONTENT_PERM_SET_ID);
drop temporary table TEMP_CONTENT_PERM_SET_ID;



/******* Delete properties related to drafts *******/
/* SQL query to count affected records */
select count(*) from CONTENTPROPERTIES where CONTENTID in (select d.CONTENTID from CONTENT d where d.CONTENT_STATUS = 'draft' and d.CONTENTTYPE = 'PAGE');

/* SQL query to update affected records */
delete from CONTENTPROPERTIES where CONTENTID in (select d.CONTENTID from CONTENT d where d.CONTENT_STATUS = 'draft' and d.CONTENTTYPE = 'PAGE');



/******* Delete contents that are drafts *******/
/* SQL query to count affected records */
select count(d.CONTENTID) from CONTENT d where d.CONTENT_STATUS = 'draft' and d.CONTENTTYPE = 'PAGE';

/* SQL query to update affected records */
delete from CONTENT where CONTENT_STATUS = 'draft' and CONTENTTYPE = 'PAGE';



/******* Clear Synchrony IDs from the BANDANA table *******/
/* SQL query to update affected records */
delete from bandana where bandanakey = 'synchrony_collaborative_editor_app_registered'
                       or bandanakey = 'synchrony_collaborative_editor_app_secret'
                       or bandanakey = 'synchrony_collaborative_editor_app_id';



/******* Clear tables associated to Synchrony *******/
truncate table EVENTS;
truncate table SECRETS;
truncate table SNAPSHOTS;
