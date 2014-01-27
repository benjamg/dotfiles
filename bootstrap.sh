#!/bin/bash

# TODO: check I'm still using ubuntu, as this is unlikely to work elsewhere

sudo apt-get -y install git
git clone git@github.com:benjamg/dotfiles .dotfiles

basedir=`pwd`

cd .dotfiles
./setup.sh
cd $basedir

