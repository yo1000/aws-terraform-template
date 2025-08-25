AWS Terraform Module Template
================================================================================

Ensure to read follows first.

- (en) https://docs.aws.amazon.com/prescriptive-guidance/latest/terraform-aws-provider-best-practices/structure.html
- (ja) https://docs.aws.amazon.com/ja_jp/prescriptive-guidance/latest/terraform-aws-provider-best-practices/structure.html


Deployment steps
--------------------------------------------------------------------------------

### Step1. Configure tfvars

Edit `envs/${env_name}/terraform.tfvars`

```
container_api_count = 0
```

### Step2. Login using awscli

With MFA. (`AWS_STS_PROFILE` is optional.)

```bash
AWS_STS_PROFILE=${profile} \
AWS_STS_MFA_DEVICE_ARN=${mfa_device_arn} \
source ./helpers/aws_login_mfa.sh
```

With MFA and assume-role. (`AWS_STS_PROFILE` is optional.)

```bash
AWS_STS_PROFILE=${profile} \
AWS_STS_ROLE_ARN=${assume_role_arn} \
AWS_STS_MFA_DEVICE_ARN=${mfa_device_arn} \
source ./helpers/aws_login_mfa_assume.sh
```

### Step3. Deploy resources

```bash
terraform init -reconfigure -backend-config=./envs/${env_name}/config.s3.tfbackend

terraform plan -var-file=./envs/${env_name}/terraform.tfvars

terraform apply -var-file=./envs/${env_name}/terraform.tfvars
```

### Step4. Deploy container image

Upload container image to deployed ECR repositories.

```bash
aws ecr get-login-password --region ${region} | docker login --username AWS --password-stdin ${account}.dkr.ecr.ap-northeast-1.amazonaws.com

docker build -t ${image_name} .

docker tag ${image_name}:latest ${account}.dkr.ecr.ap-northeast-1.amazonaws.com/${image_name}:latest

docker push ${account}.dkr.ecr.ap-northeast-1.amazonaws.com/${image_name}:latest
```

### Step5. Re-configure tfvars

Edit `envs/${env_name}/terraform.tfvars`

```
# Set value greater than or equal to 1.
container_api_count = 1
```

### Step6. Re-deploy resources

