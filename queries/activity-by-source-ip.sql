SELECT
  eventtime,
  useridentity.arn AS principal_arn,
  eventsource,
  eventname,
  errorcode
FROM "<ATHENA_DATABASE>"."<CLOUDTRAIL_TABLE>"
WHERE year = '<YYYY>' AND month = '<MM>' AND day = '<DD>'
  AND sourceipaddress = '<SOURCE_IP>'
ORDER BY from_iso8601_timestamp(eventtime);

