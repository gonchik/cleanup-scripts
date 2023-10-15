/*
    How to Fetch Page Information Containing Pagename, Url, Creator, Lastmodifiedby From the Confluence Database
    This article will help you to retrieve detailed Page information from your Confluence database.
    The below SQL queries will fetch the following Page information data:
    - PageName
    - Creator
    - CreationDate
    - LastModified Date
    - SpaceName
    - LastModifier Username
    - PageURL
    Note: Please replace the http:localhost:6720/c6720 value with your own base url value.
    Link: https://confluence.atlassian.com/confkb/how-to-fetch-page-information-containing-pagename-url-creator-lastmodifiedby-from-the-confluence-database-1047535924.html
 */

SELECT c.title                                                                            as PageName,
       u.username                                                                         AS Creator,
       c.creationdate,
       c.lastmoddate,
       s.Spacename,
       um.username                                                                        AS LastModifier,
       CONCAT('http:localhost:6720/c6720', '/pages/viewpage.action?pageId=', c.contentid) AS "Page URL"
FROM content c
         JOIN user_mapping u
              ON c.creator = u.user_key
         JOIN user_mapping um
              ON c.lastmodifier = um.user_key
         JOIN Spaces s
              on c.SpaceID = s.SpaceID
WHERE c.prevver IS NULL
  AND c.contenttype = 'PAGE'
  AND c.content_status = 'current'
ORDER BY s.spacename;