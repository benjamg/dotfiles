# Build and install things needed for dev system that isn't in apt (or we use a different version than in apt)
cores=`nproc`

# Riemann-c-client
wget https://nodeload.github.com/algernon/riemann-c-client/tar.gz/riemann-c-client-1.5.0
tar -xf riemann-c-client-1.5.0

pushd riemann-c-client-riemann-c-client-1.5.0
autoreconf -i && ./configure && make -j$cores && sudo make install || exit
popd

rm -rf -- riemann-c-client-1.5.0 riemann-c-client-riemann-c-client-1.5.0
sudo ldconfig

