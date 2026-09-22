locals {
  common_tags = {
    Project     = "aws-cloudtrail-iam-detection-lab"
    Environment = "educational-sandbox"
    ManagedBy   = "terraform"
    DataClass   = "sanitized-lab-evidence"
  }

  event_patterns = {
    root-activity = file("${path.root}/../../../detections/event-patterns/root-account-activity.json")
    trail-change  = file("${path.root}/../../../detections/event-patterns/cloudtrail-configuration-change.json")
    access-key    = file("${path.root}/../../../detections/event-patterns/access-key-created.json")
    admin-policy  = file("${path.root}/../../../detections/event-patterns/privileged-policy-attached.json")
  }
}

module "logging" {
  source = "../../modules/logging"

  name_prefix               = var.name_prefix
  cloudwatch_retention_days = var.cloudwatch_retention_days
  archive_retention_days    = var.archive_retention_days
  force_destroy             = var.force_destroy
  tags                      = local.common_tags
}

module "sandbox_iam" {
  source = "../../modules/sandbox-iam"

  name_prefix           = var.name_prefix
  trusted_principal_arn = var.sandbox_trusted_principal_arn
  require_mfa           = var.require_mfa
  archive_bucket_arn    = module.logging.archive_bucket_arn
  tags                  = local.common_tags
}

module "detections" {
  source = "../../modules/detections"

  name_prefix       = var.name_prefix
  kms_key_arn       = module.logging.kms_key_arn
  log_group_name    = module.logging.log_group_name
  sandbox_role_name = module.sandbox_iam.role_name
  event_patterns    = local.event_patterns
  alert_email       = var.alert_email
  tags              = local.common_tags
}

module "athena" {
  source = "../../modules/athena"

  name_prefix       = var.name_prefix
  archive_bucket_id = module.logging.archive_bucket_id
  kms_key_arn       = module.logging.kms_key_arn
  force_destroy     = var.force_destroy
  tags              = local.common_tags
}

resource "aws_budgets_budget" "lab" {
  name         = "${var.name_prefix}-monthly-cost"
  budget_type  = "COST"
  limit_amount = tostring(var.monthly_budget_usd)
  limit_unit   = "USD"
  time_unit    = "MONTHLY"

  cost_types {
    include_credit             = true
    include_discount           = true
    include_other_subscription = true
    include_recurring          = true
    include_refund             = true
    include_subscription       = true
    include_support            = true
    include_tax                = true
    include_upfront            = true
    use_amortized              = false
    use_blended                = false
  }

  notification {
    comparison_operator       = "GREATER_THAN"
    threshold                 = 50
    threshold_type            = "PERCENTAGE"
    notification_type         = "ACTUAL"
    subscriber_sns_topic_arns = [module.detections.topic_arn]
  }

  notification {
    comparison_operator       = "GREATER_THAN"
    threshold                 = 80
    threshold_type            = "PERCENTAGE"
    notification_type         = "FORECASTED"
    subscriber_sns_topic_arns = [module.detections.topic_arn]
  }

  notification {
    comparison_operator       = "GREATER_THAN"
    threshold                 = 100
    threshold_type            = "PERCENTAGE"
    notification_type         = "ACTUAL"
    subscriber_sns_topic_arns = [module.detections.topic_arn]
  }
}

