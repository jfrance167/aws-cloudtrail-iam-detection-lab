variable "name_prefix" {
  description = "Short prefix for lab resources."
  type        = string
}

variable "trusted_principal_arn" {
  description = "ARN of the dedicated operator identity allowed to assume the sandbox role."
  type        = string

  validation {
    condition     = can(regex("^arn:[^:]+:iam::[0-9]{12}:(user|role)/.+$", var.trusted_principal_arn))
    error_message = "Use an IAM user or role ARN supplied privately at deployment time."
  }
}

variable "require_mfa" {
  description = "Require MFA when the trusted principal assumes this role."
  type        = bool
  default     = true
}

variable "archive_bucket_arn" {
  description = "Archive bucket ARN used for a harmless GetBucketLocation call."
  type        = string
  sensitive   = true
}

variable "tags" {
  description = "Tags applied to supported resources."
  type        = map(string)
  default     = {}
}

