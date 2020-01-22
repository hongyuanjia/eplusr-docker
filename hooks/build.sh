#!/bin/bash
set -e

the Docker repository tag being built
if [[ $DOCKER_TAG =~ "-verse" ]];
then
    docker build -t $IMAGE_NAME --build-arg UPSTREAM=verse .
else
    docker build -t $IMAGE_NAME .
fi

