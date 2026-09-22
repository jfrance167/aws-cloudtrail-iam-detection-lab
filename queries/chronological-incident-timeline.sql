SELECT
  eventtime,
  useridentity.arn AS principal_arn,
  sourceipaddress,
  awsregion,
  eventsource,
  eventname,
  errorcode,
  requestparameters
FROM "<ATHENA_DATABASE>"."<CLOUDTRAIL_TABLE>"
WHERE year = '<YYYY>' AND month = '<MM>' AND day = '<DD>'
  AND from_iso8601_timestamp(eventtime)
      BETWEEN from_iso8601_timestamp('<START_TIME_ISO8601>')
          AND from_iso8601_timestamp('<END_TIME_ISO8601>')
  AND (
    useridentity.arn = '<PRINCIPAL_ARN>'
    OR sourceipaddress = '<SOURCE_IP>'
  )
ORDER BY from_iso8601_timestamp(eventtime);

