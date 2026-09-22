data "aws_caller_identity" "current" {}
data "aws_partition" "current" {}

resource "aws_sns_topic" "alerts" {
  name              = "${var.name_prefix}-alerts"
  kms_master_key_id = var.kms_key_arn
  tags              = var.tags
}

data "aws_iam_policy_document" "alerts" {
  statement {
    sid     = "AllowTopicOwner"
    effect  = "Allow"
    actions = ["sns:*"]
    principals {
      type        = "AWS"
      identifiers = ["arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
    resources = [aws_sns_topic.alerts.arn]
  }

  statement {
    sid    = "AllowAWSDetectionPublishers"
    effect = "Allow"
    actions = [
      "sns:Publish"
    ]
    principals {
      type = "Service"
      identifiers = [
        "budgets.amazonaws.com",
        "cloudwatch.amazonaws.com",
        "events.amazonaws.com"
      ]
    }
    resources = [aws_sns_topic.alerts.arn]
    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [data.aws_caller_identity.current.account_id]
    }
  }
}

resource "aws_sns_topic_policy" "alerts" {
  arn    = aws_sns_topic.alerts.arn
  policy = data.aws_iam_policy_document.alerts.json
}

resource "aws_sns_topic_subscription" "email" {
  count     = var.alert_email == null ? 0 : 1
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email
}

resource "aws_cloudwatch_event_rule" "detection" {
  for_each      = var.event_patterns
  name          = "${var.name_prefix}-${each.key}"
  description   = "Educational detection rule ${each.key}"
  event_pattern = each.value
  tags          = var.tags
}

resource "aws_cloudwatch_event_target" "sns" {
  for_each = aws_cloudwatch_event_rule.detection
  rule     = each.value.name
  arn      = aws_sns_topic.alerts.arn

  retry_policy {
    maximum_event_age_in_seconds = 3600
    maximum_retry_attempts       = 3
  }

  depends_on = [aws_sns_topic_policy.alerts]
}

resource "aws_cloudwatch_log_metric_filter" "sandbox_denied" {
  name           = "${var.name_prefix}-sandbox-access-denied"
  log_group_name = var.log_group_name
  pattern        = "{ (($.errorCode = \"*AccessDenied*\") || ($.errorCode = \"UnauthorizedOperation\")) && ($.userIdentity.sessionContext.sessionIssuer.userName = \"${var.sandbox_role_name}\") }"

  metric_transformation {
    name          = "SandboxAccessDenied"
    namespace     = "SecurityLab/${var.name_prefix}"
    value         = "1"
    default_value = "0"
    unit          = "Count"
  }
}

resource "aws_cloudwatch_metric_alarm" "sandbox_denied" {
  alarm_name          = "${var.name_prefix}-repeated-access-denied"
  alarm_description   = "AWS-CT-005: repeated denied API calls from the sandbox role"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  threshold           = var.denied_threshold
  period              = 300
  statistic           = "Sum"
  namespace           = "SecurityLab/${var.name_prefix}"
  metric_name         = "SandboxAccessDenied"
  treat_missing_data  = "notBreaching"
  alarm_actions       = [aws_sns_topic.alerts.arn]
  ok_actions          = [aws_sns_topic.alerts.arn]
  tags                = var.tags

  depends_on = [aws_sns_topic_policy.alerts]
}

