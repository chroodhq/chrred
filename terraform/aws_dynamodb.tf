resource "aws_dynamodb_table" "matching_table" {
  name         = "${local.resource_prefix}-matching-table"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }
  deletion_protection_enabled = true
}
