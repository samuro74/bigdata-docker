#!/bin/bash

# Build the base image
docker build -t bigdata-apoyo -f Dockerfile.apoyo .

# Build the extended image
docker build -t bigdata-inicio -f Dockerfile.inicio .

# Create network and volumes
docker network create bigdata-net
docker volume create namenode_data
docker volume create datanode1_data
docker volume create hive_data

echo "Images built successfully. Use docker-compose up to start the cluster."