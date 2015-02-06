#!/bin/bash

git clone https://github.com/gmarik/vundle ~/.vim/bundle/vundle
vim +BundleInstall +qall
pushd ~/.vim/bundle/YouCompleteMe
./install.sh --clang-completer
popd

