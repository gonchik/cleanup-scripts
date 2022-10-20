-- fixed in 3.9.0 of JSD
-- https://jira.atlassian.com/browse/JSDSERVER-5493
-- PSMQ automation thread loops over queue due to message count discrepancy

SELECT Q."NAME", Q."MESSAGE_COUNT", count(M."ID") as real_message_count
FROM "AO_319474_QUEUE"  Q
         LEFT JOIN "AO_319474_MESSAGE" M  on M."QUEUE_ID" = q."ID"
GROUP BY Q."NAME", Q."MESSAGE_COUNT"
HAVING count(M."ID") = 0 AND Q."MESSAGE_COUNT" != 0;


-- if you found rows you can run the next query
/**
    update "AO_319474_QUEUE" set "MESSAGE_COUNT" = 0
    where "NAME" in (select Q."NAME"
                    from "AO_319474_QUEUE"  Q
                    left join "AO_319474_MESSAGE"   M  on M."QUEUE_ID" = q."ID"
                    group by Q."NAME", Q."MESSAGE_COUNT"
                    having count(M."ID") = 0 AND Q."MESSAGE_COUNT" != 0);
*/