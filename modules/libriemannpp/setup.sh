# Build and install things needed for dev system that isn't in apt (or we use a different version than in apt)
cores=`nproc`

# Riemannpp
wget https://nodeload.github.com/bigdatadev/riemannpp/tar.gz/1.0.2
tar -xf 1.0.2

pushd riemannpp-1.0.2
autoreconf -i && ./configure && make -j$cores && sudo make install || exit
popd

rm -rf -- 1.0.2 riemannpp-1.0.2
sudo ldconfig

