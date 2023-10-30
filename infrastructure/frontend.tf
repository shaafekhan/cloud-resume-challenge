resource "aws_s3_bucket" "crc-frontend" {
  bucket = "crc-frontend-static"
}

resource "aws_s3_bucket_ownership_controls" "crc-frontend-ownership-control" {
  bucket = aws_s3_bucket.crc-frontend.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "crc-frontend-public-access" {
  bucket = aws_s3_bucket.crc-frontend.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "crc-frontend-acl" {
  depends_on = [
    aws_s3_bucket_ownership_controls.crc-frontend-ownership-control,
    aws_s3_bucket_public_access_block.crc-frontend-public-access,
  ]

  bucket = aws_s3_bucket.crc-frontend.id
  acl    = "public-read"
}

resource "aws_s3_bucket_policy" "public-access" {
  bucket = aws_s3_bucket.crc-frontend.id
  policy = data.aws_iam_policy_document.public-access.json
}

data "aws_iam_policy_document" "public-access" {
  statement {
    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = [
      "s3:GetObject",
      "s3:ListBucket",
    ]

    resources = [
      aws_s3_bucket.crc-frontend.arn,
      "${aws_s3_bucket.crc-frontend.arn}/*",
    ]
  }
}


resource "aws_s3_bucket_website_configuration" "crc-frontend-web-conf" {
  bucket = aws_s3_bucket.crc-frontend.id

  index_document {
    suffix = "index.html"
  }
}

