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
#	swift://keys.smack/ -------------------------- (swift://clusters.smack/conf/master <---- master-ip)
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
#ssh-keygen -q -b 2048 -t rsa -N "" -f smack_ssh_rsa
#declare ssh_pvt_key="smack_ssh_rsa"
#declare ssh_pub_key="smack_ssh_rsa.pub"
#declare ssh_usr="smack"
function setAuth (){
cat << EOF > ~/tmp_rsa
-----BEGIN RSA PRIVATE KEY-----
MIIEowIBAAKCAQEAz2FnmAZWRNb8nO1c9skLCPMiuB7KhquwQdxYRR/tp1vHI8Go
/NUH82zdlIWMSIb+094n30UK2d79lIyNixCIBaymBcPpsNKHKTavSvM91MFD93/n
uoO6zZJ9ZtduGZyNCLxQwiZgHR9u+WxLaMDCNei3KzVQDpV6f2Bz9z08itGqUnoo
fYid4RqXFUa2i/jIU/G82lttnwsg29aXZetD8Xp0EVHFL5RNf8p7U8IlbXdfPFao
mqo6NX35XU5R9BtLoaxrBzJFFuuWfHg12HnmwHMvaadkkNS6I0hsO8x2GnJzPO9m
rXHNFDUBZ6vxQvjMgxNKzOrGnyBYvvMtBbRk0QIDAQABAoIBAHta3isgwdoK45JY
4q5tIeI99c39isyWfa5/agYcGtotDoRnYqSZ9zPF8vuwgKR3oEbYY3E8eVrleIMP
I/ava6msa8kMIwqp//n07Eox6/qMx2gGLgnU5532YB93T6duZrnmgkcqWouYMgOt
diGmXx+AAMxz1t4F7iqsbe6H/2Y2hJZQkr7LvnowTRZHzSdW/PlhnvjHB4ukHHhm
Mp0lMZflt5vbiYvxC5nhTRo1omy7H/33WyKIgDFwmiftzNClujHzFLb8o4b9pd5z
d2QwUUSTEPqMGOuQpiivrBeaSj92Ssrk2mOqfl7D93cpcpPDPcMtnYhFIXOVyzwT
piw1uRECgYEA8p4Jfiq4hDBCqUGM70AhVkQ0ldJdGXbp3sMOX9cHax7R/Ftdx8XR
UB6qmOVAyxwBbu3psa9gW0TrJGgYob+UBU1byzndVPWg3uMrRXnGgtETMLlVlZp4
QoVI2MSzqqEP0EEn7gcVMXaV+MnpGSxTJSMUn3OxuIAalBnvyxVGvGUCgYEA2tHL
GuzAoiO/Qv1+CTU8tnDcQgMj9j6oJ/NLIR+HWK5cRI6QP4hi2IhbMouXk+vVU1//
HkTiUXRyNbf1vaoel34a9GJXKSxSvjEAdgrylM6fkpX9+mKljzQZvzFdxnO6Q7p8
dihV/PZzSiJPLo3nhFtvUinPxNKU2bFLUMLLkf0CgYEAvsZQNppHHwKH2GmH9bVa
wWe+ZbTVqilcOuLsEaaW2b+RZLs/YdAGB9clVDaonU13Pw/q++IohXwK3kTQYZew
P/8VWBc3GBBRIBJHO0lHNCRMz7pcNtgRClWd832wvVIKijpBuKRvIMbbpJa4KSg2
dPRByiQCMk7hF2XRrcIcLhUCgYADBmdyZdd75lacjHiTlALU2taQqw5yNweIFdry
CEeMuExaPkZMOoxzRd9M4ZUk3FvEnU0flAA09BEoIPTqvFFT8tBYlItz7ELwkijZ
eOlFmV2nXx91uKtlQWkhtYMAXVUz3n4d/AzERHvviG3jzN5ofAMb9awDoo2gPM03
vpml2QKBgEsc+hhr4ILMKyhjqWBXatABLUtUDGtTAV2kEaHJPGBCo9d/CO3jD1ku
XNy+CiwKNAlzgyuQ4ELGIF9SNMHILlGYSKjgjbGZJ52RaX3NSdCS1pqvG+L/hzWN
Ne0WN988TLlY7eZAUEmK7yjZBY2Y/GKYqKFANg1ZTIuo4ksUAfb1
-----END RSA PRIVATE KEY-----

EOF
}
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