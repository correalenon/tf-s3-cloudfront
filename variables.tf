variable Certificates {
  nullable = false
  type = map(object({
    Domain = string
    ValidationDomain = string
    SubjectAlternativeDomains = list(string)
    Tags = map(any)
  }))
  description = "Certificate especifications for use in ACM"
}

variable ZoneID {
  nullable = false
  type = string
  description = "ZoneID of domain on Route53"
}

variable Policies {
    nullable = true
    type = map(object({
        Name = string
        Path = string
        Description = string
        Location = string
    }))
    description = "Policies IAM module"
}

variable Roles {
    nullable = true
    type = map(object({
        Name = string
        Action = string
        Effect = string
        Principal = object({
            Service = string
        })
        ManagedPolicyArns = optional(list(string))
        Tags = map(any)
    }))
    description = "Roles IAM Module"
}

variable PoliciesAttachment {
    nullable = true
    type = map(object({
        Policy = string
        Role = string
    }))
    description = "Policies attach on Roles"
}

variable Lambdas {
  nullable = true
  type = map(object({
    Name = string
    FileName = string
    Role = string
    Handler = string
    MemorySize = string
    Runtime = string
    Architectures = list(string)
    Timeout = number
    TracingConfigMode = string
    PermissionsStatementIDS3 = string
    PermissionsPrincipalS3 = string
    PermissionsBucketName = string
    PermissionsActionS3 = string
    Tags = map(any)
  }))
  description = "Attribute Lambdas creation" 
}

variable Buckets {
  nullable = true
  type = map(object({
    Name = string
    ForceDestroy = optional(bool)
    AccessControlList = string
    CorsRule = optional(map(object({
      AllowedHeaders = list(string)
      AllowedOrigins = list(string)
      AllowedMethods = list(string)
    })))
    LambdaNameEventNotification = string
    Tags = map(any)
  }))
  description = "Buckets attributes"
}

variable Uploads {
  nullable = true
  type = map(object({
    BucketName = string
    Source = string
    Key = string
  }))  
  description = "Attribute files upload to S3 Bucket"
}

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

variable Profile {
  type = string
  description = "AWS CLI Profile for run Terraform"  
}