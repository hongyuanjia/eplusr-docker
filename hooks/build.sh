#!/bin/bash
set -e

if [[ $DOCKER_TAG =~ "-verse" ]]
then
    docker build -t $IMAGE_NAME --build-arg UPSTREAM=verse .
else
    docker build -t $IMAGE_NAME .
fi

