resource "aws_iam_policy" "Policies" {
    for_each = {
        for Index, Policy in coalesce(var.Policies, {}) : Index => Policy
        if Policy != null
    }
    name = each.value.Name
    path = each.value.Path
    description = each.value.Description
    policy = file(each.value.Location)
}

resource "aws_iam_role" "Roles" {
    for_each = {
        for Index, Role in coalesce(var.Roles, {}) : Index => Role
        if Role != null
    }
    name = each.value.Name
    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Action = each.value.Action
                Effect = each.value.Effect
                Principal = each.value.Principal
            }
        ]
    })
    managed_policy_arns = each.value.ManagedPolicyArns != null ? each.value.ManagedPolicyArns : []
    tags = each.value.Tags 
    depends_on = [
        aws_iam_policy.Policies
    ]
}

data "aws_iam_policy" "PolicyFilter" {
    for_each = {
        for Index, Value in coalesce(var.PoliciesAttachment, {}) : Index => Value
        if Value.Policy != null
    }
    name = each.value.Policy
    depends_on = [
        aws_iam_policy.Policies
    ]
}

data "aws_iam_role" "RoleFilter" {
    for_each = {
        for Index, Value in coalesce(var.PoliciesAttachment, {}) : Index => Value
        if Value.Role != null
    }
    name = each.value.Role
    depends_on = [
        aws_iam_role.Roles
    ]
}

resource "aws_iam_role_policy_attachment" "PolicyAttachmentRole" {
    for_each = {
        for Index, Value in coalesce(var.PoliciesAttachment, {}) : Index => Value
        if Value.Policy != null && Value.Role != null
    }
    role = data.aws_iam_role.RoleFilter[each.key].name 
    policy_arn = data.aws_iam_policy.PolicyFilter[each.key].arn
}
