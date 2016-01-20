# Build and install things needed for dev system that isn't in apt (or we use a different version than in apt)
cores=`nproc`

# ZeroMQ - DS fork
git clone git@github.com:datasift/zeromq4-x.git
pushd zeromq4-x
./autogen.sh && ./configure && make -j$cores && sudo make install || exit
popd

rm -rf -- zeromq4-x
sudo ldconfig

