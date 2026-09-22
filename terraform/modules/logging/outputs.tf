output "archive_bucket_id" {
  description = "CloudTrail archive bucket ID for module wiring."
  value       = aws_s3_bucket.archive.id
  sensitive   = true
}

output "archive_bucket_arn" {
  description = "CloudTrail archive bucket ARN for module wiring."
  value       = aws_s3_bucket.archive.arn
  sensitive   = true
}

output "kms_key_arn" {
  description = "Lab KMS key ARN for module wiring."
  value       = aws_kms_key.lab.arn
  sensitive   = true
}

output "log_group_name" {
  description = "CloudWatch Logs group name."
  value       = aws_cloudwatch_log_group.cloudtrail.name
}

output "trail_name" {
  description = "CloudTrail trail name."
  value       = aws_cloudtrail.lab.name
}

output "trail_arn" {
  description = "Trail ARN for internal policy wiring."
  value       = aws_cloudtrail.lab.arn
  sensitive   = true
}

