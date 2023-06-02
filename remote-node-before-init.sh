#!/usr/bin/env sh


# This script is copied to project event listeners and runs as a root on a remote
# node during the project registration.

# It should handle the most critical node setup tasks, mainly make sure we have
# what is needed to install a functional carburator project on the node.

# This runs before carburator has even touched on the node.


# ACL's
if ! which setfacl > /dev/null 2>&1; then
	# Debian and Ubuntu
	if which apt > /dev/null 2>&1; then
		apt-get -y update
		apt-get -y install acl
	fi

	# Arch Linux
	if which pacman > /dev/null 2>&1; then
		pacman -y update
		pacman -Suy acl
	fi

	# Fedora
	if which dnf > /dev/null 2>&1; then
		dnf makecache --refresh
		dnf -y install acl
	elif which yum > /dev/null 2>&1; then
		yum makecache --refresh
		yum -y install acl
	fi

	# Alpine Linux
	if which apk > /dev/null 2>&1; then
		apk update -f
		apk add acl -f
	fi
fi
