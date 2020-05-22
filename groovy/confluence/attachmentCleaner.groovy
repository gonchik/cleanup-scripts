import com.atlassian.confluence.spaces.SpaceManager
import com.atlassian.sal.api.component.ComponentLocator
import com.atlassian.confluence.pages.AttachmentManager
import com.atlassian.confluence.pages.PageManager
import org.apache.log4j.Logger
import org.apache.log4j.Level
import java.util.ConcurrentModificationException


def log = Logger.getLogger("com.gonchik.scripts.groovy.confluence.attachemntCleaner")
log.setLevel(Level.DEBUG)
final PageManager pageManager = ComponentLocator.getComponent(PageManager)
final SpaceManager spaceManager = ComponentLocator.getComponent(SpaceManager.class)

spaceManager.getAllSpaces().each { space ->
    pageManager.getPages(space, true).each { page ->
        long pageId = page.id
        try {
            cleanPreviousVerionsFromContent(pageId)
        } catch (ConcurrentModificationException e) {
            log.error("Please, wait then do rerun")
        }
    }
}


def cleanPreviousVerionsFromContent(long pageId) throws ConcurrentModificationException {
    def attachmentManager = ComponentLocator.getComponent(AttachmentManager.class)
    def pageManager = ComponentLocator.getComponent(PageManager)
    def page = pageManager.getPage(pageId)
    def attachments = page.getAttachments()

    for (def attachment : attachments) {
        attachmentManager.getPreviousVersions(attachment).each { it ->
            log.debug("Removing " + it.getFileName() + "")
            attachmentManager.removeAttachmentVersionFromServer(it)
        }
    }
}