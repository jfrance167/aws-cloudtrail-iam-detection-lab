SELECT
  eventtime,
  useridentity.arn AS principal_arn,
  sourceipaddress,
  eventname,
  requestparameters,
  errorcode,
  errormessage
FROM "<ATHENA_DATABASE>"."<CLOUDTRAIL_TABLE>"
WHERE year = '<YYYY>' AND month = '<MM>' AND day = '<DD>'
  AND eventsource = 'cloudtrail.amazonaws.com'
  AND eventname IN (
    'StopLogging', 'StartLogging', 'DeleteTrail', 'CreateTrail', 'UpdateTrail',
    'PutEventSelectors', 'PutInsightSelectors',
    'DeleteEventDataStore', 'UpdateEventDataStore'
  )
ORDER BY from_iso8601_timestamp(eventtime);

