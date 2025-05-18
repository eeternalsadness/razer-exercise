#!/bin/bash

# install docker the dirty way
apt-get update && apt-get install -y docker.io

# run a yeasy container
docker run -d ${docker_registry}/simple-web --name web

# install nginx
apt-get install -y nginx
