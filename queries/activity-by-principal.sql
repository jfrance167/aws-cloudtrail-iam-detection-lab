SELECT
  eventtime,
  eventsource,
  eventname,
  sourceipaddress,
  errorcode,
  useridentity.arn AS principal_arn
FROM "<ATHENA_DATABASE>"."<CLOUDTRAIL_TABLE>"
WHERE year = '<YYYY>' AND month = '<MM>' AND day = '<DD>'
  AND useridentity.arn = '<PRINCIPAL_ARN>'
ORDER BY from_iso8601_timestamp(eventtime);

