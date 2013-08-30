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
	echo "To just install everything on a pristine XO, use:"
	echo
	echo "    $0 all"
	echo
	echo "Or, for more precise operations, use any of the following:"
	echo
	echo "    $0 update_self     : Update this script with latest from repo"
	echo "    $0 install_pip     : Install Pip (the Python package manager)"
	echo "    $0 get_site_pkgs   : Download site-packages for ERS"
	echo "    $0 get_py_libs     : Install Python libraries for ERS"
	echo "    $0 install_git     : Install Git"
	echo "    $0 checkout_ers    : Check out ERS repository in /root"
	echo "    $0 install_service : Install ERS as systemd service"
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
		rm distribute*.tar.gz
		easy_install pip

		if [ -z "`which pip`" ]; then
			echo 'ERROR: Failed to install Pip!'
			exit -1
		fi

		echo 'Pip is now installed'
	fi
}

function get_site_pkgs {
	curl https://raw.github.com/ers-devs/ers-utils/master/xo_setup/site-packages.tar | tar -x -P --transform=s:^:/lib/python2.7/:

	echo 'site-packages updated'
}

function get_py_libs {
	pip install couchdbkit rdflib

	echo 'Python libs installed'
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

function install_service {
	cat << 'EOF' > /lib/systemd/system/ers.service
[Unit]
Description=ERS Service
Requires=couchdb.service
After=couchdb.service

[Service]
User=root
Group=root
Type=simple
StandardOutput=journal
StandardError=journal
Restart=always
StartLimitInterval=10
StartLimitBurst=5
ExecStart=/usr/bin/python -m ers.daemon --pidfile=none --logtype=syslog

[Install]
WantedBy=multi-user.target
EOF

    systemctl enable ers
}

function install_all {
	install_pip
	get_site_pkgs
	get_py_libs
	install_git
	checkout_ers
	install_service
}

function update_self {
	curl https://raw.github.com/ers-devs/ers-utils/master/xo_setup/xo_setup.sh -o $0; chmod a+x $0; exit
}

ensure_root

case "$1" in
	all)                install_all;;
	install_pip)        install_pip;;
	get_site_pkgs)      get_site_pkgs;;
	get_py_libs)        get_py_libs;;
	install_git)        install_git;;
	checkout_ers)       checkout_ers;;
    install_service)    install_service;;
	update_self)        update_self;;
	*)                  show_help;;
esac
