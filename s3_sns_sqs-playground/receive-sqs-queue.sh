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

SQS_QUEUE_NAME="kubetainers-playground-sqs"

aws sqs receive-message \
  --endpoint-url="${AWS_ENDPOINT_URL}" \
  --queue-url "${SQS_QUEUE_NAME}"
