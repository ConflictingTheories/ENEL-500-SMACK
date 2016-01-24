#!/bin/bash
#--------------------------------------------------------
# 				SMACK ENERGY FORECASTING 
#--------------------------------------------------------
#			-  Data Clearing Script - NWP -
#--------------------------------------------------------
# Temporary Working Directory
TMP_DIR=$SMACK_DIR_TMP/nwp-load
# Check for Existence
if ! [ -e "$TMP_DIR" ]; then
	mkdir $TMP_DIR
fi 
# Move into Tmp Directory
cd $TMP_DIR
# Clear Tmp Directory (for recent time files)
#	* Check against time
#	* Remove all Grib2 Files
#
rm -rf *.grib2
T=`date`
echo -e "\nclr_nwp.sh - run @ $T\n" >> $CRON_PATH/log/nwp-load.log