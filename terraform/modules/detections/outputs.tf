output "topic_arn" {
  description = "Alert topic ARN for internal module wiring."
  value       = aws_sns_topic.alerts.arn
  sensitive   = true
}

output "topic_name" {
  description = "Alert topic name."
  value       = aws_sns_topic.alerts.name
}

