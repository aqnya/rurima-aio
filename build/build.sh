#!/bin/bash
mkdir out
cd out
wget https://github.com/Moe-sushi/xz-static/releases/latest/download/aarch64.tar
if [ $? -ne 0 ]; then
    echo "Failed to download aarch64.tar"
    exit 1
fi
tar -xf aarch64.tar
rm aarch64.tar
wget https://github.com/Moe-sushi/gzip-static/releases/latest/download/aarch64.tar
if [ $? -ne 0 ]; then
    echo "Failed to download aarch64.tar"
    exit 1
fi
tar -xf aarch64.tar
rm aarch64.tar
wget https://github.com/Moe-sushi/file-static/releases/latest/download/aarch64.tar
if [ $? -ne 0 ]; then
    echo "Failed to download aarch64.tar"
    exit 1
fi
tar -xf aarch64.tar
rm aarch64.tar
wget https://github.com/Moe-sushi/uidmap-static/releases/latest/download/aarch64.tar
if [ $? -ne 0 ]; then
    echo "Failed to download aarch64.tar"
    exit 1
fi
tar -xf aarch64.tar
rm aarch64.tar
rm LICENSE-*