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
declare -x KEYSTONE_URL="https://keystone-yyc.cloud.cybera.ca:5000/v2.0"
declare -x NOVA_URL="https://nova-yyc.cloud.cybera.ca:8774/v2/2b86ecd5b18f4fafb1d55adb79072def"
declare -x CINDER_URL="https://cinder-yyc.cloud.cybera.ca:8776/v1/2b86ecd5b18f4fafb1d55adb79072def"
declare -x CINDER2_URL="https://cinder-yyc.cloud.cybera.ca:8776/v2/2b86ecd5b18f4fafb1d55adb79072def"
declare -x GLANCE_URL="http://glance-yyc.cloud.cybera.ca:9292"
declare -x EC2_URL="https://nova-yyc.cloud.cybera.ca:8773/services/Cloud"
declare -x SWIFT_URL="https://swift-yyc.cloud.cybera.ca:8080/v1/AUTH_2b86ecd5b18f4fafb1d55adb79072def"
# SERVICE AUTHENTICATION CREDENTIALS
# Cron Authentication Using Token and URL with curl requests
declare -x OS_PROJECT_NAME="SMACK"
declare -x OS_ZONE="Nova"
declare -x OS_REGION="Calgary"
declare -x -r STORAGE_ACCT="AUTH_4b6be558d44e4dba8fb6e4aa49934c0b"
declare -x -r STORAGE_TOKEN="7eefd48208754002a2e03bf0de11c3e4"
declare -x -r STORAGE_URL="https://swift-yyc.cloud.cybera.ca:8080/v1/AUTH_4b6be558d44e4dba8fb6e4aa49934c0b"
# SMACK ENVIRONMENT
declare -r -x SMACK_DIR=/usr/local/smack
declare -r -x SMACK_DIR_BIN=/usr/local/smack/bin
declare -r -x SMACK_DIR_LOG=/usr/local/smack/log
declare -r -x SMACK_DIR_SKEL=/usr/local/smack/skel
declare -r -x SMACK_DIR_TMP=/usr/local/smack/tmp
declare -r -x SMACK_LOAD=/usr/local/smack/log/smack_loaded
declare -r -x SMACK_INSTALL_LOG=/usr/local/smack/log/install_log
# CRON JOB ROOT
declare -r -x CRON_PATH=/usr/local/smack/cron
# SHINY SERVER ROOT
declare -r -x SHINY_SRV=/srv/shiny-server
# API SERVER ROOT
declare -r -x API_SRV=/srv/api-server
# EXECUTABLE PATH
export PATH=\${PATH}:\${SMACK_DIR_BIN}
export PATH=\${PATH}:\${JAVA_HOME}/bin
export PATH=\${PATH}:/usr/local/bin
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
mkdir $CRON_PATH/bin
mkdir $CRON_PATH/log
mkdir ${SHINY_SRV}
mkdir ${API_SRV}
# Log Reporting
echo -e "\nDIRECTORIES: COMPLETE" >> $SMACK_INSTALL_LOG


# UPDATE PACKAGES AND TOOLCHAIN
#-----------------------------------
#yum -y update
yum -y install gcc-c++ wget curl curl-devel figlet python
yum -y install make binutils git nmap man maven libffi-devel
yum -y install nano python-devel python-pip links nodejs npm
yum -y groupinstall "Development Tools"
yum -y install zlib-devel bzip2-devel openssl-devel libxml2-devel
yum -y install ncurses-devel sqlite-devel readline-devel zlibrary-devel
yum -y install tk-devel gdbm-devel db4-devel libpcap-devel xz-devel zip-devel
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
# Adjust for warnings
cd /usr/local/lib/python2.7/site-packages/keystoneclient/
cp service_catalog.py service_catalog.py.bak
cat service_catalog.py | sed -r 's/import warnings/import warnings\nwarnings.filterwarning("ignore")/' > service_catalog.py
# OPENSTACK TOOLS FOR PYTHON 3.5
#-------------------------------------
/usr/local/bin/pip3.5 install requests['security']
/usr/local/bin/pip3.5 install python-openstackclient
/usr/local/bin/pip3.5 install python-swiftclient
/usr/local/bin/pip3.5 install --upgrade setuptools
/usr/local/bin/pip3.5 install scipy
/usr/local/bin/pip3.5 install numpy
# Adjust for warnings
cd /usr/local/lib/python3.5/site-packages/keystoneclient/
cp service_catalog.py service_catalog.py.bak
cat service_catalog.py | sed -r 's/import warnings/import warnings\nwarnings.filterwarning("ignore")/' > service_catalog.py
# Log Reporting
echo -e "\nOPENSTACK CLIENTS: COMPLETE" >> $SMACK_INSTALL_LOG


