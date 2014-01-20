#!/bin/bash

base_dir=`pwd`
location="home"
if [[ `whoami` == "bgray" ]]; then location="work"; fi

echo building for $location
sleep 3

# Add updated PPAs
sudo add-apt-repository ppa:nmi/vim-snapshots

# Add sources
if [ ! -f /etc/apt/sources.list.d/playonlinux.list ]; then
	sudo wget http://deb.playonlinux.com/playonlinux_quantal.list -O /etc/apt/sources.list.d/playonlinux.list
	sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E0F72778C4676186
fi

if [ ! -f /etc/apt/sources.list.d/spotify.list ]; then
	echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
	sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 94558F59
fi

# Update
sudo apt-get update

# Tools
sudo apt-get -y install curl grc stow

# Git Setup
stow -v git-$location
sudo apt-get -y install git-flow

# Vim setup
stow -v vim
sudo apt-get -y remove vim-tiny
sudo apt-get -y install autoconf build-essential cmake g++ gcc python-dev vim
git clone https://github.com/gmarik/vundle ~/.vim/bundle/vundle
vim +BundleInstall +qall
cd ~/.vim/bundle/YouCompleteMe
./install.sh --clang-completer
cd -

# Spotify
sudo apt-get -y install spotify-client dconf-tools
# TODO: have a mix of gsettings and gconftool here, fix
echo "use: dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause"
# gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/spotifypause/']"
# gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/spotifypause/ binding 'XF86AudioPlay'
# gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/spotifypause/ command 'dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause'
# gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/spotifypause/ name 'Spotify Play/Pause'

# Solarized setup - stolen from @mheap "http://michaelheap.com/getting-solarized-working-on-ubuntu"
gconftool-2 --set "/apps/gnome-terminal/profiles/Default/use_theme_background" --type bool false
gconftool-2 --set "/apps/gnome-terminal/profiles/Default/use_theme_colors" --type bool false
gconftool-2 --set "/apps/gnome-terminal/profiles/Default/palette" --type string "#070736364242:#D3D301010202:#858599990000:#B5B589890000:#26268B8BD2D2:#D3D336368282:#2A2AA1A19898:#EEEEE8E8D5D5:#00002B2B3636:#CBCB4B4B1616:#58586E6E7575:#65657B7B8383:#838394949696:#6C6C7171C4C4:#9393A1A1A1A1:#FDFDF6F6E3E3"
gconftool-2 --set "/apps/gnome-terminal/profiles/Default/background_color" --type string "#00002B2B3636"
gconftool-2 --set "/apps/gnome-terminal/profiles/Default/foreground_color" --type string "#65657B7B8383"

if [ $location == "work" ]; then
	# modified the ansi colour to push yellow back towards yellow - this is for our production/staging terminal colours
	gconftool-2 --set "/apps/gnome-terminal/profiles/Default/palette" --type string "#070736364242:#D3D301010202:#858599990000:#B5B589890000:#26268B8BD2D2:#D3D336368282:#2A2AA1A19898:#EEEEE8E8D5D5:#00002B2B3636:#CBCB4B4B1616:#58586E6E7575:#EDEDD4D40000:#838394949696:#6C6C7171C4C4:#9393A1A1A1A1:#FDFDF6F6E3E3"

	# Install things we need for dev system
	sudo apt-get -y install doxygen libboost-all-dev libbz2-dev \
		libcurl4-openssl-dev libevent-dev libhiredis-dev libicu-dev \
		liblog4cxx10-dev libmecab-dev libmemcached-dev libmysql++-dev \
		libpcre3-dev libpcre++-dev libtool libzookeeper-mt-dev mecab-ipadic-utf8 \
		mercurial openjdk-6-jdk subversion uuid-dev zlib1g-dev

	# Down install things needed for dev system that isn't in apt
	mkdir tmp
	cd tmp
	cores=`nproc`

	# Rudiments
	wget http://heanet.dl.sourceforge.net/project/rudiments/rudiments/0.32/rudiments-0.32.tar.gz
	tar -xf rudiments-0.32.tar.gz
	cd rudiments-0.32
	./configure && make -j$cores && sudo make install
	cd -

	# Kafka-cpp
	wget https://github.com/datasift/kafka-cpp/archive/1.0.1.tar.gz
	tar -xf 1.0.1.tar.gz
	cd kafak-cpp-1.0.1
	autoreconf -if && ./configure && make -j$cores && sudo make install
	cd -

	# ZeroMQ - DS fork
	git clone git@github.com:datasift/zeromq4-x.git
	cd zeromq4-x
	./autogen.sh && ./configure && make -j$cores && sudo make install
	cd -

	# Zmqpp - DS fork
	git clone git://github.com/datasift/zmqpp.git
	cd zmqpp
	make -j$cores && sudo make install
	cd -

	# Re2
	hg clone https://re2.googlecode.com/hg re2
	cd re2
	make -j$cores && sudo make install
	cd -

	# Xxhash
	svn checkout https://xxhash.googlecode.com/svn/trunk xxhash
	cd xxhash
	gcc -shared -o libxxhash.so -c -fpic xxhash.c
	sudo install -D libxxhash.so /usr/local/lib/libxxhash.so.1.0.0
	sudo install -D xxhash.h /usr/local/include/xxhash.so
	sudo ln /usr/local/lib/libxxhash.so.1.0.0 /usr/local/libxxhash.so.1
	sudo ln /usr/local/lib/libxxhash.so.1.0.0 /usr/local/libxxhash.so
	cd -

	rm -r tmp
	sudo ldconfig

	cd $base_dir
fi
