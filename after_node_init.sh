#!/usr/bin/env bash


# This script is copied to project hooks and runs as a root on a remote node
# during the project installation.

# It should handle the most critical node setup tasks, mainly make sure our SSH port
# is not blocked by a firewall.

# Carburator has set up node's SSH port and restarted sshd service before this
# script is uploaded and executed.

# Active ssh port can be found from environment variable SSH_PORT and the
# previously active SSH_PORT_OLD


# Ufw, firewall that manages iptables. Usually found from debian world.
if which ufw &>/dev/null; then
	# If it's enabled wank the ports.
	if grep -q "Status: active" < <(ufw status); then
		ufw allow "$SSH_PORT/tcp"
		ufw deny "$SSH_PORT_OLD/tcp"
	fi
fi

# SElinux, security thingy that manages permissions for files, processes...
if which sestatus &>/dev/null; then
	# If it's enabled wank the ports.
	if grep -q "status:	enabled" < <(sestatus); then
		semanage port -a -t ssh_port_t -p tcp "$SSH_PORT"
		semanage port -d -p tcp "$SSH_PORT_OLD"
	fi
fi

# Firewalld, as ufw but supposedly easier and better and whatmore.
if which firewall-cmd &>/dev/null; then
	# If it's enabled wank the ports.
	if grep -q "running" < <(firewall-cmd --state); then
		firewall-cmd --zone=public --permanent --add-port="$SSH_PORT/tcp"
		firewall-cmd --zone=public --permanent --remove-port="$SSH_PORT_OLD/tcp"
	fi
fi

