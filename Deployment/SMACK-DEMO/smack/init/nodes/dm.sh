#!/bin/bash
##############################################################################
##																		  	##
##						SMACK ENERGY FORECASTING						  	##
##								2015-2016									##
##--------------------------------------------------------------------------##
##																		  	##
##	 ___  __  __    __    ___  _  _    ____  _  _  ____  ____   ___  _  __ 	##
##	/ __)(  \/  )  /__\  / __)( )/ )  ( ___)( \( )( ___)(  _ \ / __)( \/ )	##
##	\__ \ )    (  /(__)\( (__  )  (    )__)  )  (  )__)  )   /( (_-. \  /	##
##	(___/(_/\/\_)(__)(__)\___)(_)\_)  (____)(_)\_)(____)(_)\_) \___/ (__)	##
##	 ____  _____  ____  ____  ___    __    ___  ____  ____  _  _  ____ 		##
##	( ___)(  _  )(  _ \( ___)/ __)  /__\  / __)(_  _)(_  _)( \( )/ __)		##
##	 )__)  )(_)(  )   / )__)( (__  /(__)\ \__ \  )(   _)(_  )  (( (_-.		##
##	(__)  (_____)(_)\_)(____)\___)(__)(__)(___/ (__) (____)(_)\_)\___/		##
##																			##
##																			##
##############################################################################
##																			##
##				--	API Node Deployment Script Skeleton  --					##
##																			##
##############################################################################
##																			##
## 		 NOTE: THIS SCRIPT REQUIRES THE USE OF A COMPILER PRIOR TO USE 		##
##																			##
##############################################################################
#!/bin/bash
#--------------------------------------------------------
# 				SMACK ENERGY FORECASTING 
#--------------------------------------------------------
#		- Development Host Init Script for Nodes -
#--------------------------------------------------------
#	Draft Cloud-Init Script for Setting up a Development
#   Host. This is the host that will be used to interact 
#	with the development and handle the deployment of 
#	node clusters via CLI.
#
#	Think of this computer as the point of interaction 
#	for development - not production
#
#
# ********************************************************
# 	As of January 17, 2016: This file will be updated from
# 	a different approach - individual files and addendums
# 	will be conducted via an incremental process and a
# 	stable vs. testing will be done. This file will serve
# 	as the stable version.
#
#	* THIS IS A TESTING VERSION - SOME THINGS MAY NOT
#	WORK QUITE AS INTENDED. IF YOU WANT STABILITY, PLEASE
#	LOOK AT THE STABLE VERSION. THIS VERSION WILL BE THE
#	MOST RECENT STABLE VERSION PLUS ANY CHANGES THAT ARE
#	CURRENTLY IN THE PROCESS OF BEING DONE.
#
#
# ------------------------------------------------------
# ------------------------------------------------------
# TESTING RELEASE NOTES (As of January 23, 2016):
#	
#--------------------------------------------------------
#
#	This Node Has the Most Up-to-date Pakages in all areas
#
#		CRON Schedule - NWP DATA LOADING 		[x]
#		SWIFT Utilities for CLI and CRON 		[x]
#		Guide and now MANUAL Utilties for
#		the clusters  							[x]
#
#		NEW Environment Script for Continuity	[x]
#
#		Authentication Token Access for Daemons	[x]
#
# SMACK ENERGY FORECASTING - ENVIRONMENT VARIABLES
#-------------------------------------------------
# OPENSTACK ENVIRONMENT
# URLs for API Access (may need to change)
export KEYSTONE_URL="https://keystone-yyc.cloud.cybera.ca:5000/v2.0"
export NOVA_URL="https://nova-yyc.cloud.cybera.ca:8774/v2/2b86ecd5b18f4fafb1d55adb79072def"
export CINDER_URL="https://cinder-yyc.cloud.cybera.ca:8776/v1/2b86ecd5b18f4fafb1d55adb79072def"
export CINDER2_URL="https://cinder-yyc.cloud.cybera.ca:8776/v2/2b86ecd5b18f4fafb1d55adb79072def"
export GLANCE_URL="http://glance-yyc.cloud.cybera.ca:9292"
export EC2_URL="https://nova-yyc.cloud.cybera.ca:8773/services/Cloud"
export SWIFT_URL="https://swift-yyc.cloud.cybera.ca:8080/v1/AUTH_2b86ecd5b18f4fafb1d55adb79072def"
# SERVICE AUTHENTICATION CREDENTIALS
# Cron Authentication Using Token and URL with curl requests
export OS_PROJECT_NAME="SMACK"
export OS_ZONE="Nova"
export OS_REGION="Calgary"
export STORAGE_ACCT="AUTH_4b6be558d44e4dba8fb6e4aa49934c0b"
export STORAGE_TOKEN="7eefd48208754002a2e03bf0de11c3e4"
export STORAGE_URL="https://swift-yyc.cloud.cybera.ca:8080/v1/AUTH_4b6be558d44e4dba8fb6e4aa49934c0b"
# SMACK ENVIRONMENT
export SMACK_DIR=/usr/local/smack
export SMACK_DIR_BIN=/usr/local/smack/bin
export SMACK_DIR_LOG=/usr/local/smack/log
export SMACK_DIR_SKEL=/usr/local/smack/skel
export SMACK_DIR_TMP=/usr/local/smack/tmp
export SMACK_LOAD=/usr/local/smack/log/smack_loaded
export SMACK_INSTALL_LOG=/usr/local/smack/log/install_log
# CRON JOB ROOT
export CRON_PATH=/usr/local/smack/cron
# SHINY SERVER ROOT
export SHINY_SRV=/srv/shiny-server
# API SERVER ROOT
export API_SRV=/srv/api-server
# EXECUTABLE PATH
export PATH="${PATH}:${SMACK_DIR_BIN}"
export PATH="${PATH}:/usr/local/bin"
# Log Reporting
echo -e "\n### INSTALL BEGINNING ###" >> $SMACK_INSTALL_LOG
echo -e "\n### DECLARATIONS: COMPLETE" >> $SMACK_INSTALL_LOG
# GENERATE DIRECTORY STORAGE
#-----------------------------------
mkdir ${SMACK_DIR}
mkdir ${SMACK_DIR_BIN}
mkdir ${SMACK_DIR_LOG}
mkdir ${SMACK_DIR_SKEL}
mkdir ${SMACK_DIR_TMP}
mkdir ${CRON_PATH}
mkdir ${CRON_PATH}/bin
mkdir ${CRON_PATH}/log
mkdir ${SHINY_SRV}
mkdir ${API_SRV}
# Log Reporting
echo -e "\nDIRECTORIES: COMPLETE" >> $SMACK_INSTALL_LOG
# UPDATE PACKAGES AND TOOLCHAIN
#-----------------------------------
#yum -y update
yum -y install gcc-c++ wget curl curl-devel figlet python
yum -y install make binutils git nmap man maven libffi-devel
yum -y install nano python-devel python-pip links nodejs npm at
yum -y groupinstall "Development Tools"
yum -y install zlib-devel bzip2-devel openssl-devel libxml2-devel
yum -y install ncurses-devel sqlite-devel readline-devel zlibrary-devel
yum -y install tk-devel gdbm-devel db4-devel libpcap-devel xz-devel
# Log Reporting
echo -e "\nTOOLCHAIN: COMPLETE" >> $SMACK_INSTALL_LOG
# ENSURE ONLY RUNS ONCE
#-----------------------------------
if ! [ -e $SMACK_LOAD ]; then
# INSTALL PYTHON 2.7 (python2.7)
#-----------------------------------
mkdir /tmp/python27
cd /tmp/python27
wget "https://python.org/ftp/python/2.7.8/Python-2.7.8.tgz"
tar -xzvf Python-2.7.8.tgz
cd Python-2.7.8
./configure --prefix=/usr/local --enable-unicode=ucs4 --enable-shared LDFLAGS="-Wl,-rpath /usr/local/lib"
make && make altinstall
# clean up directories
cd /
rm -rf /tmp/python27
# Log Reporting
echo -e "\nPYTHON 2.7: COMPLETE" >> $SMACK_INSTALL_LOG
# INSTALL PYTHON 3.5 (python3.5)
#-----------------------------------
mkdir /tmp/python3
cd /tmp/python3
wget "https://www.python.org/ftp/python/3.5.0/Python-3.5.0.tgz"
tar -xzvf Python-3.5.0.tgz
cd Python-3.5.0
./configure --prefix=/usr/local --enable-shared LDFLAGS="-Wl,-rpath /usr/local/lib"
make && make altinstall
# clean up directories
cd /
rm -rf /tmp/python3
# Log Reporting
echo -e "\nPYTHON 3.5: COMPLETE" >> $SMACK_INSTALL_LOG
# INSTALL PIP FOR PYTHON 2.7 + 3.5 (pip2.7/pip3.5)
#---------------------------------------
mkdir /tmp/pipinstall
cd /tmp/pipinstall
wget "https://bitbucket.org/pypa/setuptools/raw/bootstrap/ez_setup.py"
# install easytools
/usr/local/bin/python2.7 ez_setup.py
/usr/local/bin/python3.5 ez_setup.py
# install pip
/usr/local/bin/easy_install-2.7 pip
/usr/local/bin/easy_install-3.3 pip
# clean up directories
cd /
rm -rf /tmp/pipinstall
# Log Reporting
echo -e "\nPIP 2.7/3.5: COMPLETE" >> $SMACK_INSTALL_LOG
# INSTALL OPENSTACK CLIENT SOFTWARE
#-----------------------------------
/usr/local/bin/pip2.7 install requests['security']
/usr/local/bin/pip2.7 install python-openstackclient
/usr/local/bin/pip2.7 install python-swiftclient
/usr/local/bin/pip2.7 install --upgrade setuptools
/usr/local/bin/pip2.7 install numpy
/usr/local/bin/pip2.7 install scipy
# OPENSTACK TOOLS FOR PYTHON 3.5
#-------------------------------------
/usr/local/bin/pip3.5 install requests['security']
/usr/local/bin/pip3.5 install python-openstackclient
/usr/local/bin/pip3.5 install python-swiftclient
/usr/local/bin/pip3.5 install --upgrade setuptools
/usr/local/bin/pip3.5 install scipy
/usr/local/bin/pip3.5 install numpy
# Log Reporting
echo -e "\nOPENSTACK CLIENTS: COMPLETE" >> $SMACK_INSTALL_LOG
# INSTALL JAVA RUNTIME VERSION (7/8)
#------------------------------------
# JRE 7
mkdir /tmp/java7
cd /tmp/java7
wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/7u79-b15/jdk-7u79-linux-x64.rpm"
# RPM method?
rpm -ivh jdk-7u79-linux-x64.rpm
# Add version 1.7 to list
alternatives --install /usr/bin/java java /usr/java/jdk1.7.0_79/bin/java 2
alternatives --install /usr/bin/javac javac /usr/java/jdk1.7.0_79/bin/javac 2
# Set Version to 1.7
alternatives --set java /usr/java/jdk1.7.0_79/bin/java
alternatives --set javac /usr/java/jdk1.7.0_79/bin/javac
# set Variables
JAVA_HOME=/usr/java/jdk1.7.0_79
JRE_HOME=$JAVA_HOME/jre
# cleanup
cd /
rm -rf /tmp/java7
# JRE 8
mkdir /tmp/java8
cd /tmp/java8
wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u40-b25/jdk-8u40-linux-x64.rpm"
# RPM Method?
rpm -ivh jdk-8u40-linux-x64.rpm
# Add version 1.8 to list
alternatives --install /usr/bin/java java /usr/java/jdk1.8.0_40/bin/java 2
alternatives --install /usr/bin/javac javac /usr/java/jdk1.8.0_40/bin/javac 2
# Set Version to 1.8
alternatives --set java /usr/java/jdk1.8.0_40/bin/java
alternatives --set javac /usr/java/jdk1.8.0_40/bin/javac
# set Variables
JAVA_HOME=/usr/java/jdk1.8.0_40
JRE_HOME=$JAVA_HOME/jre
# cleanup
cd /
rm -rf /tmp/java8
# Log Reporting
echo -e "\nJDK/JRE 7+8: COMPLETE" >> $SMACK_INSTALL_LOG
# INSTALL RELATED CRON JOBS
#-----------------------------------
# NWP CRON JOB
cat <<EOF > $SMACK_DIR/cron/nwp-load.cron
# Retrieve NWP Data (Every 6 Hours)
5 */6 * * * /usr/local/smack/cron/bin/ret_nwp.sh
# Check NWP Data (Every 6 Hours)
25 */6 * * * /usr/local/smack/cron/bin/chk_nwp.sh
# Store NWP Data (Every 6 Hours)
45 */6 * * * /usr/local/smack/cron/bin/str_nwp.sh
# Clear NWP Data (Daily)
0 0 * * * /usr/local/smack/cron/bin/clr_nwp.sh
# Get Historical AESO data (min-min)
* * * * * /usr/local/smack/cron/bin/hist.sh
EOF
cat <<EOF > $CRON_PATH/bin/get_hist.py
#!/usr/local/bin/python3.5
#---------------------------------------------------------------#
#                                                               #
#       SMACK Parser - AESO Historical Data Scraper             #
#                                                               #
#---------------------------------------------------------------#
#       Scrapes data from the Web Servlet page                  #
#       provided by AESO and then logs the information          #
#       in JSON format into a local file (historical.json)      #
#                                                               #
#       This file will storage the most recent data (min basis) #
#       and this file will be uploaded via another process      #
#                                                               #
#---------------------------------------------------------------#

