sudo apt -y update
sudo apt -y install git curl wget\
    build-essential \
    asciidoc \
    binutils \
    bzip2 \
    gawk \
    gettext \
    libncurses5-dev \
    libz-dev \
    patch \
    python3 \
    unzip \
    zlib1g-dev \
    lib32gcc-s1 \
    libc6-dev-i386 \
    subversion \
    flex \
    uglifyjs \
    gcc-multilib \
    p7zip-full\
    msmtp \
    libssl-dev \
    texinfo \
    libglib2.0-dev \
    xmlto \
    qemu-utils \
    upx \
    libelf-dev \
    autoconf \
    automake \
    libtool \
    autopoint\
    device-tree-compiler \
    g++-multilib \
    antlr3 \
    gperf \
    swig \
    rsync \
    genisoimage
sudo bash -c 'bash <(curl -sL https://build-scripts.immortalwrt.org/init_build_environment.sh)'

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

./scripts/feeds update -a
./scripts/feeds install -a

cp -f $ROOT_DIR/ax6600.config .config
# make defconfig

make download -j$(nproc) 2>&1 | tee "$LOG_FILE"
make -j$(nproc) V=s 2>&1 | tee "$LOG_FILE"

echo "Build Done!"
