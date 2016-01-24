#!/bin/bash
#--------------------------------------------------------
# 				SMACK ENERGY FORECASTING 
#--------------------------------------------------------
#			-  Data Clearing Script - NWP -
#--------------------------------------------------------
# Declare Environment Definitions
source /usr/local/smack/smack-env.sh
# Temporary Working Directory
declare -r TMP_DIR="\${SMACK_DIR_TMP}/nwp-load"
# Check for Existence
if ! [ -e "\${TMP_DIR}" ]; then
	mkdir "\${TMP_DIR}"
fi 
# Move into Tmp Directory
cd "\${TMP_DIR}"
# Date Stamp
declare -r nwp_ds="\$(date +%Y%m%d)"
# Remove all Today's Files
declare -a files="\$(ls *\${nwp_ds}*.grib2 2> /dev/null)"
declare -i fcnt="\${\#files[\@]}";\(\(fcnt=\${fcnt}-1\)\)
rm -f "*\${nwp_ds}*.grib2"
# Logging
T=`date`
echo -e "\nclr_nwp.sh - run @ \${T}\n\tRemoved: \${fcnt} Files\n" >> $CRON_PATH/log/nwp-load.log