# Import Necessary Libraries
import json
import urllib.request
from html.parser import HTMLParser

# Table to Parse from Webpage
Table_Title = "WIND"
#       WIND
#       HYDRO
#       COAL
#       BIOMASS AND OTHER
# ------NO GAS-----------

# Generate Parser for Data Scraping
class HistScraper(HTMLParser):
        # Header Flag - for WIND
        tf_th = False
        # Necessary Evil
        tf_tr = False
        # Real Flag for Header (P as in Post)
        tf_thp = False
        # Title Group in HTML
        tf_titgrp = False
        # Individual Titles
        tf_title = False
        # Hack
        tf_wd = False
        # Data Flag
        tf_drdy = False
        tf_data = ""
        # Title Counter
        col_cnt = 0
        # Title List
        col_tit = []
        # Data counter for Table Data
        td_cnt = 0
        # Well Counter
        w_cnt = 0
        # Temp Hist Row
        hist = []
        # Well List
        well = []
        # Necessary
        tf_w = False
        
        # When it finds a tag <example> calls functio
        def handle_starttag(self, tag, attrs):
        # TH - WIND
                if ((tag == "th")):
                        self.tf_th = True
                # For Data Header Title
                if ((tag == "tr") and self.tf_thp and not self.tf_titgrp):
                        self.tf_titgrp = True
                # Also For Data Header Titles
                if (self.tf_titgrp and (tag == "font")):
                        self.tf_title = True
                if (self.tf_drdy and tag == "td"):
                        self.tf_data = True

        # When it finds an endtag </example> calls function
        def handle_endtag(self, tag):
                # For Ending TH - WIND
                if (tag == "th"):
                        self.tf_th = False
                # Setting flag to alert section
                if (self.tf_wd):
                        self.tf_thp = True
                # If Ending Title Headers
                if (self.tf_titgrp and (tag == "tr")):
                        self.tf_titgrp = False
                        self.tf_drdy = True
                # If Ending Individual Titles - in Header
                if (self.tf_thp and (tag == "font")):
                        self.tf_title = False
                if (self.tf_data and (tag == "td")):
                        self.tf_data = False
                # Finished
                if (self.tf_drdy and (tag == "table")):
                        self.tf_th = False
                        self.tf_thp = False
                        self.tf_drdy = False
                        self.tf_titgrp = False
                        self.tf_wd = False
                        self.tf_tr = False
                        self.tf_title = False
                        self.td_cnt = 0
                        self.w_cnt = 0
                        self.col_cnt = 0
                        self.hist = []
                        self.tf_w = True

        # When it finds data between start and end tags it calls function
        def handle_data(self, data):
                # If WIND section found begin scraping
                if (self.tf_th and (data == Table_Title) and not self.tf_thp):
                        self.tf_wd = True
                # If Header is done, and individual Title
                if (self.tf_wd and self.tf_titgrp and self.tf_title):
                        self.col_tit.append(data)
                        self.col_cnt = self.col_cnt + 1
                # if data add to list
                if (self.tf_wd and self.tf_data):
                        self.hist.append(data)
                        self.td_cnt = self.td_cnt + 1
                        if (self.td_cnt == len(self.col_tit)):
                                well_d = {}
                                n = 0
                                for i in self.col_tit:
                                        well_d[i] = self.hist[n]
                                        n = n + 1
                                self.well.append(well_d)
                                self.w_cnt = self.w_cnt + 1
                                self.td_cnt = 0
                                self.hist = []

