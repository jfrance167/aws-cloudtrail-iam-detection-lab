output "trail_name" {
  description = "CloudTrail trail name."
  value       = module.logging.trail_name
}

output "cloudwatch_log_group_name" {
  description = "CloudWatch Logs group name."
  value       = module.logging.log_group_name
}

output "sandbox_role_name" {
  description = "Restricted sandbox role name."
  value       = module.sandbox_iam.role_name
}

output "alert_topic_name" {
  description = "SNS alert topic name."
  value       = module.detections.topic_name
}

output "athena_workgroup_name" {
  description = "Athena investigation workgroup."
  value       = module.athena.workgroup_name
}

output "athena_database_and_table" {
  description = "Sanitized-friendly Athena catalog identifiers."
  value       = "${module.athena.database_name}.${module.athena.table_name}"
}

