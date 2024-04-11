resource "aws_cloudfront_origin_access_control" "OriginAccessControl" {
  for_each = {
    for Index, OAC in coalesce(var.OriginAccessControl, {}) : Index => OAC
    if OAC != null
  }
  name = each.value.Name
  description = each.value.Description
  origin_access_control_origin_type = each.value.OriginType
  signing_behavior = each.value.SigningBehavior
  signing_protocol = each.value.SiginProtocol
}

data "aws_s3_bucket" "S3BucketFilter" {
  for_each = {
    for S3, Distribuition in coalesce(var.Distribuitions, {}) : S3 => Distribuition
    if Distribuition.S3BucketFilter != null
  }
  bucket = each.value.S3BucketFilter
}

data "aws_acm_certificate" "ACMFilter" {
  for_each = {
    for S3, Distribuition in coalesce(var.Distribuitions, {}) : S3 => Distribuition
    if Distribuition.CertificateDomain != null
  }
  domain = each.value.CertificateDomain
  types = ["AMAZON_ISSUED"]
  most_recent = true
}

resource "aws_cloudfront_distribution" "CloudFrontS3Distribuition" {
  for_each = {
    for S3, Distribuition in coalesce(var.Distribuitions, {}) : S3 => Distribuition
    if Distribuition.S3BucketFilter != null
  }
  origin {
    domain_name = data.aws_s3_bucket.S3BucketFilter[each.key].bucket_domain_name
    origin_id = each.value.S3BucketFilter
    origin_access_control_id = aws_cloudfront_origin_access_control.OriginAccessControl[each.value.OriginAccessControlId].id
  }
  enabled = each.value.Enabled
  http_version = each.value.HTTPVersion
  aliases = each.value.Aliases
  default_root_object = each.value.DefaultRootObject
  dynamic "default_cache_behavior" {
    for_each = var.Distribuitions[each.key].DefaultCacheBehavior
    content {
      allowed_methods = default_cache_behavior.value.AllowedMethods
      cached_methods = default_cache_behavior.value.CachedMetods
      target_origin_id = each.value.S3BucketFilter
      viewer_protocol_policy = default_cache_behavior.value.ViewerProtocolPolicy
      forwarded_values {
        query_string = default_cache_behavior.value.ForwardedValues.QueryString
        cookies {
          forward = default_cache_behavior.value.ForwardedValues.Cookies
        }
      }
    }
  }
  dynamic "custom_error_response"  {
    for_each = var.Distribuitions[each.key].CustomErrorResponse
    content {
      error_code = custom_error_response.value.ErrorCode
      response_page_path = custom_error_response.value.ResponsePagePath
      response_code = custom_error_response.value.ResponseCode
      error_caching_min_ttl = custom_error_response.value.ErrorCachingMinTTL
    }
  }
  price_class = each.value.PriceClass
  dynamic "viewer_certificate" {
    for_each = var.Distribuitions[each.key].ViewerCertificate
    content {
      ssl_support_method = viewer_certificate.value.SSLSupportMethod
      acm_certificate_arn = data.aws_acm_certificate.ACMFilter[each.key].arn
    }
  }
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  tags = each.value.Tags
  depends_on = [
    data.aws_s3_bucket.S3BucketFilter,
    data.aws_acm_certificate.ACMFilter
  ]
}

resource "aws_s3_bucket_policy" "S3BucketPolicy" {
  for_each = {
      for S3, Distribuition in coalesce(var.Distribuitions, {}) : S3 => Distribuition
      if Distribuition != null
  }
  bucket = data.aws_s3_bucket.S3BucketFilter[each.key].id
  policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": 
      {
        "Effect": "Allow",
        "Principal": {
            "Service": "cloudfront.amazonaws.com"
        },
        "Action": "s3:GetObject",
        "Resource": "${data.aws_s3_bucket.S3BucketFilter[each.key].arn}/*",
        "Condition": {
          "StringEquals": {
            "AWS:SourceArn": "${aws_cloudfront_distribution.CloudFrontS3Distribuition[each.key].arn}"
          }
        }
      }
  }
  EOF
  depends_on = [
    data.aws_s3_bucket.S3BucketFilter,
    aws_cloudfront_distribution.CloudFrontS3Distribuition
  ]
}

resource "aws_route53_record" "RecordCreation" {
  for_each = {
    for S3, Distribuition in coalesce(var.Distribuitions, {}) : S3 => Distribuition
    if Distribuition != null
  }
  zone_id = var.ZoneID
  name = aws_cloudfront_distribution.CloudFrontS3Distribuition[each.key].domain_name
  type = "CNAME"
  records = aws_cloudfront_distribution.CloudFrontS3Distribuition[each.key].aliases
  ttl = "300"
  depends_on = [
    aws_cloudfront_distribution.CloudFrontS3Distribuition
  ]
}
