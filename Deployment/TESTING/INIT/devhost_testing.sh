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
# TESTING RELEASE NOTES (As of January 17, 2016):
#
#	- Added skeletons for new toolchain files that will
#	be developed using the previously described mention
#	method. If a tool doesn't work - please checking the
#	testing version for implementation. Chances are that
# 	the tool hasn't been stably released yet. 
#
#	- Has basic Web frontend from TASK #4 Demo
#
#	- Has Basic Cron Job, but jobs are skeletons
#
#	- Has Node Instance Control, but not DB yet
#
#	- Has a Welcome Message
#
#	- Has Java 7/8 and Python 2.7/3.5
#
#	- Has Openstack Client Software
#
#	- Has R and RShiny installed
#
#	
#--------------------------------------------------------

# DIRECTORY AND FILE INFORMATION
#-----------------------------------
# SMACK
SMACK_DIR=/usr/local/smack
SMACK_DIR_BIN=/usr/local/smack/bin
SMACK_DIR_LOG=/usr/local/smack/log
SMACK_DIR_SKEL=/usr/local/smack/skel
SMACK_DIR_TMP=/usr/local/smack/tmp
SMACK_LOAD=$SMACK_DIR_LOG/smack_loaded
SMACK_INSTALL_LOG=$SMACK_DIR_LOG/install_log
# Shiny
SHINY_SRV=/srv/shiny-server
# Log Reporting
echo -e "\n### INSTALL BEGINNING ###" >> $SMACK_INSTALL_LOG


# GENERATE DIRECTORY STORAGE
#-----------------------------------
mkdir $SMACK_DIR
mkdir $SMACK_DIR_BIN
mkdir $SMACK_DIR_LOG
mkdir $SMACK_DIR_TMP
# Log Reporting
echo -e "\nDIRECTORIES: COMPLETE" >> $SMACK_INSTALL_LOG


# UPDATE PACKAGES AND TOOLCHAIN
#-----------------------------------
#yum -y update
yum -y install gcc-c++ wget curl curl-devel figlet python
yum -y install make binutils git nmap man maven libffi-devel
yum -y install nano python-devel python-pip links
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
# Adjust for warnings
cat /usr/local/lib/python2.7/site-packages/keystoneclient/service_catalog.py | sed -e 's/import warnings/import warnings\nwarnings.filterwarning("ignore")/' > /usr/local/lib/python2.7/site-packages/keystoneclient/service_catalog.py
# Log Reporting
echo -e "\nOPENSTACK CLIENTS: COMPLETE" >> $SMACK_INSTALL_LOG

# INSTALL PYTHON LIBRARIES
#-----------------------------------
# numpy
/usr/local/bin/pip2.7 install numpy
/usr/local/bin/pip3.5 install numpy
# scipy
/usr/local/bin/pip2.7 install scipy
/usr/local/bin/pip3.5 install scipy



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
cat /etc/shiny-server/shiny-server.conf.bak | sed 's:3838:80:g' > /etc/shiny-server/shiny-server.conf
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
CRON_PATH=$SMACK_DIR/cron
# Make CRON directory
mkdir $CRON_PATH
mkdir $CRON_PATH/bin
mkdir $CRON_PATH/log
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
CRON_PATH=$CRON_PATH
# Retrieve and Store Temporarily (starting 00:05 - every 06:00)
5 */6 * * * \$CRON_PATH/bin/ret_nwp.sh
# Check Retrieved Files and Fill if necessary
25 */6 * * * \$CRON_PATH/bin/chk_nwp.sh
# Store files to Swift Storage
45 */6 * * * \$CRON_PATH/bin/str_nwp.sh
# Clear Temp Files
0 */6 * * * \$CRON_PATH/bin/clr_nwp.sh
EOF

# Generate Related Cron Files
cat << EOF > $CRON_PATH/bin/ret_nwp.sh
#!/bin/bash
#--------------------------------------------------------
# 				SMACK ENERGY FORECASTING 
#--------------------------------------------------------
#			-  Data Retrieval Script - NWP -
#--------------------------------------------------------
# Temporary Working Directory
TMP_DIR=$SMACK_DIR_TMP/nwp-load
# Check for Existence
if ![ -e \$TMP_DIR ]; then
	mkdir \$TMP_DIR
fi 
# Move into Tmp Directory
cd \$TMP_DIR
# Begin Downloading Files from NWP (for Recent Time)
#
# For all needed variables, download file for time
#	* make list of variables
#	* iterate through list
#	* use current time and known time stamp
#	* download and store into tmp directory
#
T = time
echo -e "\nret_nwp.sh - run @ \$T\n" >> $CRON_PATH/log/nwp-load.log
EOF

# Generate Related Cron Files
cat << EOF > $CRON_PATH/bin/chk_nwp.sh
#!/bin/bash
#--------------------------------------------------------
# 				SMACK ENERGY FORECASTING 
#--------------------------------------------------------
#			-  Data Checking Script - NWP -
#--------------------------------------------------------
# Temporary Working Directory
TMP_DIR=$SMACK_DIR_TMP/nwp-load
# Check for Existence
if ![ -e \$TMP_DIR ]; then
	mkdir \$TMP_DIR