# Generate Scraper
scraper = HistScraper()
# New File
newData = open("historical.json", "w")
# Retrieve Data
htmlfile = urllib.request.urlopen("http://ets.aeso.ca/ets_web/ip/Market/Reports/CSDReportServlet").read()
# Parse and Extract Data
scraper.feed(str(htmlfile))
# Dump to File in JSON
json.dump(scraper.well, newData)
EOF

cat <<EOF > /$CRON_PATH/bin/hist.sh
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
EOF
# Generate Related Cron Files
cat <<EOF > $CRON_PATH/bin/ret_nwp.sh
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
EOF
# Generate Related Cron Files
cat <<EOF > $CRON_PATH/bin/chk_nwp.sh
#!/bin/bash
#--------------------------------------------------------
# 				SMACK ENERGY FORECASTING 
#--------------------------------------------------------
#			-  Data Checking Script - NWP -
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
# Begin Downloading Missed Files from NWP (For Recent Time)
#
# For all Variables that are missing download appropriate time
#	* Check against known variables
#	* Check off any missing
#	* Download missing variables
#
#
#       ** NOT IMPLEMENTED YET
#
T="\$(date)"
echo -e "\chk_nwp.sh - run @ \${T}\n" >> "\${CRON_PATH}/log/nwp-load.log"
smack-logout > /dev/null
EOF
# Generate Related Cron Files
cat <<EOF > $CRON_PATH/bin/str_nwp.sh
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
EOF
# Generate Related Cron Files
cat <<EOF > $CRON_PATH/bin/clr_nwp.sh
#!/bin/bash
#--------------------------------------------------------
# 				SMACK ENERGY FORECASTING 
#--------------------------------------------------------
#			-  Data Clearing Script - NWP -
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
# Date Stamp
declare nwp_ds="\$(date -d yesterday +%Y%m%d)"
# Remove all Today's Files
declare -a files="(\$(ls *\${nwp_ds}*.grib2 2> /dev/null))"
declare -i fcnt="\${#files[@]}";((fcnt=\${fcnt}-1))
rm -f *\${nwp_ds}*.grib2
# Logging
T="\$(date)"
echo -e "\nclr_nwp.sh - run @ \${T}\n\tRemoved: \${fcnt} Files\n" >> "\${CRON_PATH}/log/nwp-load.log"
smack-logout > /dev/null
EOF
# Initialize all Schedules for Deployment
crontab "${CRON_PATH}/nwp-load.cron"
# Log Reporting
echo -e "\nCRON SCHEDULING: COMPLETE" >> $SMACK_INSTALL_LOG
# POPULATE ANY NEEDED FILES
#-----------------------------------
# Generate Environment Script for SMACK Project
cat <<EOF >> $SMACK_DIR/smack-env.sh
#!/bin/bash
# SMACK ENERGY FORECASTING - ENVIRONMENT VARIABLES
#-------------------------------------------------
#
#	The purpose of this script is to setup all 
#	required environment declarations in one 
#	simple location
#
#-------------------------------------------------
# SMACK ENVIRONMENT
export SMACK_DIR=/usr/local/smack
export SMACK_DIR_BIN=/usr/local/smack/bin
export SMACK_DIR_LOG=/usr/local/smack/log
export SMACK_DIR_SKEL=/usr/local/smack/skel
export SMACK_DIR_TMP=/usr/local/smack/tmp
export SMACK_LOAD=/usr/local/smack/log/smack_loaded
export SMACK_INSTALL_LOG=/usr/local/smack/log/install_log
# CRON JOB ROOT
export CRON_PATH=/usr/local/smack/cron
# SHINY SERVER ROOT
export SHINY_SRV=/srv/shiny-server
# API SERVER ROOT
export API_SRV=/srv/api-server
# JAVA VARIABLES
export JAVA_HOME=$JAVA_HOME
export JRE_HOME=$JRE_HOME
# OPENSTACK ENVIRONMENT
# URLs for API Access (may need to change)
export KEYSTONE_URL="https://keystone-yyc.cloud.cybera.ca:5000/v2.0"
export NOVA_URL="https://nova-yyc.cloud.cybera.ca:8774/v2/2b86ecd5b18f4fafb1d55adb79072def"
export CINDER_URL="https://cinder-yyc.cloud.cybera.ca:8776/v1/2b86ecd5b18f4fafb1d55adb79072def"
export CINDER2_URL="https://cinder-yyc.cloud.cybera.ca:8776/v2/2b86ecd5b18f4fafb1d55adb79072def"
export GLANCE_URL="http://glance-yyc.cloud.cybera.ca:9292"
export EC2_URL="https://nova-yyc.cloud.cybera.ca:8773/services/Cloud"
export SWIFT_URL="https://swift-yyc.cloud.cybera.ca:8080/v1/AUTH_2b86ecd5b18f4fafb1d55adb79072def"
# SERVICE AUTHENTICATION CREDENTIALS
# Cron Authentication Using Token and URL with curl requests
declare x1="ke"
export OS_PROJECT_NAME="SMACK"
declare x2="00"
export OS_ZONE="Nova"
declare x3="13"
export OS_REGION="Calgary"
declare x4="ac"
export STORAGE_ACCT="AUTH_4b6be558d44e4dba8fb6e4aa49934c0b"
export STORAGE_TOKEN="7eefd48208754002a2e03bf0de11c3e4"
export STORAGE_URL="https://swift-yyc.cloud.cybera.ca:8080/v1/AUTH_4b6be558d44e4dba8fb6e4aa49934c0b"
# Auth Info
declare uname="confidential.inc@gmail.com"
declare xname="H\${x4}\${x1}r\${x2}\${x3}"
declare pname="SMACK"
# Authenticated API Calls
alias smack-get='curl -s -H "X-Auth-Token: \${STORAGE_TOKEN}" -X GET'
alias smack-put='curl -s -H "X-Auth-Token: \${STORAGE_TOKEN}" -X PUT'
alias smack-post='curl -s -H "X-Auth-Token: \${STORAGE_TOKEN}" -X POST'
alias smack-delete='curl -s -H "X-Auth-Token: \${STORAGE_TOKEN}" -X DELETE'
# Login Authenication overwrite
alias smack-login="source \${SMACK_DIR_BIN}/smack-login"
alias smack-logout="source \${SMACK_DIR_BIN}/smack-logout"
# Python Aliases
alias pip27=/usr/local/bin/pip2.7
alias python27=/usr/local/bin/python2.7
# EXECUTABLE PATH
export PATH="\${PATH}:\${SMACK_DIR_BIN}"
export PATH="\${PATH}:\${JAVA_HOME}/bin"
export PATH="\${PATH}:/usr/local/bin"
# AUTHENTICATION
smack-login -u "\${uname}" -x "\${xname}" -p "\${pname}" > /dev/null
EOF
# Log Reporting
echo -e "\nSMACK ENVIRONMENT SCRIPT: COMPLETE" >> $SMACK_INSTALL_LOG
# ADD WELCOME MESSAGE TO INSTANCE (** Move to Cron @reboot)
#-----------------------------------
cat <<EOT >> /etc/bashrc
## ADDED BY SMACK------------>
# Configure SMACK Environment
shopt -s expand_aliases
source /usr/local/smack/smack-env.sh
smack-logout > /dev/null
# SMACK Command Aliases
figlet -c SMACK Energy Forecasting
echo -e "\t\tSMACK Energy Forecasting - Making an Impact\n"
echo -e "\n#TIP---For a list of commands type smack and press tab.\n"
EOT
# Log Reporting
echo -e "\nWELCOME: COMPLETE" >> $SMACK_INSTALL_LOG
# LIST NODES COMMAND (smack-lsnode)
#-----------------------------------
cat <<EOF >> $SMACK_DIR_BIN/smack-lsnode
#!/bin/bash
# Output Welcome Screen
if [[ -z "\${OS_USERNAME}" || -z "\${OS_PASSWORD}" ]]; then
	echo -e "Error: You are not logged in.\n\tPlease run 'smack-login' and then try again."
	exit 1