# INSTALL R FROM CRAN		- FOR WEBSERVER DEV
#-----------------------------------
# install R + Packages
yum -y install R
R -e "install.packages('shiny', repos='http://cran.stat.sfu.ca/')"
R -e "install.packages('shiny', repos='http://cran.stat.sfu.ca/')"
R -e "install.packages('shinydashboard', repos='http://cran.stat.sfu.ca/')"
R -e "install.packages('devtools', repos='http://cran.stat.sfu.ca/')"
R -e "install.packages('ggplot2', repos='http://cran.stat.sfu.ca/')"
R -e "install.packages('dplyr', repos='http://cran.stat.sfu.ca/')"
# install shiny-server daemon
mkdir /tmp/shiny
cd /tmp/shiny
wget "https://download3.rstudio.org/centos5.9/x86_64/shiny-server-1.4.1.759-rh5-x86_64.rpm"
yum -y install --nogpgcheck shiny-server-1.4.1.759-rh5-x86_64.rpm
# Set to Port 80
mv /etc/shiny-server/shiny-server.conf /etc/shiny-server/shiny-server.conf.bak
cat /etc/shiny-server/shiny-server.conf.bak | sed 's/3838/80/g' > /etc/shiny-server/shiny-server.conf

# Web Server Index Page
cat << EOF > /srv/shiny-server/index.html
<!DOCTYPE html>
<html>
<head>
<title>SMACK Energy Forecasting</title>
</head>
<body>
<h1> SMACK Energy Forecasting - * DRAFT * </h1>
<br/>
<h2> This page was loaded using the SMACK Deployment Method! </h2>
<br/>
<h3> Please select from the available demos: </h3>
<ul>
<li><a href="/sample-apps/hello">Hello</a></li>
<li><a href="/demo">Simple UI</a></li>
<li><a href="/api_demo">API Demo</a></li>
</ul>
<h2>Thank you for choosing SMACK!</h2>
</body>
</html>
EOF
# Log Reporting
echo -e "\nR AND SHINY SERVER: COMPLETE" >> $SMACK_INSTALL_LOG

# INSTALL API SERVER AND CONFIGURE
#------------------------------------
# Make Server Directory
cd $API_SRV
# Generate Package.json file
#
# cat << EOF > Package.json
#
# Install Express and Request Libraries
npm install express --save
npm install request --save
# Generate API Backend
#
#	cat << EOF > app.js
#
# Initialize and start nodejs server
#
# Logging Record
echo -e "\nAPI BACKEND: COMPLETE\n" >> $SMACK_INSTALL_LOG


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
	#alternatives --install /usr/bin/jar jar /usr/java/jdk1.7.0_79/bin/jar 2
# Set Version to 1.7
alternatives --set java /usr/java/jdk1.7.0_79/bin/java
alternatives --set javac /usr/java/jdk1.7.0_79/bin/javac
	#alternatives --set jar /usr/java/jdk1.7.0_79/bin/jar
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
	#alternatives --install /usr/bin/jar jar /usr/java/jdk1.8.0_40/bin/jar 2
# Set Version to 1.8
alternatives --set java /usr/java/jdk1.8.0_40/bin/java
alternatives --set javac /usr/java/jdk1.8.0_40/bin/javac
	#alternatives --set jar /usr/java/jdk1.8.0_40/bin/jar
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
cat << EOF > $SMACK_DIR/cron/nwp-load.cron
#--------------------------------------------------------
# 				SMACK ENERGY FORECASTING 
#--------------------------------------------------------
#			- CRON Tab for SMACK Data Retrieval -
#--------------------------------------------------------
#	This CRON tab is designed to retrieve and store data
#	from environment Canada - NWP - by downloading and
#	storing GRIB2 files and placing them into an organized
#	Swift Storage Database
#--------------------------------------------------------

# Define Path for Scripts
source /usr/local/smack/smack-env.sh

# Retrieve and Store Temporarily (starting 00:05 - every 06:00)
5 */6 * * * \${CRON_PATH}/bin/ret_nwp.sh
# Check Retrieved Files and Fill if necessary
25 */6 * * * \${CRON_PATH}/bin/chk_nwp.sh
# Store files to Swift Storage
45 */6 * * * \${CRON_PATH}/bin/str_nwp.sh
# Clear Temp Files (every 24 Hours)
0 0 * * * \${CRON_PATH}/bin/clr_nwp.sh
EOF

# Generate Related Cron Files
cat << EOF > $CRON_PATH/bin/ret_nwp.sh
#!/bin/bash
#--------------------------------------------------------
# 				SMACK ENERGY FORECASTING 
#--------------------------------------------------------
#			-  Data Retrieval Script - NWP -
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

