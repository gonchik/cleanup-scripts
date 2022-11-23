boolean isPreview = false
// Find orphaned avatars and remove it
import com.atlassian.jira.component.ComponentAccessor
import com.atlassian.jira.avatar.AvatarService
import java.util.regex.Pattern
import org.apache.log4j.Logger
import org.apache.log4j.Level
import com.atlassian.jira.avatar.Avatar;
import com.atlassian.jira.avatar.AvatarManager
import com.atlassian.jira.user.ApplicationUser
import com.atlassian.jira.user.util.UserManager
import com.atlassian.jira.icon.IconType
import java.nio.file.Files
import java.nio.file.Paths

def log = Logger.getLogger("com.gonchik.scripts.groovy.cleanupUnAssociatedIssueType")
log.setLevel(Level.DEBUG)

def sb = new StringBuilder()

if (isPreview) {
    sb.append("<b>Please, note it works as preview. For execute change variable isPreview = true </b><br/><br/>\n")
} else {
    sb.append("<b>Please, note it works in execute mode</b><br/><br/>\n")
}
AvatarService avatarService = ComponentAccessor.getAvatarService()

Set<Avatar> orphanedAvatars = findOrphanedAvatars();
for (it in orphanedAvatars) {
    def orphanedAvatar = it
    log.info("Remove Avatar with ID ${orphanedAvatar.getId()}");
    ComponentAccessor.getAvatarManager().delete(orphanedAvatar.getId(), true);
}



return sb.toString()



private final Set<Avatar> findOrphanedAvatars() {
    boolean removeForInactiveUsers = false
    AvatarManager avatarManager = ComponentAccessor.getAvatarManager();
    Pattern PATTERN = Pattern.compile("\\d+_(.*?)");
    Set<Avatar> orphanedAvatars = new HashSet() as Set<Avatar>;
    File avatarsDirectory = avatarManager.getAvatarBaseDirectory();
    File[] storedAvatarFiles = avatarsDirectory.listFiles();
    if (storedAvatarFiles == null) {
        return orphanedAvatars;
    } else {
        File[] var4 = storedAvatarFiles;
        int var5 = storedAvatarFiles.length;

        for (int var6 = 0; var6 < var5; ++var6) {
            File storedAvatarFile = var4[var6];
            String storedAvatarFileName = storedAvatarFile.getName();
            if (PATTERN.matcher(storedAvatarFileName).matches()) {
                long id = Long.parseLong(storedAvatarFileName.split("_")[0]);
                Avatar avatar = avatarManager.getById(id);
                if (avatar == null) {
                    log.debug("Avatar with ID ${id} was not found. File ${storedAvatarFileName} is removed immediately.");
                    try {
                        Files.delete(storedAvatarFile.toPath());
                    } catch (IOException ex) {
                        log.error("An error occurred while deleting the file ${storedAvatarFileName}: ${ex.getMessage()}");
                    }
                } else if (!orphanedAvatars.contains(avatar) && avatar.getIconType().toString().equals(IconType.USER_ICON_TYPE.toString())) {
                    String ownerKey = avatar.getOwner();
                    ApplicationUser owner = ComponentAccessor.userManager.getUserByKey(ownerKey);
                    if (owner == null) {
                        log.debug("User with the user key ${ownerKey} was not found. Avatar ${id} is orphaned and marked for removal.");
                        orphanedAvatars.add(avatar);
                    } else if (!owner.isActive() && removeForInactiveUsers) {
                        log.debug("User with the user key ${ownerKey} is inactive. Avatar ${id} marked for removal.");
                        orphanedAvatars.add(avatar);
                    }
                }
            }
        }

        return orphanedAvatars;
    }
}