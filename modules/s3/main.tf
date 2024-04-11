resource "aws_s3_bucket" "S3Bucket" {
    for_each = {
        for Index, Bucket in coalesce(var.Buckets, {}) : Index => Bucket
        if Bucket != null
    }
    bucket = each.value.Name
    force_destroy = coalesce(each.value.ForceDestroy, false)
    tags = each.value.Tags
}

resource "aws_s3_bucket_cors_configuration" "S3BucketCors" {
    for_each = {
        for CorsRule, Bucket in var.Buckets : CorsRule => Bucket
        if Bucket != null && Bucket.CorsRule != null
    }
    bucket = aws_s3_bucket.S3Bucket[each.key].id
    dynamic "cors_rule" {
        for_each = var.Buckets[each.key].CorsRule
        content {
            allowed_headers = cors_rule.value.AllowedHeaders
            allowed_origins = cors_rule.value.AllowedOrigins
            allowed_methods = cors_rule.value.AllowedMethods
        }
    }
    depends_on = [
        aws_s3_bucket.S3Bucket
    ]
}

resource "aws_s3_bucket_public_access_block" "S3BucketPublicAccess" {
    for_each = {
        for Index, Bucket in coalesce(var.Buckets, {}) : Index => Bucket
        if Bucket != null
    }
    bucket = aws_s3_bucket.S3Bucket[each.key].id
    block_public_acls = false
    block_public_policy = false
    ignore_public_acls = false
    restrict_public_buckets = false
    depends_on = [
        aws_s3_bucket.S3Bucket
    ]
}

data "aws_s3_bucket" "S3BucketFilter" {
    for_each = {
        for Index, Upload in coalesce(var.Uploads, {}) : Index => Upload
        if Upload != null
    }
    bucket = each.value.BucketName
    depends_on = [
        aws_s3_bucket.S3Bucket        
    ]
}

resource "aws_s3_object" "Upload" {
    for_each = {
        for Index, Upload in coalesce(var.Uploads, {}) : Index => Upload
        if Upload != null
    }
    bucket     = data.aws_s3_bucket.S3BucketFilter[each.key].id
    key        = each.value.Key
    source     = each.value.Source
    depends_on = [
        aws_s3_bucket.S3Bucket,
        data.aws_s3_bucket.S3BucketFilter
    ]
}