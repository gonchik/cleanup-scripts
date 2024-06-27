select request."NAME",
       fields."FIELD_ID" as "custom_field",
       fields."LABEL"    as "field_portal_name",
       fields."REQUIRED"
from "AO_54307E_VIEWPORT" request
         join "AO_54307E_VIEWPORTFIELD" fields on fields."FORM_ID" = request."ID"
order by 1, 3
;