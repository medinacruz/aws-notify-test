resource "aws_iam_role" "sechub_email" {
  name = "SecHubEmailLambdaRole"

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

resource "aws_iam_role_policy_attachment" "sechub_email_basic_execution" {
  role       = aws_iam_role.sechub_email.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "sechub_email_dynamodb_read" {
  role       = aws_iam_role.sechub_email.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBReadOnlyAccess"
}

# Attach Cusotm Policies

data "aws_iam_policy_document" "sechub_email_custom_policy_doc" {
  statement {
    actions = [
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret",
    ]
    resources = [
    "arn:aws:secretsmanager:*:*:secret:SecHubEmailSMTPCredentials"
    ]
    effect = "Allow"
  }
}

resource "aws_iam_policy" "sechub_email_custom" {
  name   = "SecHubEmailCustomPolicy"
  policy = data.aws_iam_policy_document.sechub_email_custom_policy_doc.json
}

resource "aws_iam_role_policy_attachment" "sechub_email_custom_attach" {
  role       = aws_iam_role.sechub_email.name
  policy_arn = aws_iam_policy.sechub_email_custom.arn
}
