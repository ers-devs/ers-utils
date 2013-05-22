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
	echo "$0 checkout_ers    : Check out ERS repository in /root"
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

function checkout_ers {
	if [ -d /root/ers/.git ]; then
		echo '/root/ers working copy already exists'
	else
		if [ -d /root/ers ]; then
			echo 'ERROR: /root/ers already exists but it is not a working copy. Please move it out of the way.'
			exit -1
		fi

		(cd /root; git clone https://github.com/ers-devs/ers.git; git checkout develop)
	fi
}

function update_self {
	wget https://raw.github.com/ers-devs/ers-utils/master/xo_setup/xo_setup.sh -O $0
	chmod a+x $0
}

ensure_root

case "$1" in
	install_git)        install_git;;
	checkout_ers)       checkout_ers;;
	update_self)        update_self;;
	*)                  show_help;;
esac
