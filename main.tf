module ACM {
    source = "./modules/acm"
    Certificates = var.Certificates
    ZoneID = var.ZoneID
}

module IAM {
    source = "./modules/iam"
    Policies = var.Policies
    Roles = var.Roles
    PoliciesAttachment = var.PoliciesAttachment
}

module Lambdas {
    source = "./modules/lambda"
    Lambdas = var.Lambdas
    depends_on = [
        module.IAM
    ]
}

module S3 {
    source = "./modules/s3"
    Buckets = var.Buckets
    Uploads = var.Uploads
    depends_on = [
        module.Lambdas
    ]
}

module CloudFront {
    source = "./modules/cloudfront"
    OriginAccessControl = var.OriginAccessControl
    Distribuitions = var.Distribuitions
    ZoneID = var.ZoneID
    depends_on = [ 
        module.ACM,
        module.S3
     ]
}
