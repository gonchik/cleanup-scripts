/*
    Enable plugin upload by default in Jira 8.12.4 and later
    https://jira.atlassian.com/browse/JRASERVER-77129
 */
import com.onresolve.osgi.AllBundlesApplicationContext
import com.onresolve.scriptrunner.runner.ScriptRunnerImpl

def allBundlesApplicationContext = ScriptRunnerImpl.scriptRunner.getBean(AllBundlesApplicationContext)
def policyEnforcer = allBundlesApplicationContext.getBean(
        'com.atlassian.upm.atlassian-universal-plugin-manager-plugin', 'policyEnforcer'
)

policyEnforcer.getClass().declaredFields.find {
    it.name == 'pluginUploadEnabled'
}.with {
    setAccessible(true)
    setBoolean(policyEnforcer, true)
}