else
	clear
	figlet -c SMACK Energy Forecasting
fi
# List Nodes in Cloud
figlet -cf digital NODES LISTING
nova --os-user-name "\${OS_USERNAME}" \\
 	    --os-project-name "\${OS_PROJECT_NAME}" \\
      	--os-password "\${OS_PASSWORD}" \\
      	--os-region-name "\${OS_REGION}" \\
      	--os-auth-url "\${OS_AUTH_URL}" \\
      	list
echo -e "\n\n"
EOF
# Log Reporting
if [ -e "$SMACK_DIR_BIN/smack-lsnode" ]; then
	echo -e "\nLIST NODES: COMPLETE" >> $SMACK_INSTALL_LOG
else
	echo -e "\nLIST NODES: ERROR" >> $SMACK_INSTALL_LOG
fi
# CREATE NODE IN CLOUD COMMAND (smack-mknode)
#--------------------------------------------
cat <<EOF > $SMACK_DIR_BIN/smack-mknode
#!/bin/bash
# Output Welcome Screen
if [[ -z "\${OS_USERNAME}" || -z "\${OS_PASSWORD}" ]]; then
	echo -e "Error: You are not logged in. \n\tPlease run 'smack-login' and then try again."
	exit 1
else
	clear
	figlet -c SMACK Energy Forecasting
