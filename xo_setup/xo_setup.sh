#!/bin/bash

# Download this on the XO using:
#
# wget https://raw.github.com/ers-devs/ers-utils/master/xo_setup/xo_setup.sh


function ensure_root {
	if [ `id -u` -ne 0 ]; then
		echo 'Run me as root'
		exit -1
	fi	
}

function show_help {
	echo "$0 install_git     : Install Git"
	echo "$0 install_pip     : Install Pip (the Python package manager)"
	echo "$0 checkout_ers    : Check out ERS repository in /root"
	echo "$0 get_py_libs     : Download site-packages for ERS"
	echo "$0 update_self     : Update this script with latest from repo"
}

function install_git {
	if [ -n "`which git`" ]; then
		echo 'Git is already installed'
	else
		echo 'Installing Git...'

		yum clean all

		rpm -i http://dl.fedoraproject.org/pub/fedora/linux/releases/18/Everything/i386/os/Packages/p/perl-Error-0.17018-4.fc18.noarch.rpm
		rpm -i http://dl.fedoraproject.org/pub/fedora/linux/updates/18/i386/git-1.8.1.4-2.fc18.i686.rpm http://dl.fedoraproject.org/pub/fedora/linux/updates/18/i386/perl-Git-1.8.1.4-2.fc18.noarch.rpm

		if [ -z "`which git`" ]; then
			echo 'ERROR: Failed to install Git!'
			exit -1
		fi

		echo 'Git is now installed'
	fi
}

function install_pip {
	if [ -n "`which pip`" ]; then
		echo 'Pip is already installed'
	else
		echo 'Installing Pip...'

		curl -O http://python-distribute.org/distribute_setup.py
		python distribute_setup.py
		rm distribute_setup.py
		easy_install pip

		if [ -z "`which pip`" ]; then
			echo 'ERROR: Failed to install Pip!'
			exit -1
		fi

		echo 'Pip is now installed'
	fi
}

function get_py_libs {
	curl https://raw.github.com/ers-devs/ers-utils/master/xo_setup/site-packages.tar | tar -x -P --transform=s:^:/lib/python2.7/:

	echo 'site-packages updated'
}

function checkout_ers {
	if [ -d /root/ers/.git ]; then
		echo '/root/ers working copy already exists'
	else
		if [ -d /root/ers ]; then
			echo 'ERROR: /root/ers already exists but it is not a working copy. Please move it out of the way.'
			exit -1
		fi

		(cd /root; git clone https://github.com/ers-devs/ers.git; cd ers; git checkout develop)
	fi
}

function update_self {
	curl https://raw.github.com/ers-devs/ers-utils/master/xo_setup/xo_setup.sh -o $0; chmod a+x $0; exit
}

ensure_root

case "$1" in
	install_git)        install_git;;
    install_pip)        install_pip;;
	checkout_ers)       checkout_ers;;
	get_py_libs)        get_py_libs;;
	update_self)        update_self;;
	*)                  show_help;;
esac
