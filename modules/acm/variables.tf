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
