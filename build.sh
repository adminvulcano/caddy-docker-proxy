#!/bin/bash

set -e

echo ==PARAMETERS==
echo ARTIFACTS: "${ARTIFACTS:=./artifacts}"

go vet ./...
go test -race ./...

go install github.com/caddyserver/xcaddy/cmd/xcaddy@latest

# AMD64
GOTOOLCHAIN=go1.23.5 xcaddy build v2.9.1 \
    --output ${ARTIFACTS}/binaries/linux/amd64/caddy \
    --with github.com/lucaslorentz/caddy-docker-proxy/v2=$PWD \
    --with github.com/tailscale/caddy-tailscale \
    --replace github.com/tailscale/caddy-tailscale=github.com/jurekl/caddy-tailscale@main
