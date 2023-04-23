resource "aws_dynamodb_table" "matching_table" {
  name         = "${local.resource_prefix}-matching-table"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "url_key"

  attribute {
    name = "url_key"
    type = "S"
  }
  deletion_protection_enabled = true
}