# REMOTE SERVER INFORMATION
# Server
declare -r nwp_srv="http://dd.weather.gc.ca/model_hrdps/west/grib2"
# Readout Times
declare -r -a nwp_tz=( "00" "06" "12" "18" )
# Sections
declare -r -a nwp_sec=( "000" "001" "002" "003" "004" "005" "006" \
						"007" "008" "009" "010" "011" "012" "013" \
						"014" "015" "016" "017" "018" "019" "020" \
						"021" "022" "023" "024" "025" "026" "027" \
						"028" "029" "030" "031" "032" "033" "034" \
						"035" "036" "037" "038" "039" "040" "041" \
						"042" "043" "044" "045" "046" "047" "048")
# File Prefix
declare -r nwp_pre="CMC_hrdps_west_"
# File Suffix
declare -r nwp_suf="-00.grib2"
# Date Stamp
declare -r nwp_ds=$(date +%Y%m%d)
# Wind Variables
declare -r -a nwp_var=( "WIND_ISBL_0050_ps2.5km_" "WIND_ISBL_0100_ps2.5km_" \
						"WIND_ISBL_0150_ps2.5km_" "WIND_ISBL_0175_ps2.5km_" \
						"WIND_ISBL_0200_ps2.5km_" "WIND_ISBL_0225_ps2.5km_" \
						"WIND_ISBL_0250_ps2.5km_" "WIND_ISBL_0275_ps2.5km_" \
						"WIND_ISBL_0300_ps2.5km_" "WIND_ISBL_0350_ps2.5km_" \
						"WIND_ISBL_0400_ps2.5km_" "WIND_ISBL_0450_ps2.5km_" \
						"WIND_ISBL_0500_ps2.5km_" "WIND_ISBL_0550_ps2.5km_" \
						"WIND_ISBL_0600_ps2.5km_" "WIND_ISBL_0650_ps2.5km_" \
						"WIND_ISBL_0700_ps2.5km_" "WIND_ISBL_0750_ps2.5km_" \
						"WIND_ISBL_0800_ps2.5km_" "WIND_ISBL_0850_ps2.5km_" \
						"WIND_ISBL_0875_ps2.5km_" "WIND_ISBL_0900_ps2.5km_" \
						"WIND_ISBL_0925_ps2.5km_" "WIND_ISBL_0950_ps2.5km_" \
						"WIND_ISBL_0970_ps2.5km_" "WIND_ISBL_0985_ps2.5km_" \
						"WIND_ISBL_1000_ps2.5km_" "WIND_ISBL_1015_ps2.5km_" \
						"WIND_TGL_10_ps2.5km_" "WIND_TGL_40_ps2.5km_" \
						"WIND_TGL_80_ps2.5km_" "WIND_TGL_120_ps2.5km_")
# File Counter
declare -i fcnt=0
# Loop through all file and Retrieve
# Time Zones
for a in \${nwp_tz[\@]}; do
	# sections
	for b in \${nwp_sec[\@]}; do
		# variables
		for c in \${nwp_var[\@]}; do
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
			\(\(fcnt=\${fcnt}+1\)\)
		done
	done
done
# Log Run into History
T=`date`
touch "\${CRON_PATH}/log/nwp-load.log"
echo -e "\nret_nwp.sh - run @ \${T}\n\tRetreived: \${fcnt} Files" >> "\$CRON_PATH/log/nwp-load.log"
EOF

# Generate Related Cron Files
cat << EOF > $CRON_PATH/bin/chk_nwp.sh
#!/bin/bash
#--------------------------------------------------------
# 				SMACK ENERGY FORECASTING 
#--------------------------------------------------------
#			-  Data Checking Script - NWP -
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
# Begin Downloading Missed Files from NWP (For Recent Time)
#
# For all Variables that are missing download appropriate time
#	* Check against known variables
#	* Check off any missing
#	* Download missing variables
#
declare T=`date`
echo -e "\chk_nwp.sh - run @ \${T}\n" >> "\${CRON_PATH}"/log/nwp-load.log
EOF

# Generate Related Cron Files
cat << EOF > $CRON_PATH/bin/str_nwp.sh
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
if [ -z "$(smack-lsdb | grep \${nwp_con})" ]; then
	smack-mkdb -c "\${nwp_con}" > /dev/null
fi
declare -i fcnt=0
# Loop through each file and Upload:
for filename in *\${nwp_ds}*.grib2; do
	#echo -e "Uploading to Swift: ${filename}\n"
	smack-upload -c "\${nwp_con}" -f "\${filename}" -o "\${nwp_pse}/\${filename}" > /dev/null
	
	smack-put
	# Count # of Uploads
	\(\(fcnt=\${fcnt}+1\)\)
