resource "aws_iam_role" "sechub_dynamo" {
  name = "SecHubDynamoLambdaRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
      }],
  })

  tags = var.tags
}

# Attach the AWS Managed Policies

resource "aws_iam_role_policy_attachment" "sechub_dynamo_basic_execution" {
  role       = aws_iam_role.sechub_dynamo.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "sechub_dynamo_organizations_access" {
  role       = aws_iam_role.sechub_dynamo.name
  policy_arn = "arn:aws:iam::aws:policy/AWSOrganizationsReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "sechub_dynamo_securityhub_access" {
  role       = aws_iam_role.sechub_dynamo.name
  policy_arn = "arn:aws:iam::aws:policy/AWSSecurityHubReadOnlyAccess"
}

# Attach Cusotm Policies

data "aws_iam_policy_document" "sechub_dynamo_custom_policy_doc" {
  statement {
    actions = [
      "dynamodb:*"
    ]
    resources = [
    "arn:aws:dynamodb:*:*:table/AWSPlatform-AccountVulnerabilities"
    ]
    effect = "Allow"
  }
}

resource "aws_iam_policy" "sechub_dynamo_custom" {
  name   = "SecHubDynamoCustomPolicy"
  policy = data.aws_iam_policy_document.sechub_dynamo_custom_policy_doc.json
}

resource "aws_iam_role_policy_attachment" "sechub_dynamo_custom_attach" {
  role       = aws_iam_role.sechub_dynamo.name
  policy_arn = aws_iam_policy.sechub_dynamo_custom.arn
}
