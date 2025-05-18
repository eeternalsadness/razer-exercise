#!/bin/bash

# install docker the dirty way
apt-get update && apt-get install -y docker.io

# create the config file
DOCKER_REGISTRY_CONFIG_DIR="/opt/docker-registry"
mkdir -p "$DOCKER_REGISTRY_CONFIG_DIR"
cat >"$DOCKER_REGISTRY_CONFIG_DIR/config.yml" <<EOF
version: 0.1
log:
  fields:
    service: registry
storage:
  s3:
    region: ${region}
    bucket: ${bucket_name}
  tag:
    concurrencylimit: 8
http:
  addr: :5000
  headers:
    X-Content-Type-Options: [nosniff]
health:
  storagedriver:
    enabled: true
    interval: 10s
    threshold: 3
EOF

# run docker registry
docker run -d \
  --restart=always \
  --name registry \
  -v $DOCKER_REGISTRY_CONFIG_DIR/config.yml:/etc/distribution/config.yml \
  -p 5000:5000 \
  registry:3