done
# Log Recording
T=`date`
echo -e "\nstr_nwp.sh - run @ \${T}\n\tStored: \${fcnt} Files\n" >> "\${CRON_PATH}/log/nwp-load.log"
EOF

# Generate Related Cron Files
cat << EOF > $CRON_PATH/bin/clr_nwp.sh
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
EOF

# Initialize all Schedules for Deployment
# crontab $CRON_PATH/nwp-load.cron
# Log Reporting
echo -e "\nCRON SCHEDULING: COMPLETE" >> $SMACK_INSTALL_LOG

# POPULATE ANY NEEDED FILES
#-----------------------------------
# Generate Environment Script for SMACK Project
cat << EOF >> $SMACK_DIR/smack-env.sh
# SMACK ENERGY FORECASTING - ENVIRONMENT VARIABLES
#-------------------------------------------------
#
#	The purpose of this script is to setup all 
#	required environment declarations in one 
#	simple location
#
#-------------------------------------------------

# SMACK ENVIRONMENT
declare -r -x SMACK_DIR=/usr/local/smack
declare -r -x SMACK_DIR_BIN=/usr/local/smack/bin
declare -r -x SMACK_DIR_LOG=/usr/local/smack/log
declare -r -x SMACK_DIR_SKEL=/usr/local/smack/skel
declare -r -x SMACK_DIR_TMP=/usr/local/smack/tmp
declare -r -x SMACK_LOAD=/usr/local/smack/log/smack_loaded
declare -r -x SMACK_INSTALL_LOG=/usr/local/smack/log/install_log

# CRON JOB ROOT
declare -r -x CRON_PATH=/usr/local/smack/cron

# SHINY SERVER ROOT
declare -r -x SHINY_SRV=/srv/shiny-server

# API SERVER ROOT
declare -r -x API_SRV=/srv/api-server

# JAVA VARIABLES
declare -r -x JAVA_HOME=$JAVA_HOME
declare -r -x JRE_HOME=$JRE_HOME

# OPENSTACK ENVIRONMENT
# URLs for API Access (may need to change)
declare -r -x KEYSTONE_URL="https://keystone-yyc.cloud.cybera.ca:5000/v2.0"
declare -r -x NOVA_URL="https://nova-yyc.cloud.cybera.ca:8774/v2/2b86ecd5b18f4fafb1d55adb79072def"
declare -r -x CINDER_URL="https://cinder-yyc.cloud.cybera.ca:8776/v1/2b86ecd5b18f4fafb1d55adb79072def"
declare -r -x CINDER2_URL="https://cinder-yyc.cloud.cybera.ca:8776/v2/2b86ecd5b18f4fafb1d55adb79072def"
declare -r -x GLANCE_URL="http://glance-yyc.cloud.cybera.ca:9292"
declare -r -x EC2_URL="https://nova-yyc.cloud.cybera.ca:8773/services/Cloud"
declare -r -x SWIFT_URL="https://swift-yyc.cloud.cybera.ca:8080/v1/AUTH_2b86ecd5b18f4fafb1d55adb79072def"

# SERVICE AUTHENTICATION CREDENTIALS
# Cron Authentication Using Token and URL with curl requests
declare -x OS_PROJECT_NAME="SMACK"
declare -x OS_ZONE="Nova"
declare -x OS_REGION="Calgary"
declare -x -r STORAGE_ACCT="AUTH_4b6be558d44e4dba8fb6e4aa49934c0b"
declare -x -r STORAGE_TOKEN="7eefd48208754002a2e03bf0de11c3e4"
declare -x -r STORAGE_URL="https://swift-yyc.cloud.cybera.ca:8080/v1/AUTH_4b6be558d44e4dba8fb6e4aa49934c0b"

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
declare -x PATH=\${PATH}:\${SMACK_DIR_BIN}
declare -x PATH=\${PATH}:\${JAVA_HOME}/bin
declare -x PATH=\${PATH}:/usr/local/bin
EOF
#

# POPULATE SHINY SERVER FILES FOR DEPLOYMENT
#-----------------------------------

