# Build and install things needed for dev system that isn't in apt (or we use a different version than in apt)
cores=`nproc`

# Boost
wget http://downloads.sourceforge.net/boost/boost_1_57_0.tar.bz2
tar -xf boost_1_57_0.tar.bz2

pushd boost_1_57_0
./bootstrap.sh && ./b2 -j$cores --without-python --without-wave --without-mpi && sudo ./b2 --without-python --without-wave --without-mpi install || exit
popd

rm -rf -- boost_1_57_0
sudo ldconfig
