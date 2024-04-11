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
