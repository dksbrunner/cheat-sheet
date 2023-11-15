#!/usr/bin/env bash

# $ aws configure
#
# AWS Access Key ID -> localstack-id
# AWS Secret Access Key -> localstack-access-key
# Default region name -> eu-central-1
# Default output format -> json

export AWS_PAGER=""
AWS_REGION="eu-central-1"
AWS_ENDPOINT_URL="http://localhost:4566"

S3_BUCKET_NAME="kubetainers-playground-s3"

UUID="$(uuidgen)"
echo "${UUID}" > input-file.txt

aws s3api put-object \
  --endpoint-url="${AWS_ENDPOINT_URL}" \
  --bucket "${S3_BUCKET_NAME}" --region "${AWS_REGION}" \
  --key "${UUID}.txt" --body input-file.txt
