if [ ! -d "immortalwrt" ]; then
    git clone https://github.com/VIKINGYFY/immortalwrt --single-branch --depth 1 || exit 1
fi

cp -f ax6600.config immortalwrt/.config
cd immortalwrt

./scripts/feeds update -a
./scripts/feeds install -a

make download V=s
make -j$(nproc) V=s
