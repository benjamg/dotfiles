# Build and install things needed for dev system that isn't in apt (or we use a different version than in apt)
cores=`nproc`

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

rm -rf -- xxhash
sudo ldconfig