```bash
terraform plan -var-file=./envs/${env_name}/terraform.tfvars

terraform apply -var-file=./envs/${env_name}/terraform.tfvars
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >=5.0.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >=3.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >=5.0.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ecs"></a> [ecs](#module\_ecs) | ./modules/ecs | n/a |
| <a name="module_ecs_api"></a> [ecs\_api](#module\_ecs\_api) | ./modules/ecs_api | n/a |
| <a name="module_ecs_consumer"></a> [ecs\_consumer](#module\_ecs\_consumer) | ./modules/ecs_consumer | n/a |
| <a name="module_msk"></a> [msk](#module\_msk) | ./modules/msk | n/a |
| <a name="module_rds"></a> [rds](#module\_rds) | ./modules/rds | n/a |
| <a name="module_secrets"></a> [secrets](#module\_secrets) | ./modules/secrets | n/a |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | ./modules/vpc | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_secretsmanager_secret.rds_credentials](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secret) | data source |
| [aws_secretsmanager_secret_version.rds_credentials_version](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secret_version) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_container_api_exec_role_arn"></a> [container\_api\_exec\_role\_arn](#input\_container\_api\_exec\_role\_arn) | n/a | `string` | n/a | yes |
| <a name="input_container_api_name"></a> [container\_api\_name](#input\_container\_api\_name) | Container settings - API | `string` | n/a | yes |
| <a name="input_container_api_version"></a> [container\_api\_version](#input\_container\_api\_version) | n/a | `string` | n/a | yes |
| <a name="input_container_consumer_envvar_value_kafka_bootstrap_servers"></a> [container\_consumer\_envvar\_value\_kafka\_bootstrap\_servers](#input\_container\_consumer\_envvar\_value\_kafka\_bootstrap\_servers) | n/a | `string` | n/a | yes |
| <a name="input_container_consumer_envvar_value_kafka_consumer_group_id"></a> [container\_consumer\_envvar\_value\_kafka\_consumer\_group\_id](#input\_container\_consumer\_envvar\_value\_kafka\_consumer\_group\_id) | n/a | `string` | n/a | yes |
| <a name="input_container_consumer_envvar_value_kafka_topic_name"></a> [container\_consumer\_envvar\_value\_kafka\_topic\_name](#input\_container\_consumer\_envvar\_value\_kafka\_topic\_name) | n/a | `string` | n/a | yes |
| <a name="input_container_consumer_envvar_value_point_api_baseurl"></a> [container\_consumer\_envvar\_value\_point\_api\_baseurl](#input\_container\_consumer\_envvar\_value\_point\_api\_baseurl) | n/a | `string` | n/a | yes |
| <a name="input_container_consumer_exec_role_arn"></a> [container\_consumer\_exec\_role\_arn](#input\_container\_consumer\_exec\_role\_arn) | n/a | `string` | n/a | yes |
| <a name="input_container_consumer_name"></a> [container\_consumer\_name](#input\_container\_consumer\_name) | Container settings - Consumer | `string` | n/a | yes |
| <a name="input_container_consumer_role_arn"></a> [container\_consumer\_role\_arn](#input\_container\_consumer\_role\_arn) | n/a | `string` | n/a | yes |
| <a name="input_container_consumer_version"></a> [container\_consumer\_version](#input\_container\_consumer\_version) | n/a | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment where to deploy the solution | `string` | n/a | yes |
| <a name="input_msk_cluster_arn"></a> [msk\_cluster\_arn](#input\_msk\_cluster\_arn) | Event streaming settings | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | General settings | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Region where to deploy the resources | `string` | n/a | yes |
| <a name="input_security_group_http_id"></a> [security\_group\_http\_id](#input\_security\_group\_http\_id) | n/a | `string` | n/a | yes |
| <a name="input_security_group_vpc_id"></a> [security\_group\_vpc\_id](#input\_security\_group\_vpc\_id) | n/a | `string` | n/a | yes |
| <a name="input_subnet_pri_ids"></a> [subnet\_pri\_ids](#input\_subnet\_pri\_ids) | n/a | `list(string)` | n/a | yes |
| <a name="input_subnet_pro_ids"></a> [subnet\_pro\_ids](#input\_subnet\_pro\_ids) | n/a | `list(string)` | n/a | yes |
| <a name="input_subnet_pub_ids"></a> [subnet\_pub\_ids](#input\_subnet\_pub\_ids) | n/a | `list(string)` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | n/a | `string` | n/a | yes |
| <a name="input_container_api_count"></a> [container\_api\_count](#input\_container\_api\_count) | n/a | `string` | `1` | no |
| <a name="input_container_api_envvar_value_db_name"></a> [container\_api\_envvar\_value\_db\_name](#input\_container\_api\_envvar\_value\_db\_name) | n/a | `string` | `"postgres"` | no |
| <a name="input_container_api_envvar_value_db_option"></a> [container\_api\_envvar\_value\_db\_option](#input\_container\_api\_envvar\_value\_db\_option) | n/a | `string` | `""` | no |
| <a name="input_container_api_health_port"></a> [container\_api\_health\_port](#input\_container\_api\_health\_port) | n/a | `number` | `8080` | no |
| <a name="input_container_api_port"></a> [container\_api\_port](#input\_container\_api\_port) | n/a | `number` | `8080` | no |
| <a name="input_container_consumer_count"></a> [container\_consumer\_count](#input\_container\_consumer\_count) | n/a | `string` | `1` | no |
| <a name="input_container_consumer_health_port"></a> [container\_consumer\_health\_port](#input\_container\_consumer\_health\_port) | n/a | `number` | `8080` | no |
| <a name="input_container_consumer_port"></a> [container\_consumer\_port](#input\_container\_consumer\_port) | n/a | `number` | `8080` | no |
| <a name="input_db_username"></a> [db\_username](#input\_db\_username) | Database settings | `string` | `"postgres"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->