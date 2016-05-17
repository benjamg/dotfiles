# Build and install things needed for dev system that isn't in apt (or we use a different version than in apt)
cores=`nproc`

# protobuf
wget https://nodeload.github.com/google/protobuf/tar.gz/v2.6.1
tar -xf v2.6.1

pushd protobuf-2.6.1
./autogen.sh -i && ./configure && make -j$cores && sudo make install || exit
popd

rm -rf -- v2.6.1 protobuf-2.6.1
sudo ldconfig

