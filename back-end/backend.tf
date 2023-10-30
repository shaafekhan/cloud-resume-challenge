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
  "id": {"N": "0"},
  "countValue": {"N": "0"}
}
ITEM
}


data "archive_file" "lambda_db_counter" {
  type = "zip"

  source_file  = "${path.module}/updateDBEvent.py"
  output_path = "${path.module}/updateDBEvent.zip"
}

resource "aws_s3_bucket" "crc-lambda-storage-bucket" {
  bucket = "crc-lambda-storage-bucket"
}

resource "aws_s3_bucket_ownership_controls" "crc-lambda-bucket-ownership-control" {
  bucket = aws_s3_bucket.crc-lambda-storage-bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "bucket_acl" {
  bucket = aws_s3_bucket.lambda_bucket.id
  acl    = "private"
}

resource "aws_s3_object" "lambda_db_counter_s3_obj" {
  bucket = aws_s3_bucket.lambda_bucket.id

  key    = "updateDBEvent.zip"
  source = data.archive_file.lambda_db_counter.output_path

  etag = filemd5(data.archive_file.lambda_db_counter.output_path)
}


resource "aws_lambda_function" "counter-resume-challenge" {
  function_name = "resume-challenge-counter"

  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key    = aws_s3_object.lambda_db_counter_s3_obj.key

  runtime = "python3.11"
  handler = "lambda_function.lambda_handler"

  source_code_hash = data.archive_file.lambda_db_counter.output_base64sha256

  role = aws_iam_role.lambda_exec.arn
}

resource "aws_cloudwatch_log_group" "hello_world" {
  name = "/aws/lambda/${aws_lambda_function.counter-resume-challenge.function_name}"

  retention_in_days = 30
}

resource "aws_iam_role" "lambda_exec" {
  name = "serverless_lambda"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid    = ""
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}