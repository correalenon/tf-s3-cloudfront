variable OriginAccessControl {
  nullable = true
  type = map(object({
    Name = string
    Description = string
    OriginType = string
    SigningBehavior = string
    SiginProtocol = string
  }))
  description = "Origin Access Control"
}

variable Distribuitions {
  nullable = true
  type = map(object({
    CertificateDomain = string
    S3BucketFilter = string
    OriginAccessControlId = number
    Enabled = bool
    HTTPVersion = string
    Aliases = list(string)
    DefaultRootObject = string
    DefaultCacheBehavior = list(object({
      AllowedMethods = list(string)
      CachedMetods = list(string)
      ViewerProtocolPolicy = string
      ForwardedValues = object({
        QueryString = bool
        Cookies = string
      })
    }))
    CustomErrorResponse = list(object({
      ErrorCode = number
      ResponsePagePath = string
      ResponseCode = number
      ErrorCachingMinTTL = number
    }))
    PriceClass = string
    ViewerCertificate = list(object({
      ACMCertificateId = number
      SSLSupportMethod = string
    }))
    Tags = map(any)
  }))
  description = "CloudFront Distribuitions"
}

variable ZoneID {
  nullable = false
  type = string
  description = "ZoneID of domain on Route53"
}
