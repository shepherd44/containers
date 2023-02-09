#!/usr/bin/env bash

HADOOP_VERSION=3.3.4

docker build --platform=linux/amd64 \
  --build-arg hadoop_version=${HADOOP_VERSION} \
  -t shepherd9664/hadoop-base:${HADOOP_VERSION} \
  ./
