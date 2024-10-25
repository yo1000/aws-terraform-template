#!/bin/bash

## Usage
## ```
## source aws_login_sts.sh
## ```
if [ "$0" = "$BASH_SOURCE" ]; then
  echo 'Detected incorrect script invocation.'
  echo 'Correct usage:'
  echo '```'
  echo "source ${BASH_SOURCE}"
  echo '```'
  exit 1
fi


## Requirements
## ```
## sudo apt install awscli jq
## aws configure
## ```
if ! command -v aws >/dev/null 2>&1 || ! command -v jq >/dev/null 2>&1; then
  echo 'Detected missing requirements.'
  echo 'Set up requirements:'
  echo '```'
  echo 'sudo apt install awscli jq -y'
  echo 'aws configure'
  echo '```'
  return 1
fi


## Your Settings
## https://console.aws.amazon.com/iam/home?#security_credential
if [[ "${AWS_STS_MFA_DEVICE_ARN}" = "" || "${AWS_STS_ROLE_ARN}" = "" || "${AWS_STS_REGION}" = "" ]] ; then
  echo 'Detected missing environment variables.'
  echo 'Set up environment variables:'
  echo '```'
  echo 'export AWS_STS_MFA_DEVICE_ARN='
  echo 'export AWS_STS_ROLE_ARN='
  echo 'export AWS_STS_REGION='
  echo '```'
  return 1
fi


## STS Script
echo 'Please type MFA code: '
read AWS_STS_MFA_CODE

AWS_STS_CRED=$(aws sts assume-role \
  --role-arn $AWS_STS_ROLE_ARN \
  --serial-number $AWS_STS_MFA_DEVICE_ARN \
  --role-session-name "$(aws sts get-caller-identity | jq -r '.Arn' | sed -r 's/^[^/]*\///g')" \
  --profile default \
  --token-code $AWS_STS_MFA_CODE \
  --region $AWS_STS_REGION)

export AWS_ACCESS_KEY_ID=$(echo $AWS_STS_CRED | jq -r '.Credentials.AccessKeyId')
export AWS_SECRET_ACCESS_KEY=$(echo $AWS_STS_CRED | jq -r '.Credentials.SecretAccessKey')
export AWS_SESSION_TOKEN=$(echo $AWS_STS_CRED | jq -r '.Credentials.SessionToken')

echo
echo 'AWSCLI is ready for use.'
echo
echo "AWS_ACCESS_KEY_ID     | ${AWS_ACCESS_KEY_ID}"
echo 'AWS_SECRET_ACCESS_KEY | ****'
echo 'AWS_SESSION_TOKEN     | ****'

