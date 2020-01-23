#!/bin/bash
set -e

if [[ "$DOCKER_TAG" =~ "-verse" ]];
then
    echo "Building using upstream rocker/verse container..."
    docker build -t $IMAGE_NAME --build-arg UPSTREAM=verse .
else
    echo "Building using upstream rocker/rstudio container..."
    docker build -t $IMAGE_NAME .
fi

