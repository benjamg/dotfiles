# Build and install things needed for dev system that isn't in apt (or we use a different version than in apt)
cores=`nproc`

# ICU
wget http://download.icu-project.org/files/icu4c/51.2/icu4c-51_2-src.tgz
tar -xf icu4c-51_2-src.tgz

pushd icu/source
autoconf && ./configure --with-data-packaging=library --disable-samples && make -j$cores && sudo make install || exit
popd

rm -rf -- icu
sudo ldconfig

