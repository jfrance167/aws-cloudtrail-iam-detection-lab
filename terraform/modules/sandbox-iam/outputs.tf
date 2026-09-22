output "role_name" {
  description = "Restricted sandbox role name."
  value       = aws_iam_role.sandbox.name
}

output "role_arn" {
  description = "Restricted sandbox role ARN; sensitive because it embeds the account ID."
  value       = aws_iam_role.sandbox.arn
  sensitive   = true
}

