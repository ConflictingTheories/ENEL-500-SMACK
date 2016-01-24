#!/bin/bash
#--------------------------------------------------------
# 				SMACK ENERGY FORECASTING 
#--------------------------------------------------------
#			-  Data Storage Script - NWP -
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
# VARIABLE DECLARATIONS
# Date Stamp
declare -r nwp_ds="\$(date +%Y%m%d)"
# Container
declare -r nwp_con="nwp"
# Pseudo-container
declare -r nwp_pse="grib2"
# Create Container if Non-existent
if [ -z "\$(smack-lsdb | grep \${nwp_con})" ]; then
	smack-mkdb -c "\${nwp_con}" > /dev/null
fi
declare -i fcnt=0
# Loop through each file and Upload:
for filename in *\${nwp_ds}*.grib2; do
	smack-put "\${STORAGE_URL}/\${nwp_con}/\${nwp_pse}/\${filename}"
	# Count # of Uploads
	((fcnt=\${fcnt}+1))
done
# Log Recording
declare T="\$(date)"
echo -e "\nstr_nwp.sh - run @ \${T}\n\tStored: \${fcnt} Files\n" >> "\${CRON_PATH}/log/nwp-load.log"
