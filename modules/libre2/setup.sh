# Build and install things needed for dev system that isn't in apt (or we use a different version than in apt)
cores=`nproc`

# Re2
hg clone https://re2.googlecode.com/hg re2
pushd re2
make -j$cores && sudo make install || exit
popd

rm -rf -- re2
sudo ldconfig

