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
