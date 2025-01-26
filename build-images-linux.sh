#!/bin/bash

set -e

docker buildx create --use
docker run --privileged --rm tonistiigi/binfmt --install all

find artifacts/binaries -type f -exec chmod +x {} \;

PLATFORMS="linux/amd64,linux/arm/v6,linux/arm/v7,linux/arm64"
OUTPUT="type=local,dest=local"
TAGS=
TAGS_ALPINE=

if [[ "${GITHUB_REF}" == "refs/heads/master" ]]; then
    echo "Building and pushing CI images"

    OUTPUT="type=registry"
    TAGS="-t adminvulcano/caddy-docker-proxy:ci"
    TAGS_ALPINE="-t adminvulcano/caddy-docker-proxy:ci-alpine"
fi

if [[ "${GITHUB_REF}" =~ ^refs/tags/v[0-9]+\.[0-9]+\.[0-9]+(-.*)?$ ]]; then
    RELEASE_VERSION=$(echo $GITHUB_REF | cut -c11-)

    echo "Releasing version ${RELEASE_VERSION}..."

    PATCH_VERSION=$(echo $RELEASE_VERSION | cut -c2-)
    MINOR_VERSION=$(echo $PATCH_VERSION | cut -d. -f-2)

    OUTPUT="type=registry"
    TAGS="-t adminvulcano/caddy-docker-proxy:latest \
        -t adminvulcano/caddy-docker-proxy:${PATCH_VERSION} \
        -t adminvulcano/caddy-docker-proxy:${MINOR_VERSION}"
    TAGS_ALPINE="-t adminvulcano/caddy-docker-proxy:alpine \
        -t adminvulcano/caddy-docker-proxy:${PATCH_VERSION}-alpine \
        -t adminvulcano/caddy-docker-proxy:${MINOR_VERSION}-alpine"
fi

docker buildx build -f Dockerfile . \
    -o $OUTPUT \
    --platform $PLATFORMS \
    $TAGS

docker buildx build -f Dockerfile-alpine . \
    -o $OUTPUT \
    --platform $PLATFORMS \
    $TAGS_ALPINE
