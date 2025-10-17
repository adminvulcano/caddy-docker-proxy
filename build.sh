#!/bin/bash

set -e

echo ==PARAMETERS==
echo ARTIFACTS: "${ARTIFACTS:=./artifacts}"

go vet ./...
go test -race ./...

go install github.com/caddyserver/xcaddy/cmd/xcaddy@latest

# AMD64
GOTOOLCHAIN=go1.25.3 xcaddy build v2.10.2 \
    --output ${ARTIFACTS}/binaries/linux/amd64/caddy \
    --with github.com/lucaslorentz/caddy-docker-proxy/v2=$PWD \
    --with github.com/tailscale/caddy-tailscale@01d084e119cb2ddb49630edb89bb5c6d7c4e8bc0