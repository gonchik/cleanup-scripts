/*
 * Batched notifications execute periodical tasks (every 14 days) to clean up old events
 * from the AO_733371_EVENT and AO_733371_EVENT_RECIPIENT tables.
 * However, on unknown circumstances,
 * this leads to extremely slow queries on the database if using Microsoft SQL Server.
 * This issue seems to happen more often on older MSSQL versions such as 2012 and 2014.
 *
 * Steps to Reproduce
 * - Set up Batched Notifications (enabled by default on Jira 8.0)
 * - Have a large number of email notifications occurring daily
 * - Monitor the database CPU usage with graphs
 *
 * Expected Results
 * - The cleanup tasks occur without affecting the database performance,
 *   as it does on other DBMSs such as Postgres.
 *
 * Actual Results
 *  - The cleanup tasks take several hours to complete,
 *   with the CPU spiking to 100% usage during that period.
 *   General slowness is experienced on Jira due to this.
 *
 *   Links: https://jira.atlassian.com/browse/JRASERVER-71350
 *          https://jira.atlassian.com/browse/JSWSERVER-20794
 */

truncate "AO_733371_EVENT" CASCADE;