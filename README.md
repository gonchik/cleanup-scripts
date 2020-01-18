cleanup-scripts
---------------

Scripts for cleanup Atlassian Jira (Groovy, Python and SQL).
I hope these scripts will help you do a continuous cleanup. 

Reference:
https://confluence.atlassian.com/adminjiraserver/project-screens-schemes-and-fields-938847220.html

Usage
-----
Most of scripts have a variable `isPreview` on top. 
Don't forget to change the boolean value to execute.

Development
-----------

Feel free to provide a PR for any situation - improvements, new feature, docs, typo etc.
As it's licensed with MIT rights, feel modify and reuse how do you want. 

Additional 
-----------
Tool for check if your Jira instance is affected by the bug JRA-47568 and should be used in conjunction with the SSLPoke tool.
    https://bitbucket.org/atlassianlabs/httpclienttest/src