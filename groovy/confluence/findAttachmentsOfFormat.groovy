import groovy.transform.TimedInterrupt
import java.util.concurrent.TimeUnit
import com.atlassian.confluence.security.ContentPermission
import com.atlassian.sal.api.transaction.TransactionCallback
import com.atlassian.confluence.core.Modification

def log = Logger.getLogger("com.gonchik.scripts.groovy.confluence.findAttachmentsOfFormat")
log.setLevel(Level.DEBUG)

class Data {
    static String textToFind = "TO_FIND"
    static String textToReplace = "TO_REPLACE"
    static long parentPageId = 11111111111
}

transactionTemplate.execute(new TransactionCallback() {

    @Override
    Object doInTransaction() {

        SaveContext saveContext = new DefaultSaveContext(true, true, false);

        def parentPage = pageManager.getPage(Data.parentPageId);

        def pages = parentPage.getDescendants();

        pages.each { page ->

            if (page.getTitle().contains(Data.textToFind)) {

                log.debug("Space Key :: " + page.getSpaceKey() + " | Page Title :: " + page.getTitle() + " | Link to Page :: " + settingsManager.getGlobalSettings().getBaseUrl() + page.getUrlPath() + "\n")
                pageManager.saveNewVersion(page, new TextModification(), saveContext);
            }
        }

        return "Success!";
    }
}
);


class TextModification implements Modification<Page> {

    @Override
    void modify(Page page) {

        page.setTitle(page.getTitle().replace(Data.textToFind, Data.textToReplace))

    }
}
