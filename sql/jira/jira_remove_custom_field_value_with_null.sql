-- https://confluence.atlassian.com/jirakb/nullpointerexception-when-deleting-a-custom-field-218272042.html
delete from customfieldvalue where issue is null;