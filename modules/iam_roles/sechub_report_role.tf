resource "aws_iam_role" "sechub_report" {
  name = "SecHubReportLambdaRole"

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

resource "aws_iam_role_policy_attachment" "sechub_report_basic_execution" {
  role       = aws_iam_role.sechub_report.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "sechub_report_organizations_access" {
  role       = aws_iam_role.sechub_report.name
  policy_arn = "arn:aws:iam::aws:policy/AWSOrganizationsReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "sechub_report_securityhub_access" {
  role       = aws_iam_role.sechub_report.name
  policy_arn = "arn:aws:iam::aws:policy/AWSSecurityHubReadOnlyAccess"
}

# Attach cusotm policies

data "aws_iam_policy_document" "sechub_report_custom_policy_doc" {
  statement {
    actions = [
      "s3:ListBucket",
      "s3:CreateBucket*",
      "s3:CreateObject*",
      "s3:PutObject*",
    ]
    resources = [
    "arn:aws:s3:::SecHubReportBucket",
    "arn:aws:s3:::SecHubreportBucket/*",
    ]
    effect = "Allow"
  }
}

resource "aws_iam_policy" "sechub_report_custom" {
  name   = "SecHubReportCustomPolicy"
  policy = data.aws_iam_policy_document.sechub_report_custom_policy_doc.json
}

resource "aws_iam_role_policy_attachment" "sechub_report_custom_attach" {
  role       = aws_iam_role.sechub_report.name
  policy_arn = aws_iam_policy.sechub_report_custom.arn
}
