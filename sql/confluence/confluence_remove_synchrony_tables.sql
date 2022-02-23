/*
    How to reduce the size of Synchrony tables
    Purpose: problems with synchrony works for large systems
    link: https://confluence.atlassian.com/confkb/how-to-reduce-the-size-of-synchrony-tables-858770831.html

 */

TRUNCATE TABLE "EVENTS";
TRUNCATE TABLE "SECRETS";
TRUNCATE TABLE "SNAPSHOTS";