# WEB DEMO - FOR PRESENTATION
#------------------------------------
# Make directory for Shiny App
mkdir $SHINY_SRV/demo
# Write Server File (app.R)
cat << EOF > $SHINY_SRV/demo/app.R
library(shiny)
library(shinydashboard)
ui <- dashboardPage(
	dashboardHeader(title="SMACK Energy Forecasting"),
	dashboardSidebar(
		sidebarMenu(
			menuItem("Overview", tabName="overview", icon=icon("dashboard")),
			menuItem("Data", tabName="data", icon=icon("th")),
			menuItem("Other", tabName="other")
		)
	),	
	dashboardBody(
		tabItems(
			tabItem(tabName="overview",
				h2("SMACK Overview")
			),
			tabItem(tabName="data",
				h2("SMACK Data")
			),
			tabItem(tabName="other",
				h2("SMACK Other")
			)
		)
	)
)
server <- function(input, output) {}
shinyApp(ui,server)
EOF
# End Of Shiny File ----
# Log Reporting
echo -e "\nSHINY DEMO: COMPLETE" >> $SMACK_INSTALL_LOG


# INSTALL API DEMO - FOR TASK 5 PRESENTATION
#---------------------------------------
# Make Demo Directory
mkdir $SHINY_SRV/api_demo
cat << EOF > $SHINY_SRV/api_demo/app.R
library(shiny)
library(shinydashboard)
ui <- dashboardPage(
	dashboardHeader(title="SMACK Energy Forecasting- API Demo"),
	dashboardSidebar(),	
	dashboardBody()
)
server <- function(input, output) {}
shinyApp(ui,server)
EOF
# Log Reporting
echo -e "\nAPI DEMO: COMPLETE" >> $SMACK_INSTALL_LOG


# ADD WELCOME MESSAGE TO INSTANCE (** Move to Cron @reboot)
#-----------------------------------
cat << EOT >> /etc/bashrc
# Setup SMACK Environment
source /usr/local/smack/smack-env.sh
# Welcome Message
figlet -c SMACK Energy Forecasting
echo -e "\t\tSMACK Energy Forecasting - Making an Impact\n"
echo -e "\n#TIP---For a list of commands type smack and press tab.\n"
EOT
# Log Reporting
echo -e "\nWELCOME: COMPLETE" >> $SMACK_INSTALL_LOG


# LIST NODES COMMAND (smack-lsnode)
#-----------------------------------
cat << EOF >> $SMACK_DIR_BIN/smack-lsnode
#!/bin/bash
# Output Welcome Screen
if [ -z "\${OS_USERNAME}" ] || [ -z "\${OS_PASSWORD}" ]; then
	echo -e "Error: You are not logged in.\n\tPlease run 'smack-login' and then try again."
	exit 1
else
	figlet -c SMACK Energy Forecasting
fi
# List Nodes in Cloud
figlet -cf digital NODES LISTING
nova --os-user-name "\${OS_USERNAME}" \\
 	    --os-project-name "\${OS_PROJECT_NAME}" \\
      	--os-password "\${OS_PASSWORD}" \\
      	--os-region-name "\${OS_REGION}" \\
      	--os-auth-url "\${OS_AUTH_URL}" \\
      	--os-auth-url "\${OS_AUTH_URL}" \\
      	list
EOF
# Log Reporting
if [ -e "$SMACK_DIR_BIN/smack-lsnode" ]; then
	echo -e "\nLIST NODES: COMPLETE" >> $SMACK_INSTALL_LOG
else
	echo -e "\nLIST NODES: ERROR" >> $SMACK_INSTALL_LOG
fi


# CREATE NODE IN CLOUD COMMAND (smack-mknode)
#--------------------------------------------
cat << EOF > $SMACK_DIR_BIN/smack-mknode
#!/bin/bash
# Output Welcome Screen
if [ -z "\${OS_USERNAME}" ] || [ -z "\${OS_PASSWORD}" ]; then
	echo -e "Error: You are not logged in. \n\tPlease run 'smack-login' and then try again."
	exit 1
else
	figlet -c SMACK Energy Forecasting
fi

# Default Instance Information
declare INT_NAME="default"
declare INT_FLAVOR="m1.tiny"
declare INT_IMAGE="907f21d1-305c-4dee-a64a-43fc1a3701a4"
declare INT_OS="linux"
declare INT_KEY="DevAccess"
declare INT_SECURITY="Default"
declare INT_SCRIPT=""

# Boot and Launch Instance
echo "For Defaults Just Press Enter at Prompt."
echo -e "\tName (*default):"
read NAME
echo -e "\tFlavour (*m1.tiny):"
read FLAVOUR
echo -e "\tKey (*DevAccess):"
read KEY
echo -e "\tSetup Script (*setup-node.sh):"
read SCRIPT
#  Check for new name and change if necessary
if ! [ -z "\${NAME}" ]; then
	INT_NAME="\${NAME}"
fi
if ! [ -z "\${FLAVOUR}" ]; then
	INT_FLAVOR="\${FLAVOUR}"
