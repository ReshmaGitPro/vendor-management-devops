#!/bin/bash 

apt update -y

apt install -y docker.io curl

systemctl enable docker
systemctl start docker

usermod -aG docker ubuntu

mkdir -p /usr/local/lib/docker/cli-plugins

curl -SL https://github.com/docker/compose/releases/latest/download/docker-compose-linux-x86_64 \
-o /usr/local/lib/docker/cli-plugins/docker-compose

chmod +x /usr/local/lib/docker/cli-plugins/docker-compose