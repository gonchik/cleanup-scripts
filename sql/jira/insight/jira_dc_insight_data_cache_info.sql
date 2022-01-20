/*
 *
 * Known issue with the clustermessage table in Insight for Data Center
 * Link: https://documentation.mindville.com/display/ICV85/Known+issue+with+the+clustermessage+table+in+Insight+for+Data+Center
 * https://documentation.mindville.com/display/ICV60/How+do+I+configure+the+clustermessage+retention+period+to+automatically+clear
 *
 */

SELECT count(id)
FROM clustermessage
WHERE message like '%INSIGHT%' and  message_time < NOW() - INTERVAL '3 hours';

-- Request to delete longer then 3 hour Insight Data cluster messages
-- DELETE FROM clustermessage WHERE message like '%INSIGHT%' and  message_time < NOW() - INTERVAL '3 hours';