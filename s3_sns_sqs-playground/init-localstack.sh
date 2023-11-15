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

SNS_TOPIC_NAME="kubetainers-playground-sns"
SQS_QUEUE_NAME="kubetainers-playground-sqs"
S3_BUCKET_NAME="kubetainers-playground-s3"

(
  echo "########### Delete SNS topic ###########"
  aws sns delete-topic \
    --endpoint-url "${AWS_ENDPOINT_URL}" \
    --topic-arn "arn:aws:sns:${AWS_REGION}:000000000000:${SNS_TOPIC_NAME}"
) || (echo "ERROR" && exit 1)

echo "########### Create SNS topic ###########"
aws sns create-topic \
  --endpoint-url "${AWS_ENDPOINT_URL}" \
  --name "${SNS_TOPIC_NAME}" --region "${AWS_REGION}"

(
  echo "########### Delete SQS queue ###########"
  aws sqs delete-queue \
    --endpoint-url "${AWS_ENDPOINT_URL}" \
    --queue-url "http://localhost:4566/000000000000/${SQS_QUEUE_NAME}" --region "${AWS_REGION}"
) || (echo "ERROR" && exit 1)

echo "########### Create SQS queue ###########"
aws sqs create-queue \
  --endpoint-url "${AWS_ENDPOINT_URL}" \
  --queue-name "${SQS_QUEUE_NAME}" --region "${AWS_REGION}"

aws sns subscribe \
  --endpoint-url "${AWS_ENDPOINT_URL}" \
  --region "${AWS_REGION}" \
  --topic-arn "arn:aws:sns:${AWS_REGION}:000000000000:${SNS_TOPIC_NAME}" \
  --protocol sqs --notification-endpoint "arn:aws:sqs:${AWS_REGION}:000000000000:${SQS_QUEUE_NAME}"

(
  echo "########### Delete S3 bucket ###########"
  aws s3api delete-bucket \
    --endpoint-url "${AWS_ENDPOINT_URL}" \
    --bucket "${S3_BUCKET_NAME}" --region "${AWS_REGION}"
) || (echo "ERROR" && exit 1)

echo "########### Create S3 bucket ###########"
aws s3api create-bucket \
  --endpoint-url "${AWS_ENDPOINT_URL}" \
  --bucket "${S3_BUCKET_NAME}" --region "${AWS_REGION}" \
  --create-bucket-configuration LocationConstraint="${AWS_REGION}"

echo "########### Update S3 bucket notification configurations ###########"
aws s3api put-bucket-notification-configuration \
  --endpoint-url="${AWS_ENDPOINT_URL}" \
  --bucket "${S3_BUCKET_NAME}" --region "${AWS_REGION}" \
  --notification-configuration '{
                                  "TopicConfigurations": [
                                    {
                                      "TopicArn": "'"arn:aws:sns:${AWS_REGION}:000000000000:${SNS_TOPIC_NAME}"'",
                                      "Events": ["s3:ObjectCreated:*"]
                                    }
                                  ]
                                }'
