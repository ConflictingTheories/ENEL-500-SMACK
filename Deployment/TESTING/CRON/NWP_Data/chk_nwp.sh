#!/bin/bash
#--------------------------------------------------------
# 				SMACK ENERGY FORECASTING 
#--------------------------------------------------------
#			-  Data Checking Script - NWP -
#--------------------------------------------------------
# Temporary Working Directory
TMP_DIR=$SMACK_DIR_TMP/nwp-load
# Check for Existence
if ! [ -e "$TMP_DIR" ]; then
	mkdir $TMP_DIR
fi 
# Move into Tmp Directory
cd $TMP_DIR
# Begin Downloading Missed Files from NWP (For Recent Time)
#
# For all Variables that are missing download appropriate time
#	* Check against known variables
#	* Check off any missing
#	* Download missing variables
#
T=`date`
echo -e "\chk_nwp.sh - run @ $T\n" >> $CRON_PATH/log/nwp-load.log