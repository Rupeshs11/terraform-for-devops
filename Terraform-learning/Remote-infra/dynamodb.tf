resource "aws_dynamodb_table" "basic-dynamodb-table" {
  name           = "my-dynamodb-state-table"
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "UserId"
  range_key      = "GameTitle"

  attribute {
    name = "UserId"
    type = "S"
  }

  tags = {
    Name        = "my-dynamodb-table"
    Environment = "production"
  }
}