data "aws_iam_role" "LambdaRole" {
    for_each = {
      for Index, Lambda in coalesce(var.Lambdas, {}) : Index => Lambda
      if Lambda != null
    }
    name = each.value.Role
}

resource "aws_lambda_function" "LambdaFunction" {
    for_each = {
      for Index, Lambda in coalesce(var.Lambdas, {}) : Index => Lambda
      if Lambda != null
    }
    function_name = each.value.Name
    filename = each.value.FileName
    role = data.aws_iam_role.LambdaRole[each.key].arn
    handler = each.value.Handler
    memory_size = each.value.MemorySize
    runtime = each.value.Runtime
    architectures = each.value.Architectures
    timeout = each.value.Timeout
    tracing_config {
        mode = each.value.TracingConfigMode
    }
    tags = each.value.Tags
    depends_on = [
        data.aws_iam_role.LambdaRole
    ]
}

resource "aws_lambda_permission" "LambdaPermission" {
    for_each = {
        for Index, Lambda in coalesce(var.Lambdas, {}) : Index => Lambda
        if Lambda != null && Lambda.PermissionsStatementIDS3 != null
    }
    statement_id = each.value.PermissionsStatementIDS3
    action = each.value.PermissionsActionS3
    function_name = aws_lambda_function.LambdaFunction[each.key].function_name
    principal = each.value.PermissionsPrincipalS3
    source_arn = "arn:aws:s3:::${each.value.PermissionsBucketName}"
}
