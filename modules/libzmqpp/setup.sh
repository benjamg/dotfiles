# Build and install things needed for dev system that isn't in apt (or we use a different version than in apt)
cores=`nproc`

mkdir tmp
pushd tmp

# Zmqpp - DS fork
git clone git://github.com/datasift/zmqpp.git
pushd zmqpp
make -j$cores && sudo make install || exit
popd

rm -rf -- zmqpp
sudo ldconfig

