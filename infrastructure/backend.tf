resource "aws_dynamodb_table" "crc-backend-database" {
    name = "crc-backend-table"
    billing_mode = "PAY_PER_REQUEST"
    hash_key = "id"

    attribute {
      name = "id"
      type = "N"
    }
  
}
resource "aws_dynamodb_table_item" "crc-backend-database-item" {
  table_name = aws_dynamodb_table.crc-backend-database.name
  hash_key   = aws_dynamodb_table.crc-backend-database.hash_key

  item = <<ITEM
{
  "id": {"N": "0"}
}
ITEM
}