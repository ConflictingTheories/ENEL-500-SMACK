#!/bin/bash
#--------------------------------------------------------
# 				SMACK ENERGY FORECASTING 
#--------------------------------------------------------
#			-  Data Retrieval Script - NWP -
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
declare -a nwp_tz=( "00" "06" "12" "18" )
# Sections
declare -a nwp_sec=("000" "001" "002" "003" "004" "005" "006" \\
					"007" "008" "009" "010" "011" "012" "013" \\
					"014" "015" "016" "017" "018" "019" "020" \\
					"021" "022" "023" "024" "025" "026" "027" \\
					"028" "029" "030" "031" "032" "033" "034" \\
					"035" "036" "037" "038" "039" "040" "041" \\
					"042" "043" "044" "045" "046" "047" "048")
# File Prefix
declare nwp_pre="CMC_hrdps_west_"
# File Suffix
declare nwp_suf="-00.grib2"
# Date Stamp
declare nwp_ds="\$(date +%Y%m%d)"
# Wind Variables
declare -a nwp_var=("WIND_ISBL_0050_ps2.5km_" "WIND_ISBL_0100_ps2.5km_" \\
					"WIND_ISBL_0150_ps2.5km_" "WIND_ISBL_0175_ps2.5km_" \\
					"WIND_ISBL_0200_ps2.5km_" "WIND_ISBL_0225_ps2.5km_" \\
					"WIND_ISBL_0250_ps2.5km_" "WIND_ISBL_0275_ps2.5km_" \\
					"WIND_ISBL_0300_ps2.5km_" "WIND_ISBL_0350_ps2.5km_" \\
					"WIND_ISBL_0400_ps2.5km_" "WIND_ISBL_0450_ps2.5km_" \\
					"WIND_ISBL_0500_ps2.5km_" "WIND_ISBL_0550_ps2.5km_" \\
					"WIND_ISBL_0600_ps2.5km_" "WIND_ISBL_0650_ps2.5km_" \\
					"WIND_ISBL_0700_ps2.5km_" "WIND_ISBL_0750_ps2.5km_" \\
					"WIND_ISBL_0800_ps2.5km_" "WIND_ISBL_0850_ps2.5km_" \\
					"WIND_ISBL_0875_ps2.5km_" "WIND_ISBL_0900_ps2.5km_" \\
					"WIND_ISBL_0925_ps2.5km_" "WIND_ISBL_0950_ps2.5km_" \\
					"WIND_ISBL_0970_ps2.5km_" "WIND_ISBL_0985_ps2.5km_" \\
					"WIND_ISBL_1000_ps2.5km_" "WIND_ISBL_1015_ps2.5km_" \\
					"WIND_TGL_10_ps2.5km_" "WIND_TGL_40_ps2.5km_" \\
					"WIND_TGL_80_ps2.5km_" "WIND_TGL_120_ps2.5km_")
# File Counter
declare -i fcnt=0
# Loop through all file and Retrieve
# Time Zones
for a in \${nwp_tz[@]}; do
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
			#echo -e "Downloading: ${http_path}\n"
			curl -s -O "\${http_path}" > /dev/null
			# Count # of Uploads
			((fcnt=\${fcnt}+1))
		done
	done
done
# Log Run into History
T="\$(date)"
touch "\${CRON_PATH}/log/nwp-load.log"
echo -e "\nret_nwp.sh - run @ \${T}\n\tRetreived: \${fcnt} Files" >> "\$CRON_PATH/log/nwp-load.log"
smack-logout > /dev/null