AWS Terraform Module Template
================================================================================

Ensure to read follows first.

- (en) https://docs.aws.amazon.com/prescriptive-guidance/latest/terraform-aws-provider-best-practices/structure.html
- (ja) https://docs.aws.amazon.com/ja_jp/prescriptive-guidance/latest/terraform-aws-provider-best-practices/structure.html


Deployment steps
--------------------------------------------------------------------------------

Step1. Set `container_api_count` to 0 in `envs/${env_name}/terraform.tfvars`.

Step2. Log in using awscli and assume-role as required.

```bash
source ./helpers/aws_login_sts.sh
```

Step3. Deploy resources.

```bash
terraform init -reconfigure -backend-config=./envs/${env_name}/config.s3.tfbackend

terraform plan -var-file=./envs/${env_name}/terraform.tfvars

terraform apply -var-file=./envs/${env_name}/terraform.tfvars
```

Step4. Upload container image to deployed ECR repositories.

```bash
aws ecr get-login-password --region ${region} | docker login --username AWS --password-stdin ${account}.dkr.ecr.ap-northeast-1.amazonaws.com

docker build -t ${image_name} .

docker tag ${image_name}:latest ${account}.dkr.ecr.ap-northeast-1.amazonaws.com/${image_name}:latest

docker push ${account}.dkr.ecr.ap-northeast-1.amazonaws.com/${image_name}:latest
```

Step5. Set `container_api_count` to >=1 in `envs/${env_name}/terraform.tfvars`.

Step6. Re-deploy resources.

```bash
terraform plan -var-file=./envs/${env_name}/terraform.tfvars

terraform apply -var-file=./envs/${env_name}/terraform.tfvars
```