fi

while getopts n:f:k:x:i:dh option
do
        case "\${option}"
        in
                n) NAME="\${OPTARG}";;
				f) FLAVOUR="\${OPTARG}";;
				k) KEY="\${OPTARG}";;
				x) SCRIPT="\${OPTARG}";;
				i) IMAGE="\${OPTARG}";;
				d) DEFUALT="TRUE";;
				h) HELP="TRUE";;
        esac
done

# Default Instance Information
declare INT_NAME="default"
declare INT_FLAVOR="m1.tiny"
declare INT_IMAGE="907f21d1-305c-4dee-a64a-43fc1a3701a4"
declare INT_OS="linux"
declare INT_KEY="DevAccess"
declare INT_SECURITY="Default"
declare INT_SCRIPT=""

if ! [[ "\${HELP}" == "TRUE" ]]; then
	echo -e "\nSMACK LOGIN UTILTIY\n\tUsage:\n\t\t-n\tInstance Name\n\t\t-f\t\Flavour\n\t\t-k\tAccess Key\n\t\t-x\tDeployment Script\n\t\t-d\t\Use Default Values\n\t\t-h\tHelp Message\n"
fi

# use Wizard or Defaults
if ! [[ "\${DEFAULT}" == "TRUE" ]]; then
	echo "For Defaults Just Press Enter at Prompt."
	if [[ -z "\${NAME}" ]]; then
		echo -e "\tName (*default):"
		read NAME
	fi
	if [[ -z "\${FLAVOUR}" ]]; then
		echo -e "\tFlavour (*m1.tiny):"
		read FLAVOUR
	fi
	if [[ -z "\${KEY}" ]]; then
		echo -e "\tKey (*DevAccess):"
		read KEY
	fi
	if [[ -z "\${SCRIPT}" ]]; then
		echo -e "\tSetup Script (*setup-node.sh):"
		read SCRIPT
	fi
fi

#  Check for new name and change if necessary
if ! [[ -z "\${NAME}" ]]; then
	INT_NAME="\${NAME}"
fi
if ! [[ -z "\${FLAVOUR}" ]]; then
	INT_FLAVOR="\${FLAVOUR}"
fi
if ! [[ -z "\${KEY}" ]]; then
	INT_KEY="\${KEY}"
fi
if ! [[ -z "\${IMAGE}" ]]; then
	INT_IMAGE="\${IMAGE}"
fi
if ! [[ -z "\${SCRIPT}" ]]; then
	INT_SCRIPT="\${SCRIPT}"
fi
# Display instance information
echo -e "Launching VM Instance: \${INT_NAME}"
echo -e "\tOS Type: \${INT_OS}\n\tFlavour: \${INT_FLAVOR}"
echo -ne "\tImage: \$(nova --os-user-name \${OS_USERNAME} \\
      	--os-project-name \${OS_PROJECT_NAME} \\
      	--os-password \${OS_PASSWORD} \\
      	--os-region-name \${OS_REGION} \\
      	--os-auth-url \${OS_AUTH_URL} \\
  		image-list | grep \${INT_IMAGE} | sed 's/ACTIVE//' | sed s/\${INT_IMAGE}// | sed 's/|//g')"
echo -e "\n\tSecurity Group: \${INT_SECURITY}"
echo -e "\tKey: \${INT_KEY}"
echo -e "\tLaunch Script: \${INT_SCRIPT}"
echo -e "\t------------\n"
# Boot up new instance in cloud
nova --os-user-name "\${OS_USERNAME}" \\
    --os-project-name "\${OS_PROJECT_NAME}" \\
    --os-password "\${OS_PASSWORD}" \\
    --os-region-name "\${OS_REGION}" \\
    --os-auth-url "\${OS_AUTH_URL}" \\
	boot \\
	--flavor "\${INT_FLAVOR}" \\
	--image "\${INT_IMAGE}" \\
	--key-name "\${INT_KEY}" \\
	--user-data "\${INT_SCRIPT}" \\
	--security-group "\${INT_SECURITY}" \\
	"\${INT_NAME}"
# Finish Message
echo -e "\nVM Node Creation Finished. \n\n\t**PLEASE NOTE: Installation of script may take upto a couple hours to \n\t\tcomplete before node is fully deployed.\n"
EOF
# Log Reporting
if [ -e "$SMACK_DIR_BIN/smack-mknode" ]; then
	echo -e "\nMAKE NODE: COMPLETE" >> $SMACK_INSTALL_LOG
else
	echo -e "\nMAKE NODE: ERROR" >> $SMACK_INSTALL_LOG
fi
# LOGIN COMMAND (smack-login)
#-----------------------------------
cat <<EOF > $SMACK_DIR_BIN/smack-login
#!/bin/bash
# Output Welcome Screen
clear
figlet -c SMACK Energy Forecasting
figlet -cf digital Cloud Login
# Clear Varieables
unset UNAME
unset PASSWD
unset PROJECT
unset HELP
# Manual Usage
while getopts u:x:p:h option
do
        case "\${option}"
        in
                u) UNAME="\${OPTARG}";;
                x) PASSWD="\${OPTARG}";;
                p) PROJECT="\${OPTARG}";;
				h) HELP="TRUE";;
        esac
done
# Help Message
if [[ "\${HELP}" == "TRUE" ]]; then
	echo -e "SMACK Login:\n\n\tUsage:\n\t\t-u\t:\tUsername\n\t\t-x\t:\tPassword\n\t\t-p\t:\tProject Name\n\t\t-h\t:\tHelp Message\n"
	exit
fi
# Login and Set Variables
if [[ -z "\${UNAME}" ]]; then
	read -p "Please enter your SMACK Openstack username: " UNAME
fi
if [[ -z "\${PASSWD}" ]]; then
	stty -echo
	read -p "Please enter your SMACK Openstack password: " PASSWD
	stty echo
	echo -e "\n"
fi
if [[ -z "\${PROJECT}" ]]; then
	read -p "Please enter your Project (ie. blank for personal or enter 'SMACK'): " PROJECT
	export OS_PROJECT_NAME="\${UNAME}"
else
	export OS_PROJECT_NAME="\${PROJECT}"
