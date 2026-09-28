cleanup-scripts
---------------

Scripts for cleanup Atlassian Jira & Confluence (Groovy, Python and SQL).
I hope these scripts will help you do a continuous cleanup. 

Reference:
https://confluence.atlassian.com/adminjiraserver/project-screens-schemes-and-fields-938847220.html

Usage
-----
Most of the scripts have a variable `isPreview` on top. 
Don't forget to change the boolean value to execute.

branch: 
`master` - is for Jira 8.x releases
`jira-9` - is for Jira 9.x releases
`jira-7` related to Jira 7.x releases.

Development
-----------

Feel free to provide a PR for any situation - improvements, new feature, docs, typo etc.
As it's licensed with Apache 2.0 rights, feel modify and reuse how do you want. 

Additional 
-----------
Tool for check if your Jira instance is affected by the bug JRA-47568 and should be used in conjunction with the SSLPoke tool.
    https://bitbucket.org/atlassianlabs/httpclienttest/src

You can use for groovy runner - Scriptrunner, Mercury for Jira, MyGroovy, Insight, JMWE

macOS laptop cleanup (`sh/macos`)
---------------------------------
All scripts are bash 3.2 compatible (the macOS default) and print `--help`.
Destructive scripts support `-n/--dry-run` and list everything before deleting: run with `-n` first.

| Script | What it does |
|---|---|
| `find_uninstalled_apps.sh` | Read-only report: leftovers of removed apps, orphan prefs, launch agents/daemons whose program is gone. |
| `brew_audit.sh` | Homebrew report: outdated, orphaned deps, unlinked kegs, largest formulae/casks, `brew doctor`. `--fix` runs upgrade/autoremove/cleanup interactively. |
| `zsh_macos_cleanup.sh` | Dev cleanup: brew/gem, DerivedData, simulators, IDE logs, caches > 7 days, Trash, DNS. Opt-in: `--deep` (Xcode Archives, DeviceSupport, Gradle/npm/pip caches), `--rust`, `--uninstall-android-studio`, `--reset-password-history`. Reports other big folders at the end. |
| `logs_reviewer.sh` | Finds logs/crash reports, truncates logs of running processes, deletes the rest. `-a` full list, `-d DAYS` age filter, `-s` system dirs only, `-y` no prompt. |
| `cleanup_logs.sh` | Shortcut for `logs_reviewer.sh --system-only`; `./cleanup_logs.sh 7` = only logs older than 7 days. |
| `remove_app_leftovers.sh <App or BundleID>` | Deletes leftovers of one app (whole-word match, `--fuzzy` for substring), incl. `/Library` launch daemons and helper tools. |
| `global_protect_remover.sh` | Full GlobalProtect VPN removal (vendor uninstaller + leftovers + network state). |
| `yandex_browser_remover.sh` | Removes Yandex Browser only (other Yandex apps are kept). |
| `zsh_macos_cleanup_account_data.sh` | Clears `accountPolicyData` password history for all regular users (slow-login fix). |

Suggested order:
```
cd sh/macos
./find_uninstalled_apps.sh                      # what's left from removed apps
./brew_audit.sh                                 # Homebrew state
./zsh_macos_cleanup.sh -n && ./zsh_macos_cleanup.sh
./logs_reviewer.sh -n && ./logs_reviewer.sh
```
Give your terminal *Full Disk Access* (System Settings → Privacy & Security) so it can read `~/.Trash` and app containers.
