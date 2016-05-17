# Build and install things needed for dev system that isn't in apt (or we use a different version than in apt)
cores=`nproc`

# protobuf-c
wget https://nodeload.github.com/protobuf-c/protobuf-c/tar.gz/v1.1.0
tar -xf v1.1.0

pushd protobuf-c-1.1.0
./autogen.sh && ./configure && make -j$cores && sudo make install || exit
popd

rm -rf -- v1.1.0 protobuf-c-1.1.0
sudo ldconfig

