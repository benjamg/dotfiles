#!/bin/bash

ERROR_APP_NAME=$0

function die()
{
    echo "${ERROR_APP_NAME}: ${1}" 1>&2
    exit 1
}

function process_role()
{
    if [[ -z $1 ]]; then die "No role passed to process_role function."
    fi

	if [[ ! -f roles/$1 ]]; then
		die "Unable to locate role file '$1'"
	fi

	
	# Check parents
	for parent in `grep role: roles/$1 | sed 's/^role://'`
	do
		echo "processing roles/$parent"
		process_role $parent
	done

	echo "applying roles/$1"

	# Build module deps
	modules=( $(grep -v role: roles/$1) )
	keys=()
	repos=()
	packages=()

	for m in ${modules[@]}
	do
		if [[ ! -d modules/$m ]]; then die "Unable to locate module '$m'"; fi
		if [[ -f modules/$m/apt_keys ]]; then keys+=( $(cat modules/$m/apt_keys | xargs -0) ); fi
		if [[ -f modules/$m/apt_repos ]]; then repos+=( $(cat modules/$m/apt_repos | xargs -0) ); fi
		if [[ -f modules/$m/packages ]]; then packages+=( $(cat modules/$m/packages | xargs -0) ); fi
	done

	# Add PPAs (and keys)
	for key in ${keys[@]}
	do
		sudo add-key adv --keyserver keyserver.ubuntu.com --recv-keys $key
	done

	for repo in $repos
	do
		sudo add-apt-repository -u $repo
	done

	# Update
	sudo apt-get update

	# Packages
	sudo apt-get -y install ${packages[@]}

	for m in ${modules[@]}
	do
		# Stow Configurations
		if [[ -f modules/$m/stow ]]; then
			stow -v -d modules/$m -t ~ stow
		fi

		# Setup
		if [[ -f modules/$m/setup.sh ]]; then
			./modules/$m/setup.sh
		fi
	done
}


base_dir=`pwd`
role="$1"

if [[ -z $role ]]; then
	exit_option="exit";
	options=( $(ls -1 roles | grep -v common | xargs -0) )
	PS3="Select role or exit: "
	select opt in "${options[@]}" "$exit_option"
	do
		if [[ $opt == $exit_option ]]; then
			exit
		fi
		if [[ -n $opt ]]; then
			role="$opt"
			break
		fi
	done
fi

# Tools
sudo apt-get -y remove vim-tiny
sudo apt-get -y install curl grc stow

# Role
echo building for $role
process_role $role