fi 
# Move into Tmp Directory
cd \$TMP_DIR
# Begin Downloading Missed Files from NWP (For Recent Time)
#
# For all Variables that are missing download appropriate time
#	* Check against known variables
#	* Check off any missing
#	* Download missing variables
#
T = time
echo -e "\chk_nwp.sh - run @ \$T\n" >> $CRON_PATH/log/nwp-load.log
EOF

# Generate Related Cron Files
cat << EOF > $CRON_PATH/bin/str_nwp.sh
#!/bin/bash
#--------------------------------------------------------
# 				SMACK ENERGY FORECASTING 
#--------------------------------------------------------
#			-  Data Storage Script - NWP -
#--------------------------------------------------------
# Temporary Working Directory
TMP_DIR=$SMACK_DIR_TMP/nwp-load
# Check for Existence
if ![ -e \$TMP_DIR ]; then
	mkdir \$TMP_DIR
fi 
# Move into Tmp Directory
cd \$TMP_DIR
# Begin Uploading Files from to Swift Storage (for recent time)
#
# For each file within the directory - upload to swift
#	* Check against files in directory
#	* Make sure proper time
#	* Upload to swift object storage
#
T = time
echo -e "\nstr_nwp.sh - run @ \$T\n" >> $CRON_PATH/log/nwp-load.log
EOF

# Generate Related Cron Files
cat << EOF > $CRON_PATH/bin/clr_nwp.sh
#!/bin/bash
#--------------------------------------------------------
# 				SMACK ENERGY FORECASTING 
#--------------------------------------------------------
#			-  Data Clearing Script - NWP -
#--------------------------------------------------------
# Temporary Working Directory
TMP_DIR=$SMACK_DIR_TMP/nwp-load
# Check for Existence
if ![ -e \$TMP_DIR ]; then
	mkdir \$TMP_DIR
fi 
# Move into Tmp Directory
cd \$TMP_DIR
# Clear Tmp Directory (for recent time files)
#	* Check against time
#	* Remove all Grib2 Files
#
rm -rf *.grib2
T = time
echo -e "\nclr_nwp.sh - run @ \$T\n" >> $CRON_PATH/log/nwp-load.log
EOF

# Initialize all Schedules for Deployment
crontab $CRON_PATH/nwp-load.cron
# Log Reporting
echo -e "\nCRON SCHEDULING: COMPLETE" >> $SMACK_INSTALL_LOG


# INSTALL ADDITIONAL SOFTWARE BELOW
#-----------------------------------
#
#
#

# ENABLE ALL NECESSARY DAEMONS 
#-----------------------------------
#
#

# POPULATE ANY NEEDED FILES
#-----------------------------------
#
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
# Add Executable Path
echo -e "\nAdding Path: $SMACK_DIR_BIN\n"
export PATH=\$PATH:$SMACK_DIR_BIN
export PATH=\$PATH:$JAVA_HOME/bin
export PATH=\$PATH:/usr/local/bin
export JAVA_HOME=$JAVA_HOME
export JRE_HOME=$JRE_HOME

# SMACK Command Aliases
alias smack-login="source $SMACK_DIR_BIN/smack-login"
alias smack-logout="source $SMACK_DIR_BIN/smack-logout"
# Python Aliases
alias pip27=/usr/local/bin/pip2.7
alias python27=/usr/local/bin/python2.7
# Display Title Screen for SMACK
figlet -c SMACK Energy Forecasting
echo -e "\t\tSMACK Energy Forecasting - Making an Impact\n"
echo -e "Welcome to the Development Machine:\n"
echo -e "\n#TIP---For a list of commands type smack and press tab.\n"
EOT
# Log Reporting
echo -e "\nWELCOME: COMPLETE" >> $SMACK_INSTALL_LOG


# LIST NODES COMMAND (smack-lsnode)
#-----------------------------------
cat << EOF >> $SMACK_DIR_BIN/smack-lsnode
#!/bin/bash
# Output Welcome Screen
if [ -z "\$OS_USERNAME" ] || [ -z "\$OS_PASSWORD" ]; then
	echo -e "Error: You are not logged in.\n\tPlease run 'smack-login' and then try again."
	exit 1
else
	figlet -c SMACK Energy Forecasting
fi
# List Nodes in Cloud
figlet -cf digital NODES LISTING
nova --os-user-name \$OS_USERNAME \\
 	    --os-project-name \$OS_PROJECT_NAME \\
      	--os-password \$OS_PASSWORD \\
      	--os-region-name \$OS_REGION \\
      	--os-auth-url \$OS_AUTH_URL \\
      	--os-auth-url \$OS_AUTH_URL \\
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
if [ -z "\$OS_USERNAME" ] || [ -z "\$OS_PASSWORD" ]; then
	echo -e "Error: You are not logged in. \n\tPlease run 'smack-login' and then try again."
	exit 1
else
	figlet -c SMACK Energy Forecasting
