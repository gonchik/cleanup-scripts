import com.atlassian.jira.component.ComponentAccessor
import com.atlassian.mail.queue.MailQueue
import com.atlassian.jira.mail.SubscriptionSingleRecepientMailQueueItem
import com.atlassian.jira.web.action.admin.MailQueueAdmin
import com.atlassian.jira.notification.NotificationSchemeManager

import org.apache.log4j.Logger
import org.apache.log4j.Level


final def log = Logger.getLogger("com.gonchik.scripts.groovy.mail.queue")
log.setLevel(Level.DEBUG)

def mailQueue = ComponentAccessor.getMailQueue()
boolean checkIsSending = mailQueue.isSending()

def items = mailQueue.getQueue()
def errorQueue = mailQueue.getErrorQueue()
def errorItems = []
errorItems.addAll(errorQueue)
errorItems.each { item ->
    log.warn "$item.dateQueued - $item.subject"
}
// remove item from queue
mailQueue.emptyErrorQueue()
mailQueue.unstickQueue()

/*
items.each {
    item -> log.warn "$item.dateQueued - $item.subject"
}
*/

/*
for (def item in items) {
    if (!item.subject) {
        log.warn item
    }
    if (item instanceof SubscriptionSingleRecepientMailQueueItem){
        log.warn item
    }
    log.warn item
}

*/