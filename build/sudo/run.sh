#!/bin/bash

source build/common.sh

apt-get -y install sudo

echo "ALL ALL=(ALL) NOPASSWD: ALL" | (EDITOR="tee -a" visudo)
