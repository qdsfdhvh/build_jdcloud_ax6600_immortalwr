#!/bin/bash

# 更新并安装依赖 https://openwrt.org/docs/guide-developer/toolchain/install-buildsystem#debianubuntumint
# sudo apt update -y
# sudo apt install -y ack antlr3 asciidoc autoconf automake autopoint \
#     binutils bison build-essential bzip2 ccache clang cmake cpio curl \
#     device-tree-compiler ecj fastjar flex gawk gettext gcc-multilib \
#     g++-multilib git gnutls-dev gperf haveged help2man intltool lib32gcc-s1 \
#     libc6-dev-i386 libelf-dev libglib2.0-dev libgmp3-dev libltdl-dev libmpc-dev \
#     libmpfr-dev libncurses-dev libpython3-dev libreadline-dev libssl-dev libtool \
#     libyaml-dev libz-dev lld llvm lrzsz mkisofs msmtp nano ninja-build p7zip p7zip-full \
#     patch pkgconf python3 python3-pip python3-ply python3-docutils python3-pyelftools \
#     qemu-utils re2c rsync scons squashfs-tools subversion swig texinfo uglifyjs upx-ucl \
#     unzip vim wget xmlto xxd zlib1g-dev g++ libncurses5-dev file
# sudo apt clean

ROOT_DIR=$PWD
LOG_FILE=$ROOT_DIR/build.log
rm -f $LOG_FILE

if [ ! -d "wrt/" ]; then
    echo "Cloning wrt..."
    git clone https://github.com/VIKINGYFY/immortalwrt --single-branch --depth 1 wrt/ || {
        echo "Failed to clone immortalwrt"
        exit 1
    }
fi
cd wrt/

# 复制配置文件
# cp -f $ROOT_DIR/ax6600.config .config
cp -f "$ROOT_DIR/Config_IPQ60XX-WIFI-YES_immortalwrt.git-main_24.12.12_04.25.49.txt" .config

# 更新并安装 feeds
./scripts/feeds update -a
./scripts/feeds install -a

# 下载和编译
make download -j$(nproc) 2>&1 | tee "$LOG_FILE"
make -j1 V=s 2>&1 | tee "$LOG_FILE"
