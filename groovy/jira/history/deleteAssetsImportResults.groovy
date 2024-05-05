import com.atlassian.jira.component.ComponentAccessor
import org.ofbiz.core.entity.ConnectionFactory 
import org.ofbiz.core.entity.DelegatorInterface
import java.sql.Connection
import groovy.sql.Sql
import org.apache.log4j.Logger

/**
 * Purpose: Global Regular Job for deleting older more than 1 month import results from Assets
 * Usage: Job
 * Preconditions: Avaliable rows in import results table
 * Environment: Jira Software 9.12.7, JSM 5.12.7
 * Script type: Filesystem
 * Author: Tumanov Artem
 * Project: -
 * Transition: -
 */

log = Logger.getLogger("[Assets] Delete Import Results")

log.warn("Start")

Integer prepareRowsCount = getCountRowsOfImportResult()

if (prepareRowsCount > 0) {
    log.warn("Preparing rows count('${prepareRowsCount}')")
    Integer deleteImportResultDetailsCount = deleteImportResultDetails()
    if (deleteImportResultDetailsCount) {
        deleteImportResult()
    } else {
        log.error("Some problem with deleting rows from 'AO_8542F1_IFJ_PRG_OT_RES' table")
        log.warn("End")
        return
    }
} else {
    log.warn("No need to delete rows")
    log.warn("End")
    return
}

def deleteImportResult () {
    DelegatorInterface delegator = ComponentAccessor.getComponent(DelegatorInterface) 
    String helperName = delegator.getGroupHelperName("default")
    Connection conn = ConnectionFactory.getConnection(helperName)
    Sql sql = new Sql(conn)
    
    final String deleteProgressResultsQuery = """
    WITH deleted as (
    delete from "AO_8542F1_IFJ_PRG_RES" import_res_del
            where import_res_del."ID" in (
            select import_res."ID"
            	from "AO_8542F1_IFJ_PRG_RES" import_res
            		where import_res."STARTED" < NOW() - interval '1 month') IS TRUE RETURNING *)
    SELECT count(*) count FROM deleted;
    """

    log.info("Deleting progress result details from 'AO_8542F1_IFJ_PRG_RES' using sql: '${deleteProgressResultsQuery}'")
    Integer numberOfDeleteImportResult
    try { 
        numberOfDeleteImportResult = sql.firstRow(deleteProgressResultsQuery)?.getAt('count') as Integer
    } catch(any) {
        sql.close()
        log.error(any.message)
        return
    } finally {
        sql.close()
        log.warn("Delete '${numberOfDeleteImportResult}' rows from 'AO_8542F1_IFJ_PRG_RES' successfully")
    }
}

Integer deleteImportResultDetails () {
    
    DelegatorInterface delegator = ComponentAccessor.getComponent(DelegatorInterface) 
    String helperName = delegator.getGroupHelperName("default")
    Connection conn = ConnectionFactory.getConnection(helperName)
    Sql sql = new Sql(conn)

    final String  deleteProgressResultDetailsQuery = """
    WITH deleted as (
    delete from "AO_8542F1_IFJ_PRG_OT_RES" import_res_det
        where  import_res_det."PROGRESS_RESULT_ID" in
        (select import_res."ID" 
            from "AO_8542F1_IFJ_PRG_RES" as import_res
                where 
                import_res."STARTED" < NOW() - interval '1 month') IS TRUE RETURNING *)
    SELECT count(*) count FROM deleted;
    """
    log.info("Deleting progress result details from 'AO_8542F1_IFJ_PRG_OT_RES' using sql: '${deleteProgressResultDetailsQuery}'")

    Integer numberOfDeleteImportResultDetails
    try { 
        numberOfDeleteImportResultDetails = sql.firstRow(deleteProgressResultDetailsQuery)?.getAt('count') as Integer
    } catch(any) {
        sql.close()
        log.error(any.message)
        return
    } finally {
        sql.close()
        log.warn("Delete '${numberOfDeleteImportResultDetails}' rows from 'AO_8542F1_IFJ_PRG_OT_RES' successfully")
        return numberOfDeleteImportResultDetails
    }
}

Integer getCountRowsOfImportResult () {

    DelegatorInterface delegator = ComponentAccessor.getComponent(DelegatorInterface) 
    String helperName = delegator.getGroupHelperName("default")
    Connection conn = ConnectionFactory.getConnection(helperName)
    Sql sql = new Sql(conn)
    
    final String selectCountProgressResultQuery = """
    select
    count(import_res."ID") as count
        from "AO_8542F1_IFJ_PRG_RES" as import_res
            where import_res."STARTED" < NOW() - interval '1 month';
    """
    log.info("Fetching rows for delete using sql: '${selectCountProgressResultQuery}'")

    Integer numberOfImportResult
    try { 
        numberOfImportResult = sql.firstRow(selectCountProgressResultQuery)?.getAt('count') as Integer
    } catch(any) {
        sql.close()
        log.error(any.message)
    } finally {
        sql.close()
        return numberOfImportResult
    }
}
