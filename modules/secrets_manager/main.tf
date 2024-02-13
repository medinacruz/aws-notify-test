resource "aws_secrets_manager_secret" "smtp_credentials" {
  name = var.secret_name

  tags = var.tags
}

# Optional: If planning to create more secrets, repeat similar structure
