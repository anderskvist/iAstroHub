#!/bin/bash

source build/common.sh

echo "iAstroHub" > /etc/hostname
# 127.0.1.1 was used in the initial README; I believe it should be 127.0.0.1.
echo "127.0.0.1 iAstroHub" >> /etc/hosts
