resource "aws_dynamodb_table" "crc-backend-database" {
    name = "crc-backend-table"
    billing_mode = "PAY_PER_REQUEST"
    hash_key = "countValue"

    attribute {
      name = "countValue"
      type = "N"
    }
  
}