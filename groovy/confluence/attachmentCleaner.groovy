import com.atlassian.confluence.spaces.SpaceManager
import com.atlassian.sal.api.component.ComponentLocator
import com.atlassian.confluence.pages.AttachmentManager
import com.atlassian.confluence.pages.PageManager
import org.apache.log4j.Logger
import org.apache.log4j.Level
import java.util.ConcurrentModificationException
import com.atlassian.confluence.pages.Page
import com.atlassian.confluence.core.ContentEntityObject


def log = Logger.getLogger("com.gonchik.scripts.groovy.confluence.attachmentCleaner")
log.setLevel(Level.DEBUG)
final PageManager pageManager = ComponentLocator.getComponent(PageManager)
final SpaceManager spaceManager = ComponentLocator.getComponent(SpaceManager)

boolean allSpaces = false
def spaceKey = "CONDUCTOR50"
def spaces = []

if (allSpaces) {
    spaces = spaceManager.getAllSpaces()
} else {
    spaces = spaceManager.getSpace(spaceKey)
}

for (def space : spaces) {
    log.debug "Review space: " + space.name
    def pages = pageManager.getPages(space, true)
    for (Page page : pages) {
        log.debug "Review page: " + page.getNameForComparison()
        cleanAttachedPreviousVersionsFromContent(page)
        log.debug "End review pages. "
    }
}


private void cleanAttachedPreviousVersionsFromContent(Page page) {
    AttachmentManager attachmentManager = ComponentLocator.getComponent(AttachmentManager)
    def attachments = attachmentManager.getLatestVersionsOfAttachments(page)
    if (attachments == null || attachments.size == 0) {
        log.debug "Empty attachments"
        return
    }
    for (def attachment : attachments) {
        attachmentManager.getPreviousVersions(attachment).each { it ->
            log.debug("Removing " + it.getFileName() + "")
            attachmentManager.removeAttachmentVersionFromServer(it)
        }
    }
}

log.debug "---- End review spaces ---"