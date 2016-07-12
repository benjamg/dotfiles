# Build and install things needed for dev system that isn't in apt (or we use a different version than in apt)
cores=`nproc`

# Xxhash
git clone git@github.com:Cyan4973/xxHash.git
pushd xxHash
gcc -shared -o libxxhash.so -c -fpic xxhash.c
sudo install -D libxxhash.so /usr/local/lib/libxxhash.so.1.0.0
sudo install -D xxhash.h /usr/local/include/
sudo ln -s /usr/local/lib/libxxhash.so.1.0.0 /usr/local/lib/libxxhash.so.1
sudo ln -s /usr/local/lib/libxxhash.so.1.0.0 /usr/local/lib/libxxhash.so
popd

rm -rf -- xxHash
sudo ldconfig

