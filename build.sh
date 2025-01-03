#!/bin/bash

if [ ! -d "wrt/" ]; then
    echo "Cloning wrt..."
    git clone https://github.com/VIKINGYFY/immortalwrt --single-branch --depth 1 wrt/ || {
        echo "Failed to clone immortalwrt"
        exit 1
    }
fi
cd wrt/

# 更新并安装 feeds
./scripts/feeds update -a
./scripts/feeds install -a

# 安装自定义软件包
cd package/
$ROOT_DIR/Scripts/Packages.sh
$ROOT_DIR/Scripts/Handles.sh
cd ..

# 复制配置文件
# cp -f $ROOT_DIR/ax6600.config .config
cp -f $ROOT_DIR/Config_IPQ60XX-WIFI-YES_immortalwrt.git-main_25.01.02_14.25.59.txt .config
make defconfig -j$(nproc)

# 下载和编译
make download -j$(nproc)
make -j$(nproc) V=s
