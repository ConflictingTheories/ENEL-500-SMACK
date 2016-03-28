#!/bin/bash
#--------------------------------------------------------
#                               SMACK ENERGY FORECASTING
#--------------------------------------------------------
#                       -  Data Retrieval Script - NWP -
#--------------------------------------------------------

# Declare Environment Definitions
shopt -s expand_aliases
source /usr/local/smack/smack-env.sh
# Temporary Working Directory
declare TMP_DIR="\${SMACK_DIR_TMP}/nwp-load"
# Check for Existence
if ! [ -e "\${TMP_DIR}" ]; then
        mkdir "\${TMP_DIR}"
fi
# Move into Tmp Directory
cd "\${TMP_DIR}"

# REMOTE SERVER INFORMATION
# Server
declare nwp_srv="http://dd.weather.gc.ca/model_hrdps/west/grib2"
# Readout Times
declare curHr=\$(date -u +%H)
declare c1=06
declare c2=12
declare c3=18
# Determine Runtime
if [[ \${curHr} -lt c1 || \${curHr} == "00" ]]; then
        declare nwp_tz="00"
else
        if [[ \${curHr} -lt c2 ]]; then
                declare nwp_tz="06"
        else
                if [[ \${curHr} -lt c3 ]]; then
                        declare nwp_tz="12"
                else
                        declare nwp_tz="18"
                fi
        fi
fi

# Sections
declare -a nwp_sec=("000" "001" "002" "003" "004" "005" "006"
                "007" "008" "009" "010" "011" "012" "013"
                "014" "015" "016" "017" "018" "019" "020"
                "021" "022" "023" "024" "025" "026" "027"
                "028" "029" "030" "031" "032" "033" "034"
                "035" "036" "037" "038" "039" "040" "041"
                "042" "043" "044" "045" "046" "047" "048")
# File Prefix
declare nwp_pre="CMC_hrdps_west_"
# File Suffix
declare nwp_suf="-00.grib2"
# Date Stamp
declare nwp_ds="\$(date -d "yesterday" +%Y%m%d)"
# Wind Variables
declare -a nwp_var=("WIND_TGL_10_ps2.5km_" "WIND_TGL_40_ps2.5km_"
                "WIND_TGL_80_ps2.5km_" "WIND_TGL_120_ps2.5km_"
                "WDIR_TGL_10_ps2.5km_" "WDIR_TGL_40_ps2.5km_"
                "WDIR_TGL_80_ps2.5km_" "WDIR_TGL_120_ps2.5km_"
                "UGRD_TGL_10_ps2.5km_" "UGRD_TGL_40_ps2.5km_"
                "UGRD_TGL_80_ps2.5km_" "UGRD_TGL_120_ps2.5km_"
                "VGRD_TGL_10_ps2.5km_" "VGRD_TGL_40_ps2.5km_"
                "VGRD_TGL_80_ps2.5km_" "VGRD_TGL_120_ps2.5km_"
                "RH_TGL_2_ps2.5km_" "RH_TGL_40_ps2.5km_"
                "RH_TGL_120_ps2.5km_" "TMP_TGL_2_ps2.5km_"
                "TMP_TGL_40_ps2.5km_" "TMP_TGL_80_ps2.5km_"
                "TMP_TGL_120_ps2.5km_" "PRES_SFC_0_ps2.5km_"
                "TCDC_SFC_0_ps2.5km_" "DSWRF_NTAT_0_ps2.5km_"
                "DSWRF_SFC_0_ps2.5km_" "DEN_TGL_80_ps2.5km_")
# File Counter
declare -i fcnt=0
# Loop through all file and Retrieve
# Time Zones
#for a in \${nwp_tz[@]}; do
declare a=\$nwp_tz
        # sections
        for b in \${nwp_sec[@]}; do
                # variables
                for c in \${nwp_var[@]}; do
                        # Generate Proper File Name
                        declare filename="\${nwp_pre}\${c}\${nwp_ds}\${a}_P\${b}\${nwp_suf}"
                        # Generate Directory
                        declare directory="/\${a}/\${b}/"
                        # Generate Full HTTP Path
                        declare http_path="\${nwp_srv}\${directory}\${filename}"
                        # Delare File downloading
                        #echo -e "Downloading: \${http_path}\n"
                        curl -s -O "\${http_path}" > /dev/null
                        # Count # of Uploads
                        ((fcnt=\${fcnt}+1))
                done
        done
#done
# Log Run into History
T="\$(date)"
touch "\${CRON_PATH}/log/nwp-load.log"
echo -e "\nret_nwp.sh - run @ \${T}\n\tRetreived: \${fcnt} Files" >> "\$CRON_PATH/log/nwp-load.log"
smack-logout > /dev/null