#!/bin/bash
#--------------------------------------------------------
#                               SMACK ENERGY FORECASTING
#--------------------------------------------------------
#                       -  Data Storage Script - NWP -
#--------------------------------------------------------
# Declare Environment Definitions
shopt -s expand_aliases
source /usr/local/smack/smack-env.sh
# Temporary Working Directory
TMP_DIR="${SMACK_DIR_TMP}/nwp-load"
# Check for Existence
if ! [ -e "${TMP_DIR}" ]; then
        mkdir "${TMP_DIR}"
fi
# Move into Tmp Directory
cd "${TMP_DIR}"
# VARIABLE DECLARATIONS
# Date Stamp
declare -x nwp_ds="$(date -u +%Y%m%d)"
# Container
declare -x nwp_con="nwptxt"
declare -x grb_con="nwpgrb"
# Create Container if Non-existent
if ! [[ "$(smack-lsdb -l 2> /dev/null | grep ${nwp_con})" == "${nwp_con}" ]]; then
        smack-mkdb -c "${nwp_con}" > /dev/null
fi
# Gather Current List of Objects
#declare -i fcnt=0
# Loop through each file and Upload:
declare dir="/usr/local/smack/tmp/nwp-load/"
declare ext=".grib2"
declare files="${dir}*${ext}"
echo "Found: ${#files}"
for filename in ${files}; do
        declare out=$(echo $filename | sed 's/CMC_hrdps_west_//g' | sed s:${dir}::g | sed s:${ext}::g | sed s:-00::g | sed s:_P0::g)
        declare portion=$(echo $out | sed -r 's:_ps2.5km_[0-9]+::g')
        declare datestamp=$(echo $out | sed s:${portion}::g | sed s:_ps2.5km_::g )
        declare save="${datestamp:0:4}/${datestamp:4:2}/${datestamp:6:2}/${datestamp:8:2}/${datestamp:10:2}/${portion}"
        #echo $save
        # upload txt data and upload too
        smack-upload -c "${grb_con}" -o "${save}" -f "${filename}" -H "X-Delete-At: $(expr $(date +%s) + 62208000)" 2> /dev/null
        wgrib2 -text "${portion}.txt" -g2clib 0 ${filename} > /dev/null
        smack-upload -c "${nwp_con}" -f "${portion}.txt" -o "${save}" -H "X-Delete-At: $(expr $(date +%s) + 62208000)" >> /dev/null
        rm -rf ${portion}.txt
done
# Log Recording
T="$(date -u)"
echo -e "\nstr_nwp.sh - run @ ${T}\n\tStored: ${#list[@]} Files\n" >> "${CRON_PATH}/log/nwp-load.log"
smack-logout > /dev/null
