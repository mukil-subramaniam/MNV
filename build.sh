#!/bin/bash

# Variables
IMAGE_NAME="mukil077/mvn"
TAG="latest"

# Build Docker image
docker build -t $IMAGE_NAME:$TAG .
echo "Docker image $IMAGE_NAME:$TAG built successfully."
