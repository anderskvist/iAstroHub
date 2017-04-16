#!/bin/sh

./clean
./configure
docker build -t iastrohub ./
rm Dockerfile
