/*
    Cleanup JMWE execution log
 */


select count(*)
from "AO_7AEB56_EXECUTION_LOG";


-- cleanup table
truncate "AO_7AEB56_EXECUTION_LOG";