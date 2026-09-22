data "aws_iam_policy_document" "assume" {
  statement {
    sid     = "AllowDedicatedOperator"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "AWS"
      identifiers = [var.trusted_principal_arn]
    }

    dynamic "condition" {
      for_each = var.require_mfa ? [1] : []
      content {
        test     = "Bool"
        variable = "aws:MultiFactorAuthPresent"
        values   = ["true"]
      }
    }
  }
}

resource "aws_iam_role" "sandbox" {
  name                 = "${var.name_prefix}-sandbox"
  description          = "Restricted educational role for harmless CloudTrail activity"
  assume_role_policy   = data.aws_iam_policy_document.assume.json
  max_session_duration = 3600
  tags                 = var.tags
}

data "aws_iam_policy_document" "sandbox" {
  statement {
    sid    = "ReadOnlySelfInspection"
    effect = "Allow"
    actions = [
      "iam:GetRole",
      "iam:ListAttachedRolePolicies",
      "iam:ListRolePolicies"
    ]
    resources = [aws_iam_role.sandbox.arn]
  }

  statement {
    sid       = "ReadArchiveLocation"
    effect    = "Allow"
    actions   = ["s3:GetBucketLocation"]
    resources = [var.archive_bucket_arn]
  }

  # LookupEvents does not support resource-level permissions.
  statement {
    sid       = "LookupRecentEvents"
    effect    = "Allow"
    actions   = ["cloudtrail:LookupEvents"]
    resources = ["*"]
  }

  # Explicit deny is defense in depth and does not grant permissions.
  statement {
    sid    = "DenyUnsafeLabActions"
    effect = "Deny"
    actions = [
      "cloudtrail:DeleteTrail",
      "cloudtrail:PutEventSelectors",
      "cloudtrail:StopLogging",
      "cloudtrail:UpdateTrail",
      "iam:AttachGroupPolicy",
      "iam:AttachRolePolicy",
      "iam:AttachUserPolicy",
      "iam:CreateAccessKey",
      "iam:CreatePolicyVersion",
      "iam:PutGroupPolicy",
      "iam:PutRolePolicy",
      "iam:PutUserPolicy",
      "iam:SetDefaultPolicyVersion"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "sandbox" {
  name   = "${var.name_prefix}-sandbox-guardrails"
  role   = aws_iam_role.sandbox.id
  policy = data.aws_iam_policy_document.sandbox.json
}

