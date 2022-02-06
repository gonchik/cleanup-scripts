/*
    Changing Database Collation/Ctype to UTF-8 breaks pretty links
    Purpose: after fixing collation on PostgreSQL breaks links

    Confluence database collation/ctype should be set to UTF-8.
    If Confluence resides on a database with an ASCII (C) collation/ctype
    we advise that this is changed to UTF-8,
    as described in: How to fix the collation of a Postgres Confluence database
    There is however a potential problem for instances using a non-Latin characters
    that have capitalisations, such as Cyrillic or Greek,
    that may manifest in ways such as pretty links being broken.
    The cause is that an ASCII (C) ctype, will ignore non-Latin characters,
    as it won't know how to treat them. That means that character manipulation functions,
    such as those used to change capitalisation, won't be applied to them.
    Confluence relies on those functions to populate the lower* columns in its database.
    Such lowertitle in CONTENT, or lowerspacekey in SPACES.
    As a result of the failure to apply those functions, when using non-ASCII characters,
    the columns will be populated by the values as provided, including capitalisations.

    link: https://confluence.atlassian.com/confkb/changing-database-collation-ctype-to-utf-8-breaks-pretty-links-1086419517.html
*/
update content set lowertitle=lower(lowertitle);
