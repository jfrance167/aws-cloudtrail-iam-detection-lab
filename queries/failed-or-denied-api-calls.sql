SELECT
  eventtime,
  useridentity.arn AS principal_arn,
  sourceipaddress,
  eventsource,
  eventname,
  errorcode,
  errormessage
FROM "<ATHENA_DATABASE>"."<CLOUDTRAIL_TABLE>"
WHERE year = '<YYYY>' AND month = '<MM>' AND day = '<DD>'
  AND (
    errorcode LIKE '%AccessDenied%'
    OR errorcode = 'UnauthorizedOperation'
    OR errorcode IS NOT NULL
  )
ORDER BY from_iso8601_timestamp(eventtime);

