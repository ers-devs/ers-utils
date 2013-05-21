#!/bin/bash

if [ `id -u` -ne 0 ]; then
	echo 'Run me as root'
	exit -1
fi

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
