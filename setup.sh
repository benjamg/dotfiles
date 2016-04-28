#!/bin/bash

set -e
ERROR_APP_NAME=$0

function die()
{
    echo "${ERROR_APP_NAME}: ${1}" 1>&2
    exit 1
}

function process_module()
{
	if [[ ! -d $base_dir/modules/$1 ]]; then
		die "Unable to locate module '$1'"
	fi

	# Do we have stow config
	if [[ -d $base_dir/modules/$1/stow ]]; then
		stow -v -d $base_dir/modules/$1 -t ~ stow
	fi

	# Do we have a setup script
	if [[ -f $base_dir/modules/$1/setup.sh ]]; then
		$base_dir/modules/$1/setup.sh
	fi
}

function check_module()
{
	if [[ ! -d $base_dir/modules/$1 ]]; then
		die "Unable to locate module '$1'"
	fi

	if grep -qF $1 modules; then
		return # we've processed this
	fi

	if [[ -f $base_dir/modules/$1/requires ]]; then
		for module in `cat $base_dir/modules/$1/requires`; do
			check_module $module
		done
	fi

	echo $1 >> modules

	if [[ -f $base_dir/modules/$1/packages ]]; then cat $base_dir/modules/$1/packages >> packages; fi	
}

function process_role()
{
	if [[ ! -f $base_dir/roles/$1 ]]; then
		die "Unable to locate role file '$1'"
    fi

	for parent in `grep role: $base_dir/roles/$1 | sed 's/^role://'`; do
		process_role $parent
	done		

	for module in `grep -v role: $base_dir/roles/$1`; do
		check_module $module
	done

	grep -qF $1 roles || echo $1 >> roles
}

if [[ -z $1 ]]; then
	echo "Usage: $0 [OPTIONS] ROLE..."
	echo '(re-)installs machine for use for chosen roles'
	echo
	echo 'Known roles are;'
	ls roles
	exit
fi

base_dir=`pwd`
# Tools
sudo apt-get -y install stow

# Role
tmp_dir=`mktemp -d`
pushd $tmp_dir

touch roles modules packages

for role in "$@"; do
	process_role $role
done

cat roles | sort | xargs echo "Setting up for roles"
cat modules | sort | xargs echo "Installing modules"
echo

cat packages | sort -u | xargs echo "Installing required packages"
cat packages | sort -u | xargs sudo apt-get -y install
echo

for module in `cat modules`; do
	echo "processing $module"
	process_module $module
	echo
done

echo
echo install complete

popd

