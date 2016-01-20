# Build and install things needed for dev system that isn't in apt (or we use a different version than in apt)
cores=`nproc`

# Mecab
wget http://mecab.googlecode.com/files/mecab-0.996.tar.gz
tar -xf mecab-0.996.tar.gz
pushd mecab-0.996
autoconf && ./configure --enable-utf8-only && make -j$cores && sudo make install || exit
popd

sudo ldconfig

wget https://mecab.googlecode.com/files/mecab-ipadic-2.7.0-20070801.tar.gz
tar -xf mecab-ipadic-2.7.0-20070801.tar.gz
pushd mecab-ipadic-2.7.0-20070801
autoconf && ./configure --with-charset=utf-8 && make -j$cores && sudo make install || exit
popd

sudo ldconfig

rm -rf -- mecab-0.996 mecab-ipadic-2.7.0-20070801
