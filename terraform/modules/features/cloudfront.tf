resource "aws_cloudfront_origin_access_control" "ofe_cloudfront_acl" {
  name                              = "s3featuresconfigpolicyacl"
  description                       = "Default Policy"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "ofe_cdn_distribution" {
  origin {
    domain_name              = aws_s3_bucket.ofe_bucket.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.ofe_cloudfront_acl.id
    origin_id                = aws_s3_bucket.ofe_bucket.id
  }

  enabled             = true
  is_ipv6_enabled     = false
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = aws_s3_bucket.ofe_bucket.id

    cache_policy_id = "658327ea-f89d-4fab-a63d-7e88639e58f6"

    viewer_protocol_policy = "redirect-to-https"
    compress               = true
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }

  tags = {
    Environment = "production"
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

resource "aws_cloudfront_response_headers_policy" "ofe_cdn_distribution_cors" {
  name    = "cors-features-policy"
  comment = "CORS Policy for OFE CDN Distribution"

  cors_config {
    access_control_allow_credentials = false

    access_control_allow_headers {
      items = ["*"]
    }

    access_control_allow_methods {
      items = ["GET"]
    }

    access_control_allow_origins {
      items = ["*"]
    }

    origin_override = true
  }
}
