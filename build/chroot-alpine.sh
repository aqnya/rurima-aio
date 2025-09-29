apt update
apt install -y sudo
sudo apt install -y git wget
yes|sudo apt install --no-install-recommends -y curl xz-utils \
              make \
              clang \
              libseccomp-dev \
              libcap-dev \
              libc6-dev \
              binutils 
git clone https://github.com/moe-hacker/rootfstool
rootfstool/rootfstool d -d alpine -v edge
mkdir alpine
sudo tar -xvf rootfs.tar.xz -C alpine
git clone https://github.com/moe-hacker/ruri
cd ruri
cc -Wl,--gc-sections -static src/*.c src/easteregg/*.c -o ruri -lcap -lseccomp -lpthread
cd ..
cat << 'EOF' | sudo tee alpine/build.sh
#!/bin/sh
rm /etc/resolv.conf
echo "nameserver 1.1.1.1" > /etc/resolv.conf
echo https://dl-cdn.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories
apk update
apk add bash curl wget sudo coreutils clang make git
apk add wget make clang git xz-dev libintl libbsd-static libsemanage-dev libselinux-utils libselinux-static xz-libs zlib zlib-static libselinux-dev linux-headers libssl3 libbsd libbsd-dev gettext-libs gettext-static gettext-dev gettext python3 build-base openssl-misc openssl-libs-static openssl zlib-dev xz-dev openssl-dev automake libtool bison flex gettext autoconf gettext sqlite sqlite-dev pcre-dev wget texinfo docbook-xsl libxslt docbook2x musl-dev gettext gettext-asprintf gettext-dbg gettext-dev gettext-doc gettext-envsubst gettext-lang gettext-libs gettext-static
apk add upx
git clone https://github.com/rurioss/rurima-aio
cd rurima-aio
make
mv out rurima-aio
tar -cvf /$(uname -m).tar rurima-aio
EOF
sudo chmod +x alpine/build.sh
sudo ./ruri/ruri ./alpine /bin/sh /build.sh
cp alpine/$(uname -m).tar .