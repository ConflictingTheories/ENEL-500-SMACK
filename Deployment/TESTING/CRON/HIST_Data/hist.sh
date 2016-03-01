#!/bin/bash
#
# SMACK Energy Forecasting
#
#	Historical Wind Power Data Fetcher
#	and Uploader
# Cron Directory
export CRON_DIR=/usr/local/smack/cron
# Authenticate
shopt -s expand_aliases
source /usr/local/smack/smack-env.sh
# Remove Old Data
rm -f historical.json
# Fetch Historical Data from Web
/usr/local/bin/python3.5 $CRON_DIR/bin/get_hist.py
# Date Stamp
declare dty="$(date -u +%Y)"
declare dtm="$(date -u +%m)"
declare dtd="$(date -u +%d)"
declare dtt="$(date -u +%H%M)"
# Object Name
declare objn="${dty}/${dtm}/${dtd}/${dtt}"
# Upload File to Swift
if [[ -e "historical.json" ]]; then
	smack-upload -c hist -f historical.json -o ${objn}
	echo -e "Upload: \t$(date -u)" >> $CRON_DIR/log/hist.log
	echo -e "\t\tSuccess - Uploaded Data to Swift" >> $CRON_DIR/log/hist.log
else
	echo -e "Upload: \t$(date -u)" >> $CRON_DIR/log/hist.log
	echo -e "\t\tError - No Data to Upload" >> $CRON_DIR/log/hist.log
fi