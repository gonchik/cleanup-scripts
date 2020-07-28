import com.atlassian.confluence.spaces.SpaceManager
import com.atlassian.sal.api.component.ComponentLocator
import com.atlassian.confluence.pages.AttachmentManager
import com.atlassian.confluence.pages.PageManager
import org.apache.log4j.Logger
import org.apache.log4j.Level
import java.util.ConcurrentModificationException
import com.atlassian.confluence.pages.Page
import com.atlassian.confluence.core.ContentEntityObject


def log = Logger.getLogger("com.gonchik.scripts.groovy.confluence.pageVersionsCleaner")
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
        def pageVersions = pageManager.getVersionHistorySummaries(page);
        for (def hPage : pageVersions) {
            def coe = pageManager.getPage(hPage.id)
            if (coe == null) {
                continue
            }
            pageManager.removeHistoricalVersion(coe)
        }
        log.debug "End review pages."
    }
}
log.debug "---- End review spaces ---"

