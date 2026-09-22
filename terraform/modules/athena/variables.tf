variable "name_prefix" {
  description = "Short prefix for lab resources."
  type        = string
}

variable "archive_bucket_id" {
  description = "CloudTrail archive bucket ID."
  type        = string
  sensitive   = true
}

variable "kms_key_arn" {
  description = "KMS key for Athena result encryption."
  type        = string
  sensitive   = true
}

variable "query_result_retention_days" {
  description = "Days before Athena query results expire."
  type        = number
  default     = 30
}

variable "bytes_scanned_cutoff" {
  description = "Maximum bytes scanned by one Athena query."
  type        = number
  default     = 104857600

  validation {
    condition     = var.bytes_scanned_cutoff >= 10485760 && var.bytes_scanned_cutoff <= 1073741824
    error_message = "Use an Athena cutoff between 10 MiB and 1 GiB."
  }
}

variable "force_destroy" {
  description = "Whether Terraform may delete a non-empty result bucket."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags applied to supported resources."
  type        = map(string)
  default     = {}
}

