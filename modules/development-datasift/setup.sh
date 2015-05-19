#modified the ansi colour to push yellow back towards yellow - this is for our production/staging terminal colours
gconftool-2 --set "/apps/gnome-terminal/profiles/Default/palette" --type string "#070736364242:#D3D301010202:#858599990000:#B5B589890000:#26268B8BD2D2:#D3D336368282:#2A2AA1A19898:#EEEEE8E8D5D5:#00002B2B3636:#CBCB4B4B1616:#58586E6E7575:#EDEDD4D40000:#838394949696:#6C6C7171C4C4:#9393A1A1A1A1:#FDFDF6F6E3E3"

# Build and install things needed for dev system that isn't in apt (or we use a different version than in apt)
cores=`nproc`

mkdir tmp
pushd tmp

# ICU
wget http://download.icu-project.org/files/icu4c/51.2/icu4c-51_2-src.tgz
tar -xf icu4c-51_2-src.tgz
pushd icu/source
autoconf && ./configure --with-data-packaging=library --disable-samples && make -j$cores && sudo make install || exit
popd

# Mecab
wget http://mecab.googlecode.com/files/mecab-0.996.tar.gz
tar -xf mecab-0.996.tar.gz
pushd mecab-0.996
autoconf && ./configure --enable-utf8-only && make -j$cores && sudo make install || exit
popd

wget https://mecab.googlecode.com/files/mecab-ipadic-2.7.0-20070801.tar.gz
tar -xf mecab-ipadic-2.7.0-20070801.tar.gz
pushd mecab-ipadic-2.7.0-20070801
autoconf && ./configure --with-charset=utf-8 && make -j$cores && sudo make install || exit
popd

# Boost
wget http://downloads.sourceforge.net/boost/boost_1_57_0.tar.bz2
tar -xf boost_1_57_0.tar.bz2
pushd boost_1_57_0
./bootstrap.sh && ./b2 -j$cores --without-python --without-wave --without-mpi && sudo ./b2 --without-python --without-wave --without-mpi install || exit
popd

# Kafka-cpp - hacky
#wget https://github.com/datasift/kafka-cpp/archive/1.0.2.tar.gz
#tar -xf 1.0.2.tar.gz
#pushd kafka-cpp-1.0.2
#sed 's/AUTOMAKE_OPTIONS=foreign/AUTOMAKE_OPTIONS=foreign subdir-objects' Makefile.am -i
#autoreconf -if && ./configure && make -j$cores && sudo make install || exit
#popd

# ZeroMQ - DS fork
git clone git@github.com:datasift/zeromq4-x.git
pushd zeromq4-x
./autogen.sh && ./configure && make -j$cores && sudo make install || exit
popd

# Zmqpp - DS fork
git clone git://github.com/datasift/zmqpp.git
pushd zmqpp
make -j$cores && sudo make install || exit
popd

# Re2
hg clone https://re2.googlecode.com/hg re2
pushd re2
make -j$cores && sudo make install || exit
popd

# Xxhash
svn checkout https://xxhash.googlecode.com/svn/trunk xxhash
pushd xxhash
gcc -shared -o libxxhash.so -c -fpic xxhash.c
sudo install -D libxxhash.so /usr/local/lib/libxxhash.so.1.0.0
sudo install -D libxxhash.so /usr/local/lib/
sudo install -D xxhash.h /usr/local/include/
sudo ln /usr/local/lib/libxxhash.so.1.0.0 /usr/local/libxxhash.so.1
sudo ln /usr/local/lib/libxxhash.so.1.0.0 /usr/local/libxxhash.so
popd

popd
rm -rf -- tmp
sudo ldconfig

