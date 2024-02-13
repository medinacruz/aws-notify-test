# This assumes a simple table configuration, expand this config accordingly if more complex.

resource "aws_dynamodb_table" "sechub_table" {
  name         = var.name
  hash_key     = var.hash_key
  billing_mode = var.billing_mode

  dynamic "attribute" {
    for_each = var.attributes

    content {
      name = attribute.value.name
      type = attribute.value.type
    }
  }

  tags = var.tags
}