fi
if ! [ -z "\${KEY}" ]; then
	INT_KEY="\${KEY}"
fi
if ! [ -z "\${SCRIPT}" ]; then
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
EOF
# Log Reporting
if [ -e "$SMACK_DIR_BIN/smack-mknode" ]; then
	echo -e "\nMAKE NODE: COMPLETE" >> $SMACK_INSTALL_LOG
else
	echo -e "\nMAKE NODE: ERROR" >> $SMACK_INSTALL_LOG
fi


# LOGIN COMMAND (smack-login)
#-----------------------------------
cat << EOF > $SMACK_DIR_BIN/smack-login
#!/bin/bash
# Output Welcome Screen
figlet -c SMACK Energy Forecasting
figlet -cf digital Cloud Login
# Login and Set Variables
read -p "Please enter your SMACK Openstack username: " UNAME
stty -echo
read -p "Please enter your SMACK Openstack password: " PASSWD
stty echo
echo -e "\n"
read -p "Please enter your Project (ie. blank for personal or enter 'SMACK'): " PROJECT
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
if [ -z "\${PROJECT}" ]; then
	export OS_PROJECT_NAME="\${UNAME}"
else
	export OS_PROJECT_NAME="\${PROJECT}"
fi
EOF
# Log Reporting
if [ -e "$SMACK_DIR_BIN/smack-login" ]; then
	echo -e "\nLOGIN: COMPLETE" >> $SMACK_INSTALL_LOG
else
	echo -e "\nLOGIN: ERROR" >> $SMACK_INSTALL_LOG
fi


# LOGOUT COMMAND (smack-logout)
#-----------------------------------
cat << EOF > $SMACK_DIR_BIN/smack-logout
#!/bin/bash
# Display Message
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
if [ -e "$SMACK_DIR_BIN/smack-logout" ]; then
	echo -e "\nLOGOUT: COMPLETE" >> $SMACK_INSTALL_LOG
else
	echo -e "\nLOGOUT: ERROR" >> $SMACK_INSTALL_LOG
fi

# SUSPEND INSTANCE COMMAND
#-----------------------------------
cat << EOF > $SMACK_DIR_BIN/smack-suspend
#!/bin/bash
# Display Message
figlet -c SMACK Energy Forecasting
figlet -cf digital Suspending...
# Suspend Instance Here
#
#	......
#
EOF
# Log Reporting
if [ -e "$SMACK_DIR_BIN/smack-suspend" ]; then
	echo -e "\nSUSPEND: COMPLETE" >> $SMACK_INSTALL_LOG
else
	echo -e "\nSUSPEND: ERROR" >> $SMACK_INSTALL_LOG
fi

# TERMINATE INSTANCE COMMAND
#-----------------------------------
cat << EOF > $SMACK_DIR_BIN/smack-terminate
#!/bin/bash
# Display Message
figlet -c SMACK Energy Forecasting
figlet -cf digital Terminating...
# Terminate Instance Here
#
#	......
#
EOF
# Log Reporting
if [ -e "$SMACK_DIR_BIN/smack-terminate" ]; then
	echo -e "\nTERMINATE: COMPLETE" >> $SMACK_INSTALL_LOG
else
	echo -e "\nTERMINATE: ERROR" >> $SMACK_INSTALL_LOG
fi

# ASSOCIATE FLOATING IP COMMAND 
#-----------------------------------
cat << EOF > $SMACK_DIR_BIN/smack-setip
#!/bin/bash
# Display Message
figlet -c SMACK Energy Forecasting
figlet -cf digital IP Config
# Configure IP Here
#
#	......
#
EOF
# Log Reporting
if [ -e "$SMACK_DIR_BIN/smack-setip" ]; then
	echo -e "\nIP CONFIG: COMPLETE" >> $SMACK_INSTALL_LOG
else
	echo -e "\nIP CONFIG: ERROR" >> $SMACK_INSTALL_LOG
fi

# UPLOAD FILE TO CONTAINER COMMAND
#-----------------------------------
cat << EOF > $SMACK_DIR_BIN/smack-upload
#!/bin/bash
# Display Message
figlet -c SMACK Energy Forecasting
figlet -cf digital Object Storage Upload Wizard
# Upload Files
# Check for Login
if [ -z "\${OS_USERNAME}" ] || [ -z "\${OS_PASSWORD}" ]; then
	echo -e "\nPlease Login First. Use 'smack-login' and follow the prompts.\n"
	exit
fi
# Manual Usage
while getopts ac:e:f:ho: option
do
        case "\${option}"
        in
                a) ALL="TRUE";;
                c) CONTAINER="\${OPTARG}";;
                e) EXT="\${OPTARG}";;
                f) FILE="\$OPTARG";;
				h) HELP="TRUE";;
				o) NAME="\${OPTARG}";;
        esac
