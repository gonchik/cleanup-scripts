-- Remove empty MESSAGEID rows
DELETE FROM notificationinstance
where messageid like '';