#!/bin/bash

# 1. Setup no password ssh access from cluster nodes
# 2. Setup nodes in some sanity format of something like cluster0, cluster1, ... , cluster(N-1), clusterN
# 3. Verify target folder for share over sshfs and ensure correct permissions
# 4. When script ran will look for cmd.hostname files file format looks something like:
#_cmdArray=( " \
#--rtsppath rtsp://user:pass@ip:554/path --imagepath ;  \
#--rtsppath rtsp://user:pass@ip:554/path --imagepath   \
#")



#################################
# Define a couple of varaiable
#################################
_ver="20220323.6"
_sshfsMountPoint="localMountPoint"
_sshfsServer="user@host:dir"
_hostName=$(hostname)

echo "Attempting to run rtsp-cluster.sh with of version: ${_ver}."

# Test for sshfs mount point
if [ -d ${_sshfsMountPoint} ]; then
	echo "Looks like local mount point exists."
else
	echo "Attemptinng to create local mount point."
	if !( mkdir -p "${_sshfsMountPoint}" ); then
		echo "Failed to make local mount point!"
		exit 1
	else
		echo "Local mount point created."
	fi
fi
if !( sshfs ${_sshfsServer} ${_sshfsMountPoint} ); then
	echo "Failed to sshfs mount from !"
	exit 1
else
	echo "Appears we have sshfs mapped ${_sshfsServer} to ${_sshfsMountPoint}!"
	echo "Looking for cmd.${_hostName} directives ...."
	if [ -f "${_sshfsMountPoint}/cmd.${_hostName}" ]; then
		. "${_sshfsMountPoint}/cmd.${_hostName}"
		IFS=';'
		for cmdstr in ${_cmdArray[@]}; do
			cmdstr="${_sshfsMountPoint}/rtsp-to-jpegs.sh $cmdstr ${_sshfsMountPoint}"
			echo "Attempting to run the command: $cmdstr ..."
			eval $cmdstr&
		done
		IFS=' '
	else
		echo "Failed to find ${_sshfsMountPoint}/cmd.${_hostName} file!"
	fi
fi