done

# -h 
if [ "\${HELP}" == "TRUE" ]; then
	echo -e "SMACK Upload\n\nUsage:\n\t\t-a\tUpload All Files in Directory\n\t\t-e\tUpload all Files with extension\n\t\t-f\tUpload file\n\t\t-o\tObject Name to be saved as\n\t\t-h\tDisplay this Help Message\n"
	exit
fi

# -a Set
if [ "\${ALL}" == "TRUE" ]; then
	# Loop Through all files in directory and upload
	exit
fi

# -e Set
if ! [ -z "\${EXT}" ]; then
	# Upload all files of extension passed
	exit
fi

# PROMPTING WIZARD
if [ -z "\${CONTAINER}" ]; then
	echo -e "\nCONTAINERS:"
	swift list
	read -p "Please Enter Container: " CONTAINER
fi
if [ -z "\${FILE}" ]; then
	read -p "Please Enter the File you wish to Upload: " FILE
fi
if [ -z "\${NAME}" ]; then
	read -p "Please Enter a name for the object: " NAME
fi
echo -e "\nUploading \${FILE} into container \${CONTAINER}...\n"
swift upload --object-name "\${NAME}" $CONTAINER "\${FILE}"
echo -e "\nUploading Object \${NAME} Complete.\n" 
EOF
# Log Reporting
if [ -e "$SMACK_DIR_BIN/smack-upload" ]; then
	echo -e "\nSWIFT UPLOAD: COMPLETE" >> $SMACK_INSTALL_LOG
else
	echo -e "\nSWIFT UPLOAD: ERROR" >> $SMACK_INSTALL_LOG
fi

# DOWNLOAD FILE FROM CONTAINER COMMAND
#-----------------------------------
cat << EOF > $SMACK_DIR_BIN/smack-download
#!/bin/bash
# Display Message
figlet -c SMACK Energy Forecasting
figlet -cf digital Object Storage Download Wizard
# Download from Swift Here
# Check for Login
if [ -z "\${OS_USERNAME}" ] || [ -z "\${OS_PASSWORD}" ]; then
	echo -e "\nPlease Login First. Use 'smack-login' and follow the prompts.\n"
	return
fi
# Manual Usage
while getopts ac:f:ho: option
do
        case "\${option}"
        in
                a) ALL="TRUE";;
                c) CONTAINER="\${OPTARG}";;
                f) FILE="\${OPTARG}";;
				h) HELP="TRUE";;
				o) OBJECT="\${OPTARG}";;
        esac
done

# -h 
if [ "\${HELP}" == "TRUE" ]; then
	echo -e "SMACK Download\n\nUsage:\n\t\t-a\tDownload All Files in Container\n\t\t-f\tDownload file Name\n\t\t-o\tObject Name to be Downloaded\n\t\t-h\tDisplay this Help Message\n"
	exit
fi

# -a Set
if [ "\${ALL}" == "TRUE" ]; then
	# Loop Through all files in Container and Download
	exit
fi

# PROMPTING WIZARD
if [ -z "\${CONTAINER}" ]; then
	echo -e "\nCONTAINERS:"
	swift list
	read -p "Which Container would you like to list: " CONTAINER
fi

if [ -z "\${OBJECT}" ]; then
	echo -e "\nCONTAINER: \${CONTAINER}"
	swift list "\${CONTAINER}" | more
	read -p "What Object would you like to download: " OBJECT
fi

echo -e "Downloading \${OBJECT} from \${CONTAINER}..."
swift download "\${CONTAINER}" "\${OBJECT}"
echo -e "Downloading \${OBJECT} Complete."
EOF
# Log Reporting
if [ -e "$SMACK_DIR_BIN/smack-download" ]; then
	echo -e "\nSWIFT DOWNLOAD: COMPLETE" >> $SMACK_INSTALL_LOG
else
	echo -e "\nSWIFT DOWNLOAD: ERROR" >> $SMACK_INSTALL_LOG
fi

# LIST CONTAINERS FROM OBJECT STORAGE COMMAND
#-----------------------------------
cat << EOF > $SMACK_DIR_BIN/smack-lsdb
#!/bin/bash
# Display Message
figlet -c SMACK Energy Forecasting
figlet -cf digital Object Storage Listing Wizard
# Download from Swift Here
# Check for Login
if [ -z "\${OS_USERNAME}" ] || [ -z "\${OS_PASSWORD}" ]; then
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
if [ "\${HELP}" == "TRUE" ]; then
	echo -e "\nSMACK Object Storage Listing\n\nUsage\n\t\t-l\tList Root Container\n\t\t-h\tList This Help Message\n\t\t-s\tList Container Statistics\n\t\t-c\tContainer to List\n\t\t-o\tObject to List Statistics\n"
	exit
