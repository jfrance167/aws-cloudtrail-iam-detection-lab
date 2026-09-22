variable "name_prefix" {
  description = "Short prefix for lab resources."
  type        = string

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{2,30}$", var.name_prefix))
    error_message = "name_prefix must be 3-31 lowercase letters, digits, or hyphens."
  }
}

variable "cloudwatch_retention_days" {
  description = "CloudWatch Logs retention in days."
  type        = number
  default     = 14

  validation {
    condition     = contains([1, 3, 5, 7, 14, 30, 60, 90], var.cloudwatch_retention_days)
    error_message = "Use an AWS-supported short retention value."
  }
}

variable "archive_retention_days" {
  description = "Days before archived CloudTrail objects expire."
  type        = number
  default     = 90

  validation {
    condition     = var.archive_retention_days >= 30 && var.archive_retention_days <= 365
    error_message = "archive_retention_days must be between 30 and 365."
  }
}

variable "kms_deletion_window_days" {
  description = "KMS deletion waiting period."
  type        = number
  default     = 14

  validation {
    condition     = var.kms_deletion_window_days >= 7 && var.kms_deletion_window_days <= 30
    error_message = "KMS deletion window must be 7-30 days."
  }
}

variable "force_destroy" {
  description = "Whether Terraform may delete non-empty evidence buckets."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags applied to supported resources."
  type        = map(string)
  default     = {}
}

