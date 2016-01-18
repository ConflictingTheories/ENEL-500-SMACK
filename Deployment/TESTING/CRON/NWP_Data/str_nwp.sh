#!/bin/bash
#--------------------------------------------------------
# 				SMACK ENERGY FORECASTING 
#--------------------------------------------------------
#			-  Data Storage Script - NWP -
#--------------------------------------------------------
# Temporary Working Directory
TMP_DIR=$SMACK_DIR_TMP/nwp-load
# Check for Existence
if ![ -e $TMP_DIR ]; then
	mkdir $TMP_DIR
fi 
# Move into Tmp Directory
cd $TMP_DIR
# Begin Uploading Files from to Swift Storage (for recent time)
#
# For each file within the directory - upload to swift
#	* Check against files in directory
#	* Make sure proper time
#	* Upload to swift object storage
#
T = time
echo -e "\nstr_nwp.sh - run @ \$T\n" >> $CRON_PATH/log/nwp-load.log