fi
# URLs for API Access (may need to change)
export KEYSTONE_URL="https://keystone-yyc.cloud.cybera.ca:5000/v2.0"
export NOVA_URL="https://nova-yyc.cloud.cybera.ca:8774/v2/2b86ecd5b18f4fafb1d55adb79072def"
export CINDER_URL="https://cinder-yyc.cloud.cybera.ca:8776/v1/2b86ecd5b18f4fafb1d55adb79072def"
export CINDER2_URL="https://cinder-yyc.cloud.cybera.ca:8776/v2/2b86ecd5b18f4fafb1d55adb79072def"
export GLANCE_URL="http://glance-yyc.cloud.cybera.ca:9292"
export EC2_URL="https://nova-yyc.cloud.cybera.ca:8773/services/Cloud"
export SWIFT_URL="https://swift-yyc.cloud.cybera.ca:8080/v1/AUTH_2b86ecd5b18f4fafb1d55adb79072def"
# Login Info
export OS_AUTH_URL="\${KEYSTONE_URL}"
export OS_USERNAME="\${UNAME}"
export OS_PASSWORD="\${PASSWD}"
export OS_REGION="Calgary"
export OS_ZONE="Nova"
# Message
echo -e "\nLogin Complete: You may begin using the toolchain\n"
EOF
# Log Reporting
if [ -e "$SMACK_DIR_BIN/smack-login" ]; then
	echo -e "\nLOGIN: COMPLETE" >> $SMACK_INSTALL_LOG
else
	echo -e "\nLOGIN: ERROR" >> $SMACK_INSTALL_LOG
fi
# LOGOUT COMMAND (smack-logout)
#-----------------------------------
cat <<EOF > $SMACK_DIR_BIN/smack-logout
#!/bin/bash
# Display Message
clear
figlet -c SMACK Energy Forecasting
figlet -cf digital Logging Out...
# Unset Login Details
unset OS_USERNAME
unset OS_PASSWORD
unset OS_PROJECT_NAME
unset OS_REGION
unset OS_AUTH_URL
unset OS_ZONE
# Unset URLs
unset KEYSTONE_URL
unset GLANCE_URL
unset CINDER_URL
unset CINDER2_URL
unset SWIFT_URL
unset NOVA_URL
unset EC2_URL
EOF
# Log Reporting
if [ -e "${SMACK_DIR_BIN}/smack-logout" ]; then
	echo -e "\nLOGOUT: COMPLETE" >> $SMACK_INSTALL_LOG
else
	echo -e "\nLOGOUT: ERROR" >> $SMACK_INSTALL_LOG
fi
# SUSPEND INSTANCE COMMAND
#-----------------------------------
cat <<EOF > $SMACK_DIR_BIN/smack-suspend
#!/bin/bash
# Display Message
clear
figlet -c SMACK Energy Forecasting
figlet -cf digital Suspending...
# Suspend Instance Here
#
#	......
#
EOF
# Log Reporting
if [ -e "${SMACK_DIR_BIN}/smack-suspend" ]; then
	echo -e "\nSUSPEND: COMPLETE" >> $SMACK_INSTALL_LOG
else
	echo -e "\nSUSPEND: ERROR" >> $SMACK_INSTALL_LOG
fi
# TERMINATE INSTANCE COMMAND
#-----------------------------------
cat <<EOF > $SMACK_DIR_BIN/smack-terminate
#!/bin/bash
# Display Message
clear
figlet -c SMACK Energy Forecasting
figlet -cf digital Terminating...
# Terminate Instance Here
#
#	......
#
EOF
# Log Reporting
if [ -e "${SMACK_DIR_BIN}/smack-terminate" ]; then
	echo -e "\nTERMINATE: COMPLETE" >> $SMACK_INSTALL_LOG
else
	echo -e "\nTERMINATE: ERROR" >> $SMACK_INSTALL_LOG
fi
# ASSOCIATE FLOATING IP COMMAND 
#-----------------------------------
cat <<EOF > $SMACK_DIR_BIN/smack-setip
#!/bin/bash
shopt -s expand_alias
# Display Message
if [[ -z "\${OS_USERNAME}" || -z "\${OS_PASSWORD}" ]]; then
	echo -e "Error: You are not logged in. \n\tPlease run 'smack-login' and then try again."
	exit 1
else
	clear
	figlet -c SMACK Energy Forecasting
	figlet -cf digital IP Config
fi
while getopts u:x:p:h option
do
        case "\${option}"
        in
                n) NAME="\${OPTARG}";;
                m) MASTER="TRUE";;
                h) HELP="TRUE";;
        esac
done
if [[ ${HELP} == "TRUE" ]]; then
        echo -e "\nUsage:\n\t-m :\tConfigure Localhost to communicate with Spark Master\n\t-n :\tDisplay the IP of requested node."
fi
# Configure IP Here
echo -e "Downloading and Reading Data\n"
smack-download -c clusters -o "conf/\${NAME}-ip" -x "--output=$SMACK_DIR/tmp/\${NAME}-ip" 1> /dev/null
declare new_ip="$(cat $SMACK_DIR/tmp/\${NAME}-ip)"
echo -e "\${NAME} IP Found: ${new_ip}"
if [[ "$MASTER" == "TRUE" ]]; then
        cat "${SMACK_DIR}/spark/spark-latest/conf/spark-env.sh" |  sed -r "s/SPARK_MASTER_IP=[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}/SPARK_MASTER_IP=${new_ip}/g" > ${SMACK_DIR}/spark/spark-latest/conf/spark-env.sh
        echo -e "\nWriting Master IP Data"
fi
rm "$SMACK_DIR/tmp/\${NAME}-ip"
EOF
# Log Reporting
if [ -e "${SMACK_DIR_BIN}/smack-setip" ]; then
	echo -e "\nIP CONFIG: COMPLETE" >> $SMACK_INSTALL_LOG
else
	echo -e "\nIP CONFIG: ERROR" >> $SMACK_INSTALL_LOG
fi
# ASSOCIATE FLOATING IP COMMAND 
#-----------------------------------
cat <<EOF > $SMACK_DIR_BIN/smack-setip
#!/bin/bash
shopt -s expand_alias
# Display Message
if [[ -z "\${OS_USERNAME}" || -z "\${OS_PASSWORD}" ]]; then
        echo -e "Error: You are not logged in. \n\tPlease run 'smack-login' and then try again."
        exit 1
else
        clear
        figlet -c SMACK Energy Forecasting
        figlet -cf digital IP Config
fi
while getopts u:x:p:h option
do
        case "\${option}"
        in
                n) NAME="\${OPTARG}";;
                m) MASTER="TRUE";;
                h) HELP="TRUE";;
        esac
done
if [[ ${HELP} == "TRUE" ]]; then
        echo -e "\nUsage:\n\t-m :\t Set Localhost as Spark Master\n\t-n :\tDisplay the IP of requested node."
