resource "aws_acm_certificate" "Certificates" {
    for_each = {
        for Index, Certificate in coalesce(var.Certificates, {}) : Index => Certificate
        if Certificate != null
    }
    domain_name       = each.value.Domain
    subject_alternative_names = each.value.SubjectAlternativeDomains
    validation_method = "DNS"
    validation_option {
        domain_name       =  each.value.Domain
        validation_domain = each.value.ValidationDomain
    }
    tags = each.value.Tags
}

resource "aws_route53_record" "RecordCreation" {
    for_each = nonsensitive(aws_acm_certificate.Certificates)
    zone_id = var.ZoneID
    name    = tolist(each.value.domain_validation_options)[each.key].resource_record_name
    type    = tolist(each.value.domain_validation_options)[each.key].resource_record_type
    records = [tolist(each.value.domain_validation_options)[each.key].resource_record_value]
    ttl     = "300"
}
