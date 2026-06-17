#!/bin/bash

set -e

IMAGE_TAG=$1
AWS_REGION=$2
AWS_ACCOUNT_ID=$3
S3_BUCKET_NAME=$4

echo "Downloading latest compose file"

aws s3 cp \
s3://$S3_BUCKET_NAME/docker-compose.deploy.yml \
/home/ubuntu/app/docker-compose.yml

cd /home/ubuntu/app

echo "Logging into ECR"

aws ecr get-login-password \
--region $AWS_REGION | \
docker login \
--username AWS \
--password-stdin \
$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com

echo "Pulling latest images"

export IMAGE_TAG
export AWS_REGION
export AWS_ACCOUNT_ID

docker compose pull

echo "Restarting containers"

docker compose up -d

echo "Cleaning old images"

docker image prune -af

echo "Running containers"

docker ps

echo "Deployment completed successfully"