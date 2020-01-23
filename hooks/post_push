#!/bin/bash
set -e

if [ "$DOCKERFILE_PATH" == "latest.Dockerfile" ];
then
    ## Not all bash commands are available. notably grep -o -e options fail!!
    VERSION=`sed -n 's|.*EPLUS_VER:-\([0-9]\.[0-9]\.[0-9]\).*|\1|p' latest.Dockerfile`
    echo "Version being built is: $VERSION"

    if [ "$DOCKER_TAG" == "-verse" ];
    then
        TAG="$VERSION-verse"
    else
        TAG="$VERSION"
    fi

    echo "tagging $IMAGE_NAME as $DOCKER_REPO:$TAG..."
    docker tag $IMAGE_NAME $DOCKER_REPO:$TAG

    echo "pushing $DOCKER_REPO:$TAG to hub..."
    docker push $DOCKER_REPO:$TAG
fi
