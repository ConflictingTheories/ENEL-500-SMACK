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
yum -y install nano python-devel python-pip links nodejs npm
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
# Log Reporting
echo -e "\nCRON SCHEDULING: COMPLETE" >> $SMACK_INSTALL_LOG
# POPULATE ANY NEEDED FILES
#-----------------------------------
# Generate Environment Script for SMACK Project
cat << EOF >> $SMACK_DIR/smack-env.sh
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
# POPULATE SHINY SERVER FILES FOR DEPLOYMENT
#-----------------------------------
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
# Log Reporting
echo -e "\nSHINY DEMO: COMPLETE" >> $SMACK_INSTALL_LOG
# INSTALL API DEMO - FOR TASK 5 PRESENTATION
#---------------------------------------
# INSTALL API SERVER AND CONFIGURE
#------------------------------------
# Make Server Directory
#
# Generate Package.json file
#
# cat << EOF > Package.json
#
# Make Demo Directory
mkdir $API_SRV/api_demo
cd $API_SRV/api_demo
# Install Express and Request Libraries
npm install express --save
npm install request --save
# Generate API Backend
# Populate Node.Js App
cat << EOF > $API_SRV/api_demo/app.js
// Use for HTTP requests (Outgoing)
var request = require('request');
// Use for API calls (Incoming)
var express = require('express');
// Frontend Controller Object
var app = express();
// GET Request API Call - Homepage - example - load googles homepage
app.get('/', function (req, res) {
	// Request Google and Store in Body
	request('${STORAGE_URL}', function(error, response, body) {
    	// If no errors post to terminal and client’s browser
		if (!error && response.statusCode == 200) {
			// To Terminal
			//console.log(body);
			// To Client
			res.send(body);
		}
 	});

});
// GET Request API Call - /yo - example - replies
app.get('/yo', function (req, res) {
	// Send Response  
	res.send('YO DAWG!');
});
// GET Request API Call - /nwp – basic returns message
app.get('/nwp', function(req, res) {
	// Send Response to Client’s Browser
	res.send('<html><body><h1>SMACK Energy Forecasting</h1><br /><br />NWP Data API Request Framework<br/><br/>Please Read below for options<br/><br/>COMING SOON</body></html>');
});
// Setup API Listener on port 3000 and wait for requests
app.listen(3000, function(){
	console.log('Example app listening on port 3000!');
});
EOF
# Launch API Server
cat << EOF > $API_SRV/api_demo/api.js
// # SMACK API - Demonstration
//
//      # Designed for Task #5
//
//      # Basic API Call Demonstration using node.js
//
//      # Available Commands:
//      # List statistics about nwp database (*not implemented)
//      #       GET /nwp?list
//      #
//      # List top 100 entries from database (*not implemented)
//      #       GET /nwp?head=100
//      #
//
//
// Use for HTTP requests (Outgoing)
var request = require('request');
// Use for API calls (Incoming)
var express = require('express');

// Frontend Controller Object
var app = express();
// GET Request API Call - Homepage - example - load google's homepage
app.get('/', function (req, res) {
// Send Response to Client’s Browser
	res.send('<html><body>\
		<h1>SMACK Energy Forecasting</h1>\
		<br /><br />SMACK Energy Forecasting API Portal<br/><br/>\
		Please Read below for options<br/><br/>\
		<h2>API Endpoints:</h2><br/>\
		<p>\
		<b>/nwp</b>:<br/><ul>\
		<li>/nwp/list?date=YYYYMMDD</li>\
		<li>/nwp/listall</li>\
		<li>MORE COMING SOON</li>\
		<ul><p>\
		</body></html>');
});

// GET Request API Call - /nwp – basic returns message
app.get('/nwp', function(req, res) {
	// Send Response to Client’s Browser
	res.send('Please Use one of the Available API Calls - Thank you');
});

app.get('/nwp/list', function(req, res) {
	if(req.query.date != null) {
		var date = req.query.date;
		console.log(date);
		request('https://swift-yyc.cloud.cybera.ca:8080/v1/AUTH_4b6be558d44e4dba8fb6e4aa49934c0b/nwp', function (err, resp, bdy){
			var objs = bdy.split("\n").map(function (obj){
				if (obj.indexOf(date) != -1){
					return obj;
				}
			});
			objs.slice(0, objs.length);
			res.send(JSON.stringify(objs));
		});
	}
	else {
		res.send("Please Use the following format: /nwp/list?date=YYYYMMDD");
	}
});

