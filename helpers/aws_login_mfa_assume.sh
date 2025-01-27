#!/bin/bash

function aws_login_mfa_assume() {
  ## Usage
  ## ```
  ## source aws_login_assume.sh
  ## ```
  if [ "$0" = "${BASH_SOURCE}" ]; then
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
  if [[ "${AWS_STS_MFA_DEVICE_ARN}" = "" || "${AWS_STS_ROLE_ARN}" = "" ]] ; then
    echo 'Detected missing environment variables.'
    echo 'Set up environment variables:'
    echo '```'
    echo 'export AWS_STS_MFA_DEVICE_ARN='
    echo 'export AWS_STS_ROLE_ARN='
    echo '```'
    return 1
  fi


  ## STS Script
  echo 'Please type MFA code: '
  read LOCAL_AWS_STS_MFA_CODE

  if [[ "${LOCAL_AWS_STS_MFA_CODE}" = "" ]] ; then
    echo 'Login failure'
    return 1
  fi

  local LOCAL_AWS_STS_PROFILE="${AWS_STS_PROFILE:-default}"
  local LOCAL_AWS_STS_ACCOUNT="$(echo "${AWS_STS_MFA_DEVICE_ARN}" | sed -r 's/^arn:aws:iam::([0-9]*).*/\1/')"
  local LOCAL_AWS_STS_SESSION="$(aws sts get-caller-identity | jq -r '.Arn' | sed -r 's#.*/([^/]+)$#\1#' | rev | cut -c 1-64 | rev)"

  AWS_STS_CRED=$(aws sts assume-role \
    --profile ${LOCAL_AWS_STS_PROFILE} \
    --role-arn ${AWS_STS_ROLE_ARN} \
    --role-session-name ${LOCAL_AWS_STS_SESSION} \
    --serial-number ${AWS_STS_MFA_DEVICE_ARN} \
    --token-code ${LOCAL_AWS_STS_MFA_CODE})

  export AWS_ACCESS_KEY_ID=$(echo ${AWS_STS_CRED} | jq -r '.Credentials.AccessKeyId')
  export AWS_SECRET_ACCESS_KEY=$(echo ${AWS_STS_CRED} | jq -r '.Credentials.SecretAccessKey')
  export AWS_SESSION_TOKEN=$(echo ${AWS_STS_CRED} | jq -r '.Credentials.SessionToken')

  if [[ "${AWS_ACCESS_KEY_ID}" = "" ]] ; then
    echo
    echo 'Login failure'
    echo
    echo "PROFILE               | ${LOCAL_AWS_STS_PROFILE}"
    echo "ACCOUNT               | ${LOCAL_AWS_STS_ACCOUNT}"
    return 1
  fi

  echo
  echo 'Login succeeded.'
  echo 'AWSCLI is ready for use.'
  echo
  echo "PROFILE               | ${LOCAL_AWS_STS_PROFILE}"
  echo "ACCOUNT               | ${LOCAL_AWS_STS_ACCOUNT}"
  echo "AWS_ACCESS_KEY_ID     | ${AWS_ACCESS_KEY_ID}"
  echo 'AWS_SECRET_ACCESS_KEY | ****'
  echo 'AWS_SESSION_TOKEN     | ****'
}

aws_login_mfa_assume
