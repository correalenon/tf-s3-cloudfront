Certificates = {
    0 = {
        Domain = "*.lenon.app.br"
        ValidationDomain = "lenon.app.br"
        SubjectAlternativeDomains = [
            "*.lenon.app.br"
        ]
        Tags = {
            "Name" = "lenon.app.br"
            "Environment" = "Development"
        }
    }
}

Buckets = {
    0 = {
        Name = "static-website-pedir-aumento"
        ForceDestroy = true
        AccessControlList = "private"
        CorsRule = {
            0 = {
                AllowedHeaders = ["*"]
                AllowedOrigins = ["*"]
                AllowedMethods = ["GET"]
            }
        }
        LambdaNameEventNotification = "S3Unzip"
        Tags = {
            "Name" = "static-website-pedir-aumento"
            "Versioning" = false
            "Website" = true
            "Environment" = "Development"
        }
    }
}

Uploads = {
    0 = {
        BucketName = "static-website-pedir-aumento"
        Source = "./static-website/pedir-aumento-tiktok-main.zip"
        Key = "uploads/pedir-aumento-tiktok-main.zip"
    }
}

OriginAccessControl = {
    0 = {
        Name = "Origin Access Control"
        Description = "Origin Access Control"
        OriginType = "s3"
        SigningBehavior = "always"
        SiginProtocol = "sigv4"
    }
}

Distribuitions = {
    0 = {
        CertificateDomain = "*.lenon.app.br"
        S3BucketFilter = "static-website-pedir-aumento"
        OriginAccessControlId = 0
        Enabled = true
        HTTPVersion = "http2"
        Aliases = [
            "aumento.lenon.app.br"
        ]
        DefaultRootObject = "/pediraumento.html"
        DefaultCacheBehavior = [{
            AllowedMethods = ["GET", "HEAD", "OPTIONS"]
            CachedMetods = ["GET", "HEAD", "OPTIONS"]
            ViewerProtocolPolicy = "redirect-to-https"
            ForwardedValues = {
                QueryString = true
                Cookies = "all"
            }
        }]
        CustomErrorResponse = [
            {
                ErrorCode = 400
                ResponsePagePath = "/pediraumento.html"
                ResponseCode = 200
                ErrorCachingMinTTL = 300
            },
            {
                ErrorCode = 403
                ResponsePagePath = "/pediraumento.html"
                ResponseCode = 200
                ErrorCachingMinTTL = 300
            }
        ]
        PriceClass = "PriceClass_All"
        ViewerCertificate = [{
            ACMCertificateId = 0
            SSLSupportMethod = "sni-only"
        }]
        Tags = {
            "Name" = "static-website-pedir-aumento"
            "Environment" = "Development"
        }
    }
}

Policies = {
    0 = {
        Name = "S3UnzipLambdaPolicy"
        Path = "/"
        Description = "Policy S3UnzipLambda"
        Location = "./policies/S3UnzipLambdaPolicy.json"
    }
}

Roles = {
    0 = {
        Name = "S3UnzipLambdaRole"
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
        Service = "lambda.amazonaws.com"
        }
        Tags = {
            "Name" = "S3UnzipLambdaRole"
            "Environment" = "Development"
        }
    }
}

PoliciesAttachment = {
    0 = {
        Policy = "S3UnzipLambdaPolicy"
        Role = "S3UnzipLambdaRole"
    }
}

Lambdas = {
    0 = {
        Name = "S3Unzip"
        FileName = "./lambdas/S3Unzip.zip"
        Role = "S3UnzipLambdaRole"
        Handler = "main.main"
        MemorySize = 128
        Runtime = "python3.10"
        Architectures = ["arm64"]
        Timeout = 60
        TracingConfigMode = "PassThrough"
        PermissionsStatementIDS3 ="AllowExecutionFromS3"
        PermissionsPrincipalS3 = "s3.amazonaws.com"
        PermissionsBucketName = "static-website-pedir-aumento"
        PermissionsActionS3 = "lambda:InvokeFunction"
        Tags = {
            "Name" = "S3Unzip"
            "Runtime" = "python3.10"
            "Environment" = "Development"
        }
    }
}