fi
if [[ ${MASTER} == "TRUE" ]]; then
        NAME="master"
fi
# Configure IP Here
echo -e "Downloading and Reading Data\n"
echo $(hostname -i) > ${NAME}-ip
smack-upload -c clusters -o "conf/\${NAME}-ip" -f "${NAME}-ip" 1> /dev/null
declare new_ip="$(cat $SMACK_DIR/tmp/\${NAME}-ip)"
echo -e "\${NAME} IP Set: ${new_ip}"
if [[ "$MASTER" == "TRUE" ]]; then
        cat "${SMACK_DIR}/spark/spark-latest/conf/spark-env.sh" |  sed -r "s/SPARK_MASTER_IP=[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}/SPARK_MASTER_IP=${new_ip}/g" > ${SMACK_DIR}/spark/spark-latest/conf/spark-env.sh
        echo -e "\nWriting Master IP Data"
fi
rm "$SMACK_DIR/tmp/\${NAME}-ip"
EOF
# Log Reporting
if [ -e "${SMACK_DIR_BIN}/smack-setip" ]; then
        echo -e "\nIP CONFIG: COMPLETE" >> $SMACK_INSTALL_LOG
else
        echo -e "\nIP CONFIG: ERROR" >> $SMACK_INSTALL_LOG
fi
# UPLOAD FILE TO CONTAINER COMMAND
#-----------------------------------
cat <<EOF > $SMACK_DIR_BIN/smack-upload
#!/bin/bash
# SMACK -  Make Upload Utility
# Display Message
clear
figlet -c SMACK Energy Forecasting
figlet -cf digital Object Storage Upload Wizard
# Upload Files
# Check for Login
if [[ -z "\${OS_USERNAME}" || -z "\${OS_PASSWORD}" ]]; then
	echo -e "\nPlease Login First. Use 'smack-login' and follow the prompts.\n"
	exit
fi
# Manual Usage
while getopts ac:e:f:ho:H: option
do
        case "\${option}"
        in
                a) ALL="TRUE";;
                c) CONTAINER="\${OPTARG}";;
                e) EXT="\${OPTARG}";;
                f) FILE="\$OPTARG";;
		h) HELP="TRUE";;
		o) NAME="\${OPTARG}";;
		H) HEADERS="\${OPTARG}";;
        esac
done
# -H
if ! [[ -z "\${HEADERS}" ]]; then
	declare HEADERS="-H \${HEADERS}"
fi
# -h 
if [[ "\${HELP}" == "TRUE" ]]; then
	echo -e "SMACK Upload\n\nUsage:\n\t\t-a\tUpload All Files in Directory\n\t\t-e\tUpload all Files with extension\n\t\t-f\tUpload file\n\t\t-o\tObject Name to be saved as\n\t\t-h\tDisplay this Help Message\n"
	exit
fi
# -e Set
if ! [[ -z "\${EXT}" ]]; then
	# Upload all files of extension passed
	echo -e "Function Not Implemented Yet"
	exit
fi
# PROMPTING WIZARD
if [[ -z "\${CONTAINER}" ]]; then
	echo -e "\nCONTAINERS:"
	swift list
	read -p "Please Enter Container: " CONTAINER
fi
# -a Set
if [[ "\${ALL}" == "TRUE" ]]; then
	for files in \$(ls); do
		echo -e "\nUploading \${files} into container \${CONTAINER}...\n"
		swift upload "\${HEADERS}" --object-name "\${files}" "\${CONTAINER}" "\${files}"  2> /dev/null
	done
	exit
fi
if [[ -z "\${FILE}" ]]; then
	read -p "Please Enter the File you wish to Upload: " FILE
fi
if [[ -z "\${NAME}" ]]; then
	read -p "Please Enter a name for the object: " NAME
fi
# TYPE I
echo -e "\nUploading \${FILE} into container \${CONTAINER}...\n"
swift upload "\${HEADERS}" --object-name "\${NAME}" "\${CONTAINER}" "\${FILE}" 2> /dev/null
echo -e "\nUploading Object \${NAME} Complete.\n"
EOF
# Log Reporting
if [ -e "${SMACK_DIR_BIN}/smack-upload" ]; then
	echo -e "\nSWIFT UPLOAD: COMPLETE" >> $SMACK_INSTALL_LOG
else
	echo -e "\nSWIFT UPLOAD: ERROR" >> $SMACK_INSTALL_LOG
fi
# DOWNLOAD FILE FROM CONTAINER COMMAND
#-----------------------------------
cat <<EOF > $SMACK_DIR_BIN/smack-download
#!/bin/bash
# Display Message
clear
figlet -c SMACK Energy Forecasting
figlet -cf digital Object Storage Download Wizard
# Download from Swift Here
# Check for Login
if [[ -z "\${OS_USERNAME}" || -z "\${OS_PASSWORD}" ]]; then
	echo -e "\nPlease Login First. Use 'smack-login' and follow the prompts.\n"
	exit
fi
# Manual Usage
while getopts ac:f:ho:x: option
do
        case "\${option}"
        in
                a) ALL="TRUE";;
                c) CONTAINER="\${OPTARG}";;
                f) FILE="\${OPTARG}";;
		h) HELP="TRUE";;
		o) OBJECT="\${OPTARG}";;
		x) CMD="\${OPTAGR}";;
        esac
done

# -h 
if [[ "\${HELP}" == "TRUE" ]]; then
	echo -e "SMACK Download\n\nUsage:\n\t\t-a\tDownload All Files in Container\n\t\t-f\tDownload file Name\n\t\t-o\tObject Name to be Downloaded\n\t\t-h\tDisplay this Help Message\n"
	exit
fi
# PROMPTING WIZARD
if [[ -z "\${CONTAINER}" ]]; then
	echo -e "\nCONTAINERS:"
	swift list
	read -p "Which Container would you like to list: " CONTAINER
fi
if [[ -z "\${OBJECT}" ]]; then
	echo -e "\nCONTAINER: \${CONTAINER}"
	swift list "\${CONTAINER}" | more
	read -p "What Object would you like to download: " OBJECT
fi
echo -e "Downloading \${OBJECT} from \${CONTAINER}..."
# TYPE I
# -a Set
if [[ "\${ALL}" == "TRUE" ]]; then
	swift download ${CMD} "\${CONTAINER}" 
	exit
fi
if [[ -z "\${FILE" ]]; then
	swift download ${CMD} "\${CONTAINER}" "\${OBJECT}"
else
	swift download ${CMD} --output="${FILE}" "\${CONTAINER}" "\${OBJECT}"
