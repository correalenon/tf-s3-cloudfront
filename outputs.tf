output Certificates {
  value = module.ACM.Certificates
  sensitive = true
}

output Policies {
  value = [
    for i in module.IAM.Policies : i.arn
  ]
}

output Roles {
  value = [
    for i in module.IAM.Roles : i.arn
  ]
}

output Lambda {
  value = [
    for i in module.Lambdas.Lambdas : i.arn
  ]
}

output S3 {
  value       = [
    for i in module.S3.Buckets : i.arn
  ]
}

output ClouFrontOriginAccessControl {
  value       = [
    for i in module.CloudFront.OriginAccessControl : i.id
  ]
}

output CloudFrontS3 {
  value = [
    for i in module.CloudFront.CloudFrontS3Distribuitions : i.arn
  ]
}
