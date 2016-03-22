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
declare -x nwp_ds="\$(date -u +%Y%m%d)"
# Container
declare -x nwp_con="nwptxt"
declare -x grb_con="nwpgrb"
# Create Container if Non-existent
if ! [[ "\$(smack-lsdb -l 2> /dev/null | grep \${nwp_con})" == "\${nwp_con}" ]]; then
        smack-mkdb -c "\${nwp_con}" > /dev/null
fi
# Gather Current List of Objects
#declare -i fcnt=0
# Loop through each file and Upload:
declare -a list=(*.grib2);
echo "Found: \${#list[@]}"
for filename in \${list[@]}; do
        smack-upload -c "\${grb_con}" -o "\${filename}" -f "\${filename}"  -H "X-Delete-At: $(expr $(date +%s) + 62208000)" > /dev/null
        # upload txt data and upload too
        wgrib2 -text \${filename}.txt -g2clib 0 \${filename} > /dev/null
        smack-upload -c \${nwp_con} -o "$(date -u +%Y)/$(date -u +%m)/$(date -u +%d)/$(echo ${filename} | sed 's/.grib2//').txt" -H "X-Delete-At: $(expr $(date +%s) + 6$
        rm -rf \${filename}.txt
done
# Log Recording
T="\$(date -u)"
echo -e "\nstr_nwp.sh - run @ \${T}\n\tStored: \${#list[@]} Files\n" >> "\${CRON_PATH}/log/nwp-load.log"
smack-logout > /dev/null
