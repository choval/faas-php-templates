#!/bin/sh

echo "Installing extensions"
apk --no-cache add php81-sockets php81-pcntl php81-sodium

# Check the alpine image for more instructions
# https://hub.docker.com/_/alpine

