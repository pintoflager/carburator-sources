#!/usr/bin/env sh


# This script is copied to project hooks and runs as a root on a remote node
# during the project registration.

# It should handle the most critical node setup tasks, mainly make sure we have
# what is needed to install a functional carburator project on the node.

# This runs before carburator has even touched on the node.


if ! which setfacl > /dev/null 2>&1; then
	echo "ERROR! Missing ACL program setfacl."
	echo "ACL's are used for project access management. Has to be installed"

	exit 110
fi
