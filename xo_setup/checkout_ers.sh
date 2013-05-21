#!/bin/bash

if [ `id -u` -ne 0 ]; then
	echo 'Run me as root'
	exit -1
fi

if [ -d /root/ers/.git ]; then
	echo '/root/ers working copy already exists'
else
	if [ -d /root/ers ]; then
		echo 'ERROR: /root/ers already exists but it is not a working copy. Please move it out of the way.'
		exit -1
	fi

	(cd /root; git clone https://github.com/ers-devs/ers.git; git checkout develop)
fi