fi
# Default Instance Information
INT_NAME=default
INT_FLAVOR=m1.tiny
INT_IMAGE=907f21d1-305c-4dee-a64a-43fc1a3701a4
INT_OS=linux
INT_KEY=DevAccess
INT_SECURITY=Default
INT_SCRIPT=setup-node.sh
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
if ! [ -z "\$NAME" ]; then
  	    INT_NAME=\$NAME
fi
if ! [ -z "\$FLAVOUR" ]; then
	INT_FLAVOR=\$FLAVOUR
fi
if ! [ -z "\$KEY" ]; then
	INT_KEY=\$KEY
fi
if ! [ -z "\$SCRIPT" ]; then
	INT_SCRIPT=\$SCRIPT
fi
# Display instance information
echo -e "Launching VM Instance: \$INT_NAME"
echo -e "\tOS Type: \$INT_OS\n\tFlavour: \$INT_FLAVOR"
echo -ne "\tImage: \$(nova --os-user-name \$OS_USERNAME \\
      	--os-project-name \$OS_PROJECT_NAME \\
      	--os-password \$OS_PASSWORD \\
      	--os-region-name \$OS_REGION \\
      	--os-auth-url \$OS_AUTH_URL \\
  		image-list | grep \$INT_IMAGE | sed 's/ACTIVE//' | sed s/\$INT_IMAGE// | sed 's/|//g')"
echo -e "\n\tSecurity Group: \$INT_SECURITY"
echo -e "\tKey: \$INT_KEY"
echo -e "\tLaunch Script: \$INT_SCRIPT"
echo -e "\t------------\n"
# Boot up new instance in cloud
nova --os-user-name \$OS_USERNAME \\
    --os-project-name \$OS_PROJECT_NAME \\
    --os-password \$OS_PASSWORD \\
    --os-region-name \$OS_REGION \\
    --os-auth-url \$OS_AUTH_URL \\
	boot \\
	--flavor \$INT_FLAVOR \\
	--image \$INT_IMAGE \\
	--key-name \$INT_KEY \\
	--user-data \$INT_SCRIPT \\
	--security-group \$INT_SECURITY \\
	\$INT_NAME
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
read -p "Please enter your Project (ie. blank for personal or enter 'SMACK'): " PROJECT
echo -e "\n"
# URLs for API Access (may need to change)
export KEYSTONE_URL="https://keystone-yyc.cloud.cybera.ca:5000/v2.0"
export NOVA_URL="https://nova-yyc.cloud.cybera.ca:8774/v2/2b86ecd5b18f4fafb1d55adb79072def"
export CINDER_URL="https://cinder-yyc.cloud.cybera.ca:8776/v1/2b86ecd5b18f4fafb1d55adb79072def"
export CINDER2_URL="https://cinder-yyc.cloud.cybera.ca:8776/v2/2b86ecd5b18f4fafb1d55adb79072def"
export GLANCE_URL="http://glance-yyc.cloud.cybera.ca:9292"
export EC2_URL="https://nova-yyc.cloud.cybera.ca:8773/services/Cloud"
export SWIFT_URL="https://swift-yyc.cloud.cybera.ca:8080/v1/AUTH_2b86ecd5b18f4fafb1d55adb79072def"
# Login Info
export OS_USERNAME=\$UNAME
export OS_PASSWORD=\$PASSWD
if [ -z "\$PROJECT" ]; then
	export OS_PROJECT_NAME=\$UNAME
else
	export OS_PROJECT_NAME=\$PROJECT
fi
export OS_AUTH_URL=\$KEYSTONE_URL
export OS_REGION=Calgary
export OS_ZONE=Nova
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
# Upload Files to Swift Here
#
#	......
#
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
#
#	......
#
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
figlet -cf digital Object Storage Listing
# List Info from Swift Here
#
#	......
#
EOF
# Log Reporting
if [ -e "$SMACK_DIR_BIN/smack-lsdb" ]; then
	echo -e "\nSWIFT LIST CONTAINER: COMPLETE" >> $SMACK_INSTALL_LOG
else
	echo -e "\nSWIFT LIST CONTAINER: ERROR" >> $SMACK_INSTALL_LOG
fi

# ADD SKELETON SETUP FILE ONTO SERVER
#-----------------------------------
mkdir $SMACK_DIR_SKEL
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


# SET PERMISSIONS FOR COMMANDS
#-----------------------------------
# SMACK Directory
chmod 755 $SMACK_DIR_BIN
chmod 700 $SMACK_DIR/skel
chmod 777 $SMACK_DIR_TMP
chmod 600 $SMACK_DIR_LOG/*
chmod +x $SMACK_DIR_BIN/*
# CRON Directory
chmod 755 $CRON_PATH/bin
chmod +x $CRON_PATH/bin/*
chmod 600 $CRON_PATH/log/*
# Log Reporting
echo -e "\nPERMISSIONS: COMPLETE" >> $SMACK_INSTALL_LOG
	

# SET FILE FOR COMPLETION
#-----------------------------------
touch $SMACK_LOAD
echo -e "\n### INSTALL: COMPLETE ###" >> $SMACK_INSTALL_LOG

fi
# FINISHED