fi

# -l 
if [ "\${ROOT}" == "TRUE" ]; then
	swift list
	exit
fi

# Prompting Wizard
if [ -z "\${CONTAINER}" ]; then
	echo -e "\nCONTAINERS:"
	swift list
	read -p "Which Container (type quit to exit): " CONTAINER
else
	swift list "\${CONTAINER}"
	exit
fi

# -s
if [ "\${STAT}" == "TRUE" ]; then
	swift stat "\${CONTAINER}"
	exit
fi
# -o
if [ -n "\${OBJECT}" ]; then
	swift stat "\${CONTAINER}" "\${OBJECT}"
	exit
fi

# Prompting Loop
while [ "\${CONTAINER}" != "quit" ]; do
	swift list "\${CONTAINER}"
	read -p "Which Container (Leave empty to quit): " CONTAINER
done
EOF
# Log Reporting
if [ -e "$SMACK_DIR_BIN/smack-lsdb" ]; then
	echo -e "\nSWIFT LIST CONTAINER: COMPLETE" >> $SMACK_INSTALL_LOG
else
	echo -e "\nSWIFT LIST CONTAINER: ERROR" >> $SMACK_INSTALL_LOG
fi

# MAKE CONTAINERS FROM OBJECT STORAGE COMMAND
#-----------------------------------
cat << EOF > $SMACK_DIR_BIN/smack-mkdb
#!/bin/bash
# Display Message
figlet -c SMACK Energy Forecasting
figlet -cf digital Container Creation Wizard
# Download from Swift Here
# Check for Login
if [ -z "\${OS_USERNAME}" ] || [ -z "\${OS_PASSWORD}" ]; then
	echo -e "\nPlease Login First. Use 'smack-login' and follow the prompts.\n"
	exit
fi

# Manual Usage
while getopts c:h option
do
        case "\${option}"
        in
                c) CONTAINER=\${OPTARG};;
                h) HELP="TRUE";;
        esac
done

# -h
if [ "\${HELP}" == "TRUE" ]; then
        echo -e "\nSMACK Object Storage Container Creation\n\nUsage\n\t\t-h\tList This Help Message\n\t\t-c\tContainer to List\n"
        exit
fi

# -c
if [ -z "\${CONTAINER}" ]; then
        echo -e "\nWelcome to the Container Creation Wizard.\n\tTo create a container please follow the instructions.\n\nCurrent Containers:\n"
        swift list 2> /dev/null
        read -p "Enter name of container you wish to create: " CONTAINER
        swift post "\${CONTAINER}" 2> /dev/null
        echo -e "\nContainer Successfully Created"
else
        swift post "\${CONTAINER}" 2> /dev/null
        exit
fi
EOF
# Log Reporting
if [ -e "$SMACK_DIR_BIN/smack-mkdb" ]; then
	echo -e "\nSWIFT MAKE CONTAINER: COMPLETE" >> $SMACK_INSTALL_LOG
else
	echo -e "\nSWIFT MAKE CONTAINER: ERROR" >> $SMACK_INSTALL_LOG
fi

# ADD SKELETON SETUP FILE ONTO SERVER
#-----------------------------------
cat << EOF > $SMACK_DIR/skel/setup-node.sh
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


# ADD ADDITIONAL COMMANDS BELOW
#-----------------------------------
#
#
#
#
#

# INSTALL ADDITIONAL SOFTWARE BELOW
#-----------------------------------
#
#
#
#
#

# ENABLE ALL NECESSARY DAEMONS 
#-----------------------------------
#
#
#
#


# SET PERMISSIONS FOR COMMANDS
#-----------------------------------
# SMACK Directory
chmod 777 $SMACK_DIR_BIN
chmod 700 $SMACK_DIR/skel
chmod 700 $SMACK_DIR_LOG/*
chmod 777 $SMACK_DIR_TMP
chmod +x $SMACK_DIR_BIN/*
# CRON Directory
chmod 755 $CRON_PATH/bin
chmod 700 $CRON_PATH/log/*
chmod +x $CRON_PATH/bin/*
# Log Reporting
echo -e "\nPERMISSIONS: COMPLETE" >> $SMACK_INSTALL_LOG
	

# SET FILE FOR COMPLETION
#-----------------------------------
touch $SMACK_LOAD
echo -e "\n### INSTALL: COMPLETE ###" >> $SMACK_INSTALL_LOG

fi
# FINISHED