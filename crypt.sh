#!/bin/bash

sudo mkdir -p /run/secrets
dd if=/dev/urandom of=./syskey.key bs=1 count=64
dd if=/dev/urandom of=./extkey.key bs=1 count=64
chmod 0400 ./syskey.key
chmod 0400 ./extkey.key

sudo cryptsetup luksAddKey /dev/disk/by-label/SYSTEM ./syskey.key
#sudo cryptsetup luksAddKey /dev/disk/by-label/STORAGE ./extkey.key

sudo cp ./syskey.key /run/secrets/syskey.key
#sudo cp ./extkey.key /extkey.key
