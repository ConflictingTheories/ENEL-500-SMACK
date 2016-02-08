#!/bin/bash
#
#	Testing Script for Launching SparkClusters Using predefined deployment
#	scripts for the master and slave nodes
#	
#	This may require some networking to get it to work right.***
#
#	Also, this requires logging in via smack-login
#

# Declare Root Directory
declare smack_dir=$(env SMACK_DIR)
# Master Deployment Script
declare master_script=$smack_dir/init/spark/master.sh
# Slave Deployment Script
declare slave_script=$smack_dir/init/spark/slave.sh

# Function Designed to Launch A SPark Cluster using Deployment Scripts
function sparkCluster (n, name_pre) {
	local N=$(expr $n-1)
	# Check for Errors
	if [[ $N -lt 0 ]]; then
		echo -e "\nError: There must be at least one node.\n"
		exit -1
	fi
	# Generate Master Node
	smack-mknode -x "${master_script}" -n "${name_pre}-mstr" -d 1> /dev/null
	echo -e "\nLaunching Master: -----\n"
	# Generate Workers
	while [[ $N -gt 0 ]]; do
		smack-mknode -x "${slave_script}" -n "${name_pre}-wrk-$N" -d 1> /dev/null
		N=$(expr $N-1)
		echo -e "\n\tLaunching Worker: --- ${N} to go\n"
	done
	echo -e "\nAll Finished - Cluster Should be Launched and Initializing."
}

# Usage:
# 
#		sparkCluster(2, "smack_test")
#