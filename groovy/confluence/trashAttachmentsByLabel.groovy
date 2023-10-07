import com.atlassian.sal.api.component.ComponentLocator
import com.atlassian.confluence.pages.AttachmentManager
import com.atlassian.confluence.pages.PageManager
import org.apache.log4j.Logger
import org.apache.log4j.Level
import java.util.ConcurrentModificationException
import com.atlassian.confluence.pages.Page

long ParentPageID = 0000000000000;      // id of parent page
String attachmentLabel = "LABEL_NAME";  // label name

final PageManager pageManager = ComponentLocator.getComponent(PageManager)
def parentPage = pageManager.getPage(Long.valueOf(ParentPageID));

List<Page> pages = parentPage.getDescendants();
for (Page page : pages) {
    List<Attachment> attachments = page.getAttachments();
    for (Attachment attachment : attachments) {
        for (Label label : attachment.getLabels()) {
            if (label.getName().equalsIgnoreCase(attachmentLabel)) {
                attachment.trash();
            }

        }
    }
}