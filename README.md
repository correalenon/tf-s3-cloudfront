# README

Este repositório contém código Terraform para hospedar um site estático usando S3 e CloudFront na AWS.
Neste exemplo utilizei um código disponível no GitHub https://github.com/natanloc/pedir-aumento-tiktok. Fique a vontade para criar com o código que quiser!

## Comandos Terraform

### terraform init

O comando `terraform init` é utilizado para inicializar um diretório de trabalho Terraform. Ele baixa e instala os plugins necessários para o provedor de nuvem especificado no arquivo de configuração.

Exemplo de uso:

```bash
terraform init
```

### terraform plan

O comando `terraform plan` é utilizado para criar um plano de execução Terraform. Ele compara o estado atual da infraestrutura com a configuração definida nos arquivos Terraform e exibe as ações que serão executadas.

Para usar este comando, é necessário fornecer um arquivo de variáveis `.tfvars`, bem como as variáveis `ZoneID` e `Profile`. Certifique-se de substituir `ID_ZONA_DNS_ROUTE53` pelo ID da zona DNS no Route 53 e `PROFILE_AWS_CLI` pelo perfil AWS CLI apropriado.

Exemplo de uso:

```bash
terraform plan --var-file="tf-s3-cloudfront.tfvars" -var="ZoneID=ID_ZONA_DNS_ROUTE53" -var="Profile=PROFILE_AWS_CLI"
```

### terraform apply

O comando `terraform apply` é utilizado para aplicar as alterações definidas nos arquivos Terraform. Ele cria, atualiza ou remove recursos conforme necessário para atingir o estado desejado da infraestrutura.

Assim como no comando `terraform plan`, é necessário fornecer um arquivo de variáveis `.tfvars`, bem como as variáveis `ZoneID` e `Profile`.

Exemplo de uso:

```bash
terraform apply --var-file="tf-s3-cloudfront.tfvars" -var="ZoneID=ID_ZONA_DNS_ROUTE53" -var="Profile=PROFILE_AWS_CLI"
```

### terraform destroy

O comando `terraform destroy` é utilizado para destruir todos os recursos gerenciados pelo Terraform. Ele remove todos os recursos definidos nos arquivos Terraform do ambiente de infraestrutura.

Assim como nos comandos anteriores, é necessário fornecer um arquivo de variáveis `.tfvars`, bem como as variáveis `ZoneID` e `Profile`.

Exemplo de uso:

```bash
terraform destroy --var-file="tf-s3-cloudfront.tfvars" -var="ZoneID=ID_ZONA_DNS_ROUTE53" -var="Profile=PROFILE_AWS_CLI"
```

## Sugestões e dúvidas
Qualquer sugestão e/ou dúvida é bem vinda. Sinta-se a vontade para questionar e melhorar este código.
