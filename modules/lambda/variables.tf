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