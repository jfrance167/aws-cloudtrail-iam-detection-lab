variable "name_prefix" {
  description = "Short prefix for lab resources."
  type        = string
}

variable "kms_key_arn" {
  description = "KMS key used for SNS encryption."
  type        = string
  sensitive   = true
}

variable "log_group_name" {
  description = "CloudTrail CloudWatch Logs group name."
  type        = string
}

variable "sandbox_role_name" {
  description = "Exact sandbox role name used to scope denied-call detection."
  type        = string
}

variable "event_patterns" {
  description = "Map of rule names to EventBridge JSON patterns."
  type        = map(string)
}

variable "alert_email" {
  description = "Optional email endpoint; pass privately and never commit it."
  type        = string
  default     = null
  sensitive   = true

  validation {
    condition     = var.alert_email == null || can(regex("^[^@[:space:]]+@[^@[:space:]]+\\.[^@[:space:]]+$", var.alert_email))
    error_message = "alert_email must be null or a syntactically valid address."
  }
}

variable "denied_threshold" {
  description = "Number of denied calls in five minutes that raises the alarm."
  type        = number
  default     = 3

  validation {
    condition     = var.denied_threshold >= 2 && var.denied_threshold <= 20
    error_message = "denied_threshold must be between 2 and 20."
  }
}

variable "tags" {
  description = "Tags applied to supported resources."
  type        = map(string)
  default     = {}
}

