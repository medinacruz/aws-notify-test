module "iam_roles" {
  source       = "./modules/iam_roles"

  tags = var.project_tags
}


module "s3_buckets" {
  source       = "./modules/s3_buckets"

  bucket_name           = "AWS-Platform-SecHubReports-${random_id.suffix.hex}"
  bucket_lifecycle_days = "default"

  tags = merge(
    var.project_tags,
    {
    Purpose             = "SecHubAccountFindings"
    },
  )
}


module "dynamodb_sechub" {
  source                 = "./modules/dynamodb"

  name                   = "AWSPlatform-AccountVulnerabilities"
  hash_key               = "VulnerabilityID"
  billing_mode           = "default"
  attributes             = [
    {
      name = "VulnerabilityID"
      type = "S"
    }
  ]

  tags = merge(
    var.project_tags,
    {
    Purpose             = "SecHubAccountFindings"
    }
  )
}


module "secrets_manager" {
  source           = "./modules/secrets_manager"

  secret_name = "SecHubEmailSMTPCredentials"

  tags = merge(
    var.project_tags,
    {
    Source = "azure"
    }
  )
}


module "lambda_function_report" {
  source = "./modules/lambda/sechub_report"

  function_name    = "AWS-Platform-SecHubReport"
  runtime          = "default"
  handler          = "default"
  memory_size      = "default"
  timeout          = "default"
  lambda_file_path = "default"        # < needs input, empty var
  s3_bucket_name   = module.s3_buckets.sechub_report_bucket_name
  lambda_role_arn  = module.iam_roles.sechub_report_role_arn

  tags = var.project_tags
}


module "lambda_function_dynamo" {
  source = "./modules/lambda/sechub_dynamo"

  function_name       = "AWS-Platform-SecHubDynamo"
  runtime             = "default"
  handler             = "default"
  memory_size         = "default"
  timeout             = "default"
  lambda_file_path    = "default"        # < needs input, empty var
  lambda_role_arn     = module.iam_roles.sechub_dynamo_role_arn
  dynamodb_table_name = module.dynamodb.dynamodb_table_name

  tags = var.project_tags
}

module "lambda_function_email" {
  source = "./modules/lambda/sechub_email"

  function_name             = "AWS-Platform-SecHubEmail"
  runtime                   = "default"
  handler                   = "default"
  memory_size               = "default"
  timeout                   = "default"
  lambda_file_path          = "default"        # < needs input, empty var
  lambda_role_arn           = module.iam_roles.sechub_email_role_arn
  secrets_manager_secret_id = module.secrets_manager.smtp_credentials_secret_name

  tags = var.project_tags
}
