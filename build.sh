#!/bin/bash

set -e

echo ==PARAMETERS==
echo ARTIFACTS: "${ARTIFACTS:=./artifacts}"

go vet ./...
go test -race ./...

go install github.com/caddyserver/xcaddy/cmd/xcaddy@latest

# AMD64
GOTOOLCHAIN=go1.26.5 xcaddy build v2.11.7 \
    --output ${ARTIFACTS}/binaries/linux/amd64/caddy \
    --with github.com/lucaslorentz/caddy-docker-proxy/v2=$PWD \
    --with github.com/tailscale/caddy-tailscale@de41b249af4fd2083612c3b2303197e92787d1c5