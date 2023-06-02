#!/usr/bin/env sh


# This script is copied to project event listeners and runs as a root on a remote
# node during the project registration.

# It should handle the most critical node setup finalization tasks, mainly it
# should make sure our SSH port is not blocked by a firewall.

# Init script should of had set up node's SSH port and restarted sshd service
# before this script is executed.

# Active ssh port can be found from environment variable 'SSH_PORT' and the
# previously active port from 'SSH_PORT_OLD' variable.


# Ufw, firewall that manages iptables. Usually found from debian world.
if which ufw > /dev/null 2>&1; then
	# If it's enabled wank the ports.
	ufw status > stat.tmp

	if grep -q "Status: active" stat.tmp; then
		ufw allow "$SSH_PORT/tcp"
		ufw deny "$SSH_PORT_OLD/tcp"
	fi

	rm -f stat.tmp
fi

# SElinux, security thingy that manages permissions for files, processes...
if which sestatus > /dev/null 2>&1; then
	# If it's enabled wank the ports.
	sestatus > stat.tmp

	if grep -q "status:	enabled" stat.tmp; then
		semanage port -a -t ssh_port_t -p tcp "$SSH_PORT"
		semanage port -d -p tcp "$SSH_PORT_OLD"
	fi

	rm -f stat.tmp
fi

# Firewalld, as ufw but supposedly easier and better and whatmore.
if which firewall-cmd > /dev/null 2>&1; then
	# If it's enabled wank the ports.
	firewall-cmd --state > stat.tmp

	if grep -q "running" stat.tmp; then
		firewall-cmd --zone=public --permanent --add-port="$SSH_PORT/tcp"
		firewall-cmd --zone=public --permanent --remove-port="$SSH_PORT_OLD/tcp"
	fi

	rm -f stat.tmp
fi

