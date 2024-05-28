#!/bin/bash

mkdir nacos-mysql
# 将这个东西下载下来
curl -o nacos-mysql/Dockerfile https://raw.githubusercontent.com/nacos-group/nacos-docker/master/example/image/mysql/5.7/Dockerfile
docker build -t nacos-mysql:5.7 nacos-mysql/
