variable "aws_region" {
  description = "Single home Region for regional lab resources."
  type        = string
  default     = "us-east-1"
}

variable "name_prefix" {
  description = "Short globally recognizable resource prefix."
  type        = string
  default     = "aws-detection-lab"
}

variable "sandbox_trusted_principal_arn" {
  description = "Private ARN of the dedicated IAM user or role allowed to assume the sandbox role."
  type        = string
  sensitive   = true
}

variable "require_mfa" {
  description = "Require MFA when assuming the sandbox role. Keep true for IAM users."
  type        = bool
  default     = true
}

variable "alert_email" {
  description = "Optional SNS email endpoint. Supply privately with TF_VAR_alert_email."
  type        = string
  default     = null
  sensitive   = true
}

variable "monthly_budget_usd" {
  description = "Monthly lab budget in USD."
  type        = number
  default     = 5

  validation {
    condition     = var.monthly_budget_usd >= 1 && var.monthly_budget_usd <= 25
    error_message = "Use a deliberately small budget between 1 and 25 USD."
  }
}

variable "cloudwatch_retention_days" {
  description = "CloudWatch Logs retention."
  type        = number
  default     = 14
}

variable "archive_retention_days" {
  description = "CloudTrail archive retention."
  type        = number
  default     = 90
}

variable "force_destroy" {
  description = "Permit Terraform to remove non-empty evidence buckets."
  type        = bool
  default     = false
}