// Setup API Listener on port 3000 and wait for requests
app.listen(3000, function(){
	console.log('Example app listening on port 3000!');
});
EOF
node "${API_SRV}/api_demo/api.js" &
# npm start &
# Log Reporting
echo -e "\nAPI DEMO: COMPLETE" >> $SMACK_INSTALL_LOG
# ADD WELCOME MESSAGE TO INSTANCE (** Move to Cron @reboot)
#-----------------------------------
cat << EOT >> /etc/bashrc
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
# Help
if ! [ "\${HELP}" == "TRUE" ]; then
	echo -e "\nSMACK LOGIN UTILTIY\n\tUsage:\n\t\t-n\tInstance Name\n\t\t-f\t\Flavour\n\t\t-k\tAccess Key\n\t\t-x\tDeployment Script\n\t\t-d\t\Use Default Values\n\t\t-h\tHelp Message\n"
fi
# use Wizard or Defaults
if ! [ "\${DEFAULT}" == "TRUE"]; then
	echo "For Defaults Just Press Enter at Prompt."
	if [ -z "\${NAME}" ]; then
		echo -e "\tName (*default):"
		read NAME
	fi
	if [ -z "\${FLAVOUR}" ]; then
		echo -e "\tFlavour (*m1.tiny):"
		read FLAVOUR
	fi
	if [ -z "\${KEY}" ]; then
		echo -e "\tKey (*DevAccess):"
		read KEY
	fi
	if [ -z "\${SCRIPT}" ]; then
		echo -e "\tSetup Script (*setup-node.sh):"
		read SCRIPT
	fi
fi
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
if ! [ -z "\${IMAGE}" ]; then
	INT_IMAGE="\${IMAGE}"
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
if [ "\${HELP}" == "TRUE" ]; then
	echo -e "SMACK Login:\n\n\tUsage:\n\t\t-u\t:\tUsername\n\t\t-x\t:\tPassword\n\t\t-p\t:\tProject Name\n\t\t-h\t:\tHelp Message\n"
fi
# Login and Set Variables
if [ -z "\${UNAME}" ]; then
	read -p "Please enter your SMACK Openstack username: " UNAME
fi
if [ -z "\${PASSWD}" ]; then
	stty -echo
	read -p "Please enter your SMACK Openstack password: " PASSWD
	stty echo
	echo -e "\n"
fi
if [ -z "\${PROJECT}" ]; then
	read -p "Please enter your Project (ie. blank for personal or enter 'SMACK'): " PROJECT
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
if [ -e "${SMACK_DIR_BIN}/smack-logout" ]; then
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
if [ -e "${SMACK_DIR_BIN}/smack-suspend" ]; then
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
if [ -e "${SMACK_DIR_BIN}/smack-terminate" ]; then
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
if [ -e "${SMACK_DIR_BIN}/smack-setip" ]; then
	echo -e "\nIP CONFIG: COMPLETE" >> $SMACK_INSTALL_LOG
else
	echo -e "\nIP CONFIG: ERROR" >> $SMACK_INSTALL_LOG
fi
# UPLOAD FILE TO CONTAINER COMMAND
#-----------------------------------
cat << EOF > $SMACK_DIR_BIN/smack-upload
#!/bin/bash
# SMACK -  Make Upload Utility
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
	echo -e "Function Not Implemented Yet"
	exit
fi
# -e Set
if ! [ -z "\${EXT}" ]; then
	# Upload all files of extension passed
	echo -e "Function Not Implemented Yet"
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
# TYPE I
swift upload --object-name "\${NAME}" "\${CONTAINER}" "\${FILE}" 2> /dev/null
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
# TYPE I
swift download "\${CONTAINER}" "\${OBJECT}"
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
cat << EOF > ${SMACK_DIR_BIN}/smack-lsdb
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
if [ -e "${SMACK_DIR_BIN}/smack-lsdb" ]; then
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
                c) CONTAINER="\${OPTARG}";;
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
chmod 777 ${SMACK_DIR_BIN}
chmod 777 ${SMACK_DIR}/skel
chmod 777 ${SMACK_DIR_LOG}
chmod 777 ${SMACK_DIR_TMP}
chmod +x ${SMACK_DIR_BIN}/*
# CRON Directory
chmod 777 ${CRON_PATH}
chmod 777 ${CRON_PATH}/bin
chmod 777 ${CRON_PATH}/log
chmod +x ${CRON_PATH}/bin/*
# Log Reporting
echo -e "\nPERMISSIONS: COMPLETE" >> ${SMACK_INSTALL_LOG}
# SET FILE FOR COMPLETION
#-----------------------------------
touch $SMACK_LOAD
echo -e "\n### INSTALL: COMPLETE ###" >> ${SMACK_INSTALL_LOG}
fi
# FINISHED