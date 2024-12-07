ROOT_DIR=$PWD
LOG_FILE=$ROOT_DIR/build.log
rm -f $LOG_FILE

# 确保管道中的错误能被捕获
set -e
set -o pipefail

if [ ! -d "immortalwrt" ]; then
    echo "Cloning immortalwrt..."
    git clone https://github.com/VIKINGYFY/immortalwrt --single-branch --depth 1 || {
        echo "Failed to clone immortalwrt"
        exit 1
    }
fi

cp -f ax6600.config immortalwrt/.config
cd immortalwrt

./scripts/feeds update -a
./scripts/feeds install -a

make clean
make download V=s 2>&1 | tee "$LOG_FILE"
make -j "$(nproc)" V=s 2>&1 | tee "$LOG_FILE"
echo "Build Done!"
