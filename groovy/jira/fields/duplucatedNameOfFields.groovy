// This script investigate the duplicated naming of fields in the Jira
// as waiting that request https://jira.atlassian.com/browse/JRASERVER-61376
// Motivation based on the UX and continuous of mistakes in scripts, add-ons etc.

import com.atlassian.jira.issue.fields.CustomField
import com.atlassian.jira.issue.fields.FieldManager
import com.atlassian.jira.component.ComponentAccessor


final FieldManager fieldManager = ComponentAccessor.getFieldManager()
final def fields = fieldManager.getAllAvailableNavigableFields()
def sb = new StringBuilder()


def uniqueFieldNames = []
def output = "Start review fields"
def br = "<br/>\n"
log.debug(output)
sb.append(output + br)
for (field in fields) {
    def name = field.getName().toLowerCase()
    if (!(name in (uniqueFieldNames))) {
        uniqueFieldNames += name
    } else {
        output = "Please, investigate field - ${field.name}"
        sb.append(output + br)
        log.debug(output)
    }
}
output = "Investigated ${fields.size()} of fields"
sb.append(output + br)
log.debug(output)
return sb.toString()