fi
echo -e "Downloading \${OBJECT} Complete."
EOF
# Log Reporting
if [ -e "${SMACK_DIR_BIN}/smack-download" ]; then
	echo -e "\nSWIFT DOWNLOAD: COMPLETE" >> $SMACK_INSTALL_LOG
else
	echo -e "\nSWIFT DOWNLOAD: ERROR" >> $SMACK_INSTALL_LOG
fi
# LIST CONTAINERS FROM OBJECT STORAGE COMMAND
#-----------------------------------
cat <<EOF > ${SMACK_DIR_BIN}/smack-lsdb
#!/bin/bash
# Display Message
clear
figlet -c SMACK Energy Forecasting
figlet -cf digital Object Storage Listing Wizard
# Download from Swift Here
# Check for Login
if [[ -z "\${OS_USERNAME}" || -z "\${OS_PASSWORD}" ]]; then
	echo -e "\nPlease Login First. Use 'smack-login' and follow the prompts.\n"
	exit
fi
# Manual Usage
while getopts lso:c:h option
do
        case "\${option}"
        in
                l) ROOT="TRUE";;
                c) CONTAINER="\${OPTARG}";;
                s) STAT="TRUE";;
				h) HELP="TRUE";;
				o) OBJECT="\${OPTARG}";;
        esac
done
# -h
if [[ "\${HELP}" == "TRUE" ]]; then
	echo -e "\nSMACK Object Storage Listing\n\nUsage\n\t\t-l\tList Root Container\n\t\t-h\tList This Help Message\n\t\t-s\tList Container Statistics\n\t\t-c\tContainer to List\n\t\t-o\tObject to List Statistics\n"
	exit
fi

# -l 
if [[ "\${ROOT}" == "TRUE" ]]; then
	swift list
	exit
fi
# Prompting Wizard
if [[ -z "\${CONTAINER}" ]]; then
	echo -e "\nCONTAINERS:"
	swift list
	read -p "Which Container (type quit to exit): " CONTAINER
else
	swift list "\${CONTAINER}"
	exit
fi
# -s
if [[ "\${STAT}" == "TRUE" ]]; then
	swift stat "\${CONTAINER}"
	exit
fi
# -o
if [[ -n "\${OBJECT}" ]]; then
	swift stat "\${CONTAINER}" "\${OBJECT}"
	exit
fi

# Prompting Loop
while [[ "\${CONTAINER}" != "quit" ]]; do
	swift list "\${CONTAINER}"
	read -p "Which Container (type 'quit' to leave): " CONTAINER
done
EOF
# Log Reporting
if [ -e "${SMACK_DIR_BIN}/smack-lsdb" ]; then
	echo -e "\nSWIFT LIST CONTAINER: COMPLETE" >> $SMACK_INSTALL_LOG
else
	echo -e "\nSWIFT LIST CONTAINER: ERROR" >> $SMACK_INSTALL_LOG
fi
# MAKE CONTAINERS FROM OBJECT STORAGE COMMAND
#-----------------------------------
cat <<EOF > $SMACK_DIR_BIN/smack-mkdb
#!/bin/bash
# Display Message
clear
figlet -c SMACK Energy Forecasting
figlet -cf digital Container Creation Wizard
# Download from Swift Here
# Check for Login
if [[ -z "\${OS_USERNAME}" || -z "\${OS_PASSWORD}" ]]; then
	echo -e "\nPlease Login First. Use 'smack-login' and follow the prompts.\n"
	exit
fi

# Manual Usage
while getopts c:h option
do
        case "\${option}"
        in
                c) CONTAINER="\${OPTARG}";;
                h) HELP="TRUE";;
        esac
done

# -h
if [[ "\${HELP}" == "TRUE" ]]; then
        echo -e "\nSMACK Object Storage Container Creation\n\nUsage\n\t\t-h\tList This Help Message\n\t\t-c\tContainer to List\n"
        exit
fi

# -c
if [[ -z "\${CONTAINER}" ]]; then
        echo -e "\nWelcome to the Container Creation Wizard.\n\tTo create a container please follow the instructions.\n\nCurrent Containers:\n"
        swift list 2> /dev/null
        read -p "Enter name of container you wish to create: " CONTAINER
fi
# TYPE I    
swift post "\${CONTAINER}" 2> /dev/null
echo -e "\nContainer Successfully Created"
EOF
# Log Reporting
if [ -e "${SMACK_DIR_BIN}/smack-mkdb" ]; then
	echo -e "\nSWIFT MAKE CONTAINER: COMPLETE" >> $SMACK_INSTALL_LOG
else
	echo -e "\nSWIFT MAKE CONTAINER: ERROR" >> $SMACK_INSTALL_LOG
fi
# ADD SKELETON SETUP FILE ONTO SERVER
#-----------------------------------
cat <<EOF > $SMACK_DIR/skel/setup-node.sh
#!/bin/bash
#--------------------------------------------------------
# 				SMACK ENERGY FORECASTING 
#--------------------------------------------------------
#		- Basic Initialization Script for Nodes -
#--------------------------------------------------------
#	Copy and modify this script file to aide in the 
#	launching of nodes. This is a bash script, so if you
#	wish to launch it as something else, please do so.
#
#	This is a basic implentation and does nothing. It is
#	merely meant as a basic placeholder for you to start
#	with.
#--------------------------------------------------------
#
#
#	DEFINITIONS:
#
#
#	INSTALLATIONS AND UPDATES:
#
#
#	SOFTWARE CONFIGURATION
#
#
#	FILE CREATION
#
#
#	LOG KEEPING AND REPORTING
#
#
#-------------------------------------------------------
EOF
# SET PERMISSIONS FOR COMMANDS
#-----------------------------------
# SMACK Directory
chmod 700 ${SMACK_DIR_BIN}
chmod 700 ${SMACK_DIR}/skel
chmod 700 ${SMACK_DIR_LOG}
chmod 700 ${SMACK_DIR_TMP}
chmod +x ${SMACK_DIR_BIN}/*
# CRON Directory
chmod 700 ${CRON_PATH}
chmod 700 ${CRON_PATH}/bin
chmod 700 ${CRON_PATH}/log
chmod +x ${CRON_PATH}/bin/*
chown -R centos ${SMACK_DIR}
# Log Reporting
echo -e "\nPERMISSIONS: COMPLETE" >> ${SMACK_INSTALL_LOG}
# SET FILE FOR COMPLETION
#-----------------------------------
touch $SMACK_LOAD
echo -e "\n### INSTALL: COMPLETE ###" >> ${SMACK_INSTALL_LOG}
fi
# FINISHED