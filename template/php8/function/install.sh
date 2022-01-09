#!/bin/sh

echo "Installing extensions"
apk --no-cache add php8-sockets php8-pcntl php8-sodium

# Check the alpine image for more instructions
# https://hub.docker.com/_/alpine

