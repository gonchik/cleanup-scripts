/*
    Provide service configs which running on that node.
 */
select id, servicename, clazz, cron_expression, delaytime
from serviceconfig;