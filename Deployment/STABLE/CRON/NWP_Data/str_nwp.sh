#!/bin/bash
#--------------------------------------------------------
# 				SMACK ENERGY FORECASTING 
#--------------------------------------------------------
#			-  Data Storage Script - NWP -
#--------------------------------------------------------
# Declare Environment Definitions
shopt -s expand_aliases
source /usr/local/smack/smack-env.sh
# Temporary Working Directory
TMP_DIR="\${SMACK_DIR_TMP}/nwp-load"
# Check for Existence
if ! [ -e "\${TMP_DIR}" ]; then
	mkdir "\${TMP_DIR}"
fi 
# Move into Tmp Directory
cd "\${TMP_DIR}"
# VARIABLE DECLARATIONS
# Date Stamp
declare nwp_ds="\$(date +%Y%m%d)"
# Container
declare nwp_con="nwp"
# Pseudo-container
declare nwp_pse="grib2"
# Create Container if Non-existent
if ! [ "\$(smack-lsdb -l 2> /dev/null | grep \${nwp_con})" == "\${nwp_con}" ]; then
	smack-mkdb -c "\${nwp_con}" > /dev/null
fi
# Gather Current List of Objects
declare -i fcnt=0
# Loop through each file and Upload:
for filename in *\${nwp_ds}*.grib2; do
	smack-upload -c "\${nwp_con}" -o "\${nwp_pse}/\${filename}" -f "\${filename}" > /dev/null
	# Count # of Uploads
	((fcnt=\${fcnt}+1))
done
# Log Recording
T="\$(date)"
echo -e "\nstr_nwp.sh - run @ \${T}\n\tStored: \${fcnt} Files\n" >> "\${CRON_PATH}/log/nwp-load.log"
smack-logout > /dev/null