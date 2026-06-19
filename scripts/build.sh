#!/bin/bash

set -e 

IMAGE_TAG=$1
AWS_REGION=$2
AWS_ACCOUNT_ID=$3
FRONTEND_REPO=$4
BACKEND_REPO=$5

echo "Building frontend image..."

docker build \
  -t frontend-app:$IMAGE_TAG \
  ./frontend

echo "Building backend image..."

docker build \
  -t backend-app:$IMAGE_TAG \
  ./backend

echo "Tagging frontend image..."

docker tag frontend-app:$IMAGE_TAG \
  $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$FRONTEND_REPO:$IMAGE_TAG



echo "Tagging backend image..."

docker tag backend-app:$IMAGE_TAG \
  $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$BACKEND_REPO:$IMAGE_TAG



echo "Pushing frontend image..."

docker push \
  $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$FRONTEND_REPO:$IMAGE_TAG



echo "Pushing backend image..."

docker push \
  $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$BACKEND_REPO:$IMAGE_TAG



echo "Build and Push Completed Successfully"