# Real-provider plan only: synthetic credentials, no API identity lookups or apply.
provider "aws" {
  region                      = "us-east-1"
  access_key                  = "offline-test"
  secret_key                  = "offline-test"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true
  shared_config_files         = []
  shared_credentials_files    = []
  endpoints {
    sts = "http://127.0.0.1:1"
  }
}
variables {
  sandbox_trusted_principal_arn = "arn:aws:iam::123456789012:role/synthetic-reviewer"
  alert_email                   = null
}
override_data {
  target = module.logging.data.aws_caller_identity.current
  values = {
    account_id = "123456789012"
    arn        = "arn:aws:iam::123456789012:root"
    user_id    = "synthetic"
  }
}
override_data {
  target = module.detections.data.aws_caller_identity.current
  values = {
    account_id = "123456789012"
    arn        = "arn:aws:iam::123456789012:root"
    user_id    = "synthetic"
  }
}
override_data {
  target = module.athena.data.aws_caller_identity.current
  values = {
    account_id = "123456789012"
    arn        = "arn:aws:iam::123456789012:root"
    user_id    = "synthetic"
  }
}
override_data {
  target = module.logging.data.aws_partition.current
  values = {
    partition  = "aws"
    dns_suffix = "amazonaws.com"
  }
}
override_data {
  target = module.detections.data.aws_partition.current
  values = {
    partition  = "aws"
    dns_suffix = "amazonaws.com"
  }
}
override_data {
  target = module.logging.data.aws_region.current
  values = {
    region = "us-east-1"
  }
}
override_data {
  target = module.athena.data.aws_region.current
  values = {
    region = "us-east-1"
  }
}
run "provider_v6_plan" {
  command = plan
  plan_options {
    refresh = false
  }
  assert {
    condition     = output.trail_name == "aws-detection-lab-trail"
    error_message = "The logging trail name changed."
  }
  assert {
    condition     = output.cloudwatch_log_group_name == "/aws/cloudtrail/aws-detection-lab"
    error_message = "The logging destination changed."
  }
  assert {
    condition     = var.force_destroy == false && var.require_mfa == true
    error_message = "Safe lab defaults changed."
  }
}

