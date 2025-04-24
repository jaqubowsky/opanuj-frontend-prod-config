resource "aws_s3_bucket" "ofe_bucket" {
  bucket = var.features_bucket_name
}

resource "aws_s3_bucket_ownership_controls" "ofe_bucket_ownership" {
  bucket = aws_s3_bucket.ofe_bucket.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_public_access_block" "ofe_bucket_access" {
  bucket = aws_s3_bucket.ofe_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


resource "aws_s3_bucket_policy" "ofe_bucket_policy" {
  bucket = aws_s3_bucket.ofe_bucket.id

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "AllowCloudFrontServicePrincipalGetObject",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "cloudfront.amazonaws.com"
        },
        "Action" : "s3:GetObject",
        "Resource" : "arn:aws:s3:::${var.features_bucket_name}/*"
      }
    ]
  })
}

resource "aws_s3_bucket_server_side_encryption_configuration" "ofe_bucket_sse" {
  bucket = aws_s3_bucket.ofe_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
