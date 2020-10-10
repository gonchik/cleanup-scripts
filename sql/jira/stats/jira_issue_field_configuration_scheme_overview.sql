-- Just representation of config Issue type scheme by project
SELECT ITS.id as "Issue Type Scheme",
       ITS.configname as "Issue Type Scheme name",
       IT.id as "Issue Type",
       IT.pname as "Issue Type name",
       CASE WHEN FCS.configname = 'Default Issue Type Scheme' THEN 0 ELSE CC.project END as "Project",
       CASE WHEN FCS.configname = 'Default Issue Type Scheme' THEN 'Global' ELSE P.pkey END as "Project Key",
       CASE WHEN FCS.configname = 'Default Issue Type Scheme' THEN 'Global' ELSE P.pname END as "Project Name"
FROM
	fieldconfigscheme ITS
	    LEFT JOIN optionconfiguration OC ON FCS.id = OC.fieldconfig
	    LEFT JOIN issuetype IT ON OC.optionid = IT.id
	    LEFT JOIN configurationcontext CC OC CC.fieldconfigscheme = FCS.id
	    LEFT JOIN project P ON P.id = CC.project
WHERE FCS.fieldid='issuetype';
