#!/bin/bash

# install docker the dirty way
apt-get update && apt-get install -y docker.io

# update docker daemon.json
cat >/etc/docker/daemon.json <<EOF
{
  "insecure-registries": ["${docker_registry}"]
}
EOF
systemctl restart docker.service

# run a yeasy container
docker run -d -p 8080:80 ${docker_registry}/simple-web

# install nginx
apt-get install -y nginx

# config nginx
cat >/etc/nginx/nginx.conf <<EOF
events {
}

http {
  server {
    listen 80;
    location / {
      proxy_pass http://localhost:8080;
    }
  }
}
EOF

# restart nginx
systemctl restart nginx.service
