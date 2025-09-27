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
wget https://github.com/Moe-sushi/tar-static/releases/latest/download/aarch64.tar
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

wget https://github.com/jqlang/jq/releases/latest/download/jq-linux-arm64
if [ $? -ne 0 ]; then
    echo "Failed to download jq-linux-arm64"
    exit 1
fi
mv jq-linux-arm64 jq
chmod +x jq

wget https://github.com/rurioss/rurima/releases/latest/download/aarch64.tar
if [ $? -ne 0 ]; then
    echo "Failed to download aarch64.tar"
    exit 1
fi
tar -xf aarch64.tar
rm aarch64.tar
rm LICENSE
mv rurima rurima-static
rm rurima-dbg

# Get latest coreutils release tag dynamically
COREUTILS_TAG=$(curl -s https://api.github.com/repos/uutils/coreutils/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
if [ -z "$COREUTILS_TAG" ]; then
    echo "Failed to fetch latest coreutils release tag"
    exit 1
fi

COREUTILS_FILENAME="coreutils-${COREUTILS_TAG}-aarch64-unknown-linux-musl.tar.gz"
wget "https://github.com/uutils/coreutils/releases/latest/download/${COREUTILS_FILENAME}"
if [ $? -ne 0 ]; then
    echo "Failed to download ${COREUTILS_FILENAME}"
    exit 1
fi
tar -xf "${COREUTILS_FILENAME}"
rm "${COREUTILS_FILENAME}"
mv "coreutils-${COREUTILS_TAG}-aarch64-unknown-linux-musl/coreutils" ./sha256sum
cp sha256sum du
rm -rf "coreutils-${COREUTILS_TAG}-aarch64-unknown-linux-musl"*
# NOTE: new version doesn't work, use old one
# TODO: fix it
wget https://github.com/RuriOSS/asl/raw/refs/heads/main/system/xbin/curl-static
if [ $? -ne 0 ]; then
    echo "Failed to download curl-static"
    exit 1
fi

wget https://mirrors.tuna.tsinghua.edu.cn/alpine/edge/testing/aarch64/proot-static-5.4.0-r1.apk
if [ $? -ne 0 ]; then
    echo "Failed to download proot-static-5.4.0-r1.apk"
    exit 1
fi
tar -xf proot-static-5.4.0-r1.apk usr/bin/proot.static
mv usr/bin/proot.static proot
rm -rf usr
chmod +x proot
rm proot-static-5.4.0-r1.apk

cp -r /etc/ssl/certs .
cp ../rurima .
cp ../curl .
cp ../file .
rm SHA256SUMS

cat << EOF > fix-perms.sh
#!/bin/sh
if [ "\$(id -u)" -ne 0 ]; then
    echo "This script must be run as root"
    exit 1
fi
for i in *; do
    if [ -f "\$i" ]; then
        chmod 777 "\$i"
    fi
done
chmod a+s newuidmap
chmod a+s newgidmap