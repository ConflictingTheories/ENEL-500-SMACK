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

# Perhaps Generate Scripts for the Cluster Nodes
#	-- Master Script
#	-- Slave Script
#

# Perhaps Setup a Key Storage Container on Swift for Cluster Deployment
#	* Only Clusters - No need otherwise
#
# ----SWIFT-----
# Make Container for key Storage
#	swift://keys.smack/
#
# Generate Cluster ID # - Unique Prefix
#	- CLUSTER_ID (RANDOMLY GENERATED)
#
#	Store Details into Container/Prefix/
#		- MASTER_IP
#		- SLAVE_IPS
#		- FLOATING_IP
#		- Public/Private Keys
#		- Generated Scripts
#	
#	Examples:
#
#		swift://keys.smack/<random_id>/master_ip
#		swift://keys.smack/<random_id>/slave1_ip
#		swift://keys.smack/<random_id>/slave2_ip
#		swift://keys.smack/<random_id>/floating_ip
#		swift://keys.smack/<random_id>/private_key
#		swift://keys.smack/<random_id>/public_key
#		swift://keys.smack/<random_id>/scripts/core-site.xml
#

# SSH Authentication
ssh-keygen -q -b 2048 -t rsa -N "" -f smack_ssh_rsa
declare ssh_pvt_key="smack_ssh_rsa"
declare ssh_pub_key="smack_ssh_rsa.pub"
declare ssh_usr="smack"

# Function Used to add Slave Log to $SPARK_HOME/conf/slaves
function addSlave (master_ip, slave_ip) {
	ssh -i ${ssh_pvt_key} ${ssh_usr}@${master_ip} "echo ${slave_ip} >> $SPARK_HOME/conf/slaves"
	echo -e "\nAdded Slave: ${slave_ip} to Master Slave List.\n"
}

# Function Designed to Launch A Spark Cluster using Deployment Scripts
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