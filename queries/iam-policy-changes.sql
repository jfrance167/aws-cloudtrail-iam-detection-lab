SELECT
  eventtime,
  useridentity.arn AS principal_arn,
  sourceipaddress,
  eventname,
  json_extract_scalar(requestparameters, '$.userName') AS target_user,
  json_extract_scalar(requestparameters, '$.roleName') AS target_role,
  json_extract_scalar(requestparameters, '$.groupName') AS target_group,
  json_extract_scalar(requestparameters, '$.policyArn') AS policy_arn,
  errorcode
FROM "<ATHENA_DATABASE>"."<CLOUDTRAIL_TABLE>"
WHERE year = '<YYYY>' AND month = '<MM>' AND day = '<DD>'
  AND eventsource = 'iam.amazonaws.com'
  AND eventname IN (
    'AttachUserPolicy', 'AttachRolePolicy', 'AttachGroupPolicy',
    'DetachUserPolicy', 'DetachRolePolicy', 'DetachGroupPolicy',
    'PutUserPolicy', 'PutRolePolicy', 'PutGroupPolicy',
    'CreatePolicyVersion', 'SetDefaultPolicyVersion'
  )
ORDER BY from_iso8601_timestamp(eventtime);

