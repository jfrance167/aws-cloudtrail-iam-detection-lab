SELECT
  eventtime,
  useridentity.arn AS principal_arn,
  sourceipaddress,
  eventname,
  json_extract_scalar(requestparameters, '$.userName') AS target_user,
  errorcode
FROM "<ATHENA_DATABASE>"."<CLOUDTRAIL_TABLE>"
WHERE year = '<YYYY>' AND month = '<MM>' AND day = '<DD>'
  AND eventsource = 'iam.amazonaws.com'
  AND eventname IN (
    'CreateAccessKey', 'UpdateAccessKey', 'DeleteAccessKey',
    'GetAccessKeyLastUsed'
  )
ORDER BY from_iso8601_timestamp(eventtime);

