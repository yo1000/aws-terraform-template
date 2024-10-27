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
