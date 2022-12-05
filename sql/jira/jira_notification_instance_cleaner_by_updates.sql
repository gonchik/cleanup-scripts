/*
 Delete references to issues WITHOUT resolution or NOT updated last 24 week */
*/


    SELECT count(ID)
    FROM notificationinstance
    WHERE SOURCE IN (   SELECT ID
					    FROM jiraissue
                        WHERE RESOLUTION is not null
                        and
						    UPDATED < (NOW() - '12 WEEK')
					);


/*
    DELETE
    FROM notificationinstance
    WHERE SOURCE IN (   SELECT ID
					    FROM jiraissue
                        WHERE RESOLUTION is not null
                        and
						    UPDATED < (NOW() - '12 WEEK')
					);
 */
