#!/bin/bash

cd ~/
echo "Starting wordpressOld..."
docker-compose -f wordpressOld/docker-compose.yml up -d

echo "Switch nginx to wordpressOld..."
rm /etc/nginx/sites-enabled/*
cp nginx/wp1 /etc/nginx/sites-enabled/
service nginx reload

echo "Stopping wordpressNew..."
docker-compose -f wordpressNew/docker-compose.yml down
