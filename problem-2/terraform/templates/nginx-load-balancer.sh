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

# run 2 yeasy containers
docker run -d -p 8080:80 ${docker_registry}/simple-web
docker run -d -p 8081:80 ${docker_registry}/simple-web
docker run -d -p 8082:80 ${docker_registry}/simple-web

# install nginx
apt-get install -y nginx

# config nginx
cat >/etc/nginx/nginx.conf <<EOF
events {
}

http {
  upstream simple-web {
    server localhost:8080;
    server localhost:8081;
    server localhost:8082;
  }

  server {
    listen 80;
    location / {
      proxy_pass http://simple-web;
    }
  }
}
EOF

# restart nginx
systemctl restart nginx.service
