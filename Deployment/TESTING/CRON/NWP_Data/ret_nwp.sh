#!/bin/bash
#--------------------------------------------------------
# 				SMACK ENERGY FORECASTING 
#--------------------------------------------------------
#			-  Data Retrieval Script - NWP -
#--------------------------------------------------------
# Temporary Working Directory
TMP_DIR=$SMACK_DIR_TMP/nwp-load
# Check for Existence
if ! [ -e "$TMP_DIR" ]; then
	mkdir $TMP_DIR
fi 
# Move into Tmp Directory
cd $TMP_DIR
# Begin Downloading Files from NWP (for Recent Time)
#
# For all needed variables, download file for time
#	* make list of variables
#	* iterate through list
#	* use current time and known time stamp
#	* download and store into tmp directory
#
T=`date`
echo -e "\nret_nwp.sh - run @ $T\n" >> $CRON_PATH/log/nwp-load.log