#!/bin/bash

cd ~/
echo "Starting wordpressNew..."
docker-compose -f wordpress2/docker-compose.yml up -d

echo "Switch nginx to wordpressNew..."
rm /etc/nginx/sites-enabled/*
cp nginx/wp2 /etc/nginx/sites-enabled/
service nginx reload

echo "Stopping wordpressOld..."
docker-compose -f wordpress1/docker-compose.yml down
