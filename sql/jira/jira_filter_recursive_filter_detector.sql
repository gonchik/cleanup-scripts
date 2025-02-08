-- Detector of recursive requests if customer use the Scriptrunner
SELECT *
FROM searchrequest
WHERE reqcontent like '%linkedIssuesOfRecursive%';