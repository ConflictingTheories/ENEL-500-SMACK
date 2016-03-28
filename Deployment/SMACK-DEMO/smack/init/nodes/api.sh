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

## SMACK PROJECT DEFINITIONS FILE
# -- SMACK DEFINITIONS
#		Main Directory
export SMACK_MAIN="/usr/local/smack"
#		Documentation
export SMACK_DOC="${SMACK_MAIN}/doc"
#		Toolchain Binaries
export SMACK_BIN="${SMACK_MAIN}/bin"
#		Configuration Files
export SMACK_CONF="${SMACK_MAIN}/conf"
#		Initilization Files
export SMACK_INIT="${SMACK_MAIN}/init"
#		Scheduling Files
export SMACK_SCHD="${SMACK_MAIN}/schd"
#		Skeleton Files
export SMACK_SKEL="${SMACK_MAIN}/skel"
#		Temporary Storage
export SMACK_TMP="${SMACK_MAIN}/tmp"
#		Log Files
export SMACK_LOG="${SMACK_MAIN}/log"
# 		External Tools
export SMACK_EXT="${SMACK_MAIN}/ext"
#		Smack Monitoring Files
export SMACK_MON="${SMACK_MAIN}/mon"
#		SMACK User Custom Files
export SMACK_HOME="/home/centos/smack"
#		Completion Flag
export SMACK_LOAD="${SMACK_LOG}/loaded"

# -- OPENSTACK DEFINITIONS
#		Username
export OS_USERNAME="confidential.inc@gmail.com"
#		Password
export OS_PASSWORD="Hacker0013"
#		Project name
export OS_PROJECT_NAME="SMACK"
#		Tenant Name
export OS_TENANT_NAME="SMACK"
#		Keystone URL
export OS_AUTH_URL="https://keystone-yyc.cloud.cybera.ca:5000/v2.0"
#		Zone
export OS_ZONE="Nova"
#		Region
export OS_REGION="Calgary"
#		Swift URl
export OS_SWIFT_URL="https://swift-yyc.cloud.cybera.ca:8080/v1"
#		Account ID
export OS_ACCT_ID="AUTH_4b6be558d44e4dba8fb6e4aa49934c0b"

# -- API SPECIFIC DEFINITIONS
#		Node JS Server Root
export API_SRV_ROOT="${SMACK_EXT}/api"
export API_SRV="${API_SRV_ROOT}/srv"
# -- GENERAL DEFINITIONS
#		Temporary Log File
export TMP_LOG="/tmp/tmp_log"
#		Log Report
echo -e "\n----- INSTALLATION BEGINNING -----" >> ${TMP_LOG}
echo -e "\n### DEFINITIONS: GENERATED @ $(date -u)" >> ${TMP_LOG}

### GENERATE DIRECTORIES STRUCTURE
# -- SMACK Directories
mkdir ${SMACK_MAIN}
mkdir ${SMACK_BIN}
mkdir ${SMACK_DOC}
mkdir ${SMACK_EXT}
mkdir ${SMACK_TMP}
mkdir ${SMACK_LOG}
mkdir ${SMACK_SCHD}
mkdir ${SMACK_SKEL}
mkdir ${SMACK_MON}
mkdir ${SMACK_HOME}
# -- Speficic Directories
mkdir ${API_SRV_ROOT}
mkdir ${API_SRV}
#		Log Report
echo -e "\n### FILE STRUCTURE: GENERATED @ $(date -u)" >> ${TMP_LOG}


### PACKAGES AND DEPENDENCIES
# -- GENERAL PACKAGES AND UPDATES
yum -y install gcc-c++ wget curl curl-devel figlet python wgrib2
yum -y install make binutils git nmap man maven libffi-devel at
yum -y install nano python-devel python-pip links nodejs npm
yum -y groupinstall "Development Tools"
yum -y install zlib-devel bzip2-devel openssl-devel libxml2-devel
yum -y install ncurses-devel sqlite-devel readline-devel zlibrary-devel
yum -y install tk-devel gdbm-devel db4-devel libpcap-devel xz-devel
#		Log Report
echo -e "\n### DEPENDENCIES AND PACKAGES: GENERATED @ $(date -u)" >> ${TMP_LOG}

# -- LIBRARIES AND TOOLS
if ! [[ -e $SMACK_LOAD ]]; then
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
# INSTALL OPENSTACK CLIENT SOFTWARE
#-----------------------------------
/usr/local/bin/pip2.7 install requests['security']
/usr/local/bin/pip2.7 install python-openstackclient
/usr/local/bin/pip2.7 install python-swiftclient
/usr/local/bin/pip2.7 install --upgrade setuptools
# OPENSTACK TOOLS FOR PYTHON 3.5
#-------------------------------------
/usr/local/bin/pip3.5 install requests['security']
/usr/local/bin/pip3.5 install python-openstackclient
/usr/local/bin/pip3.5 install python-swiftclient
/usr/local/bin/pip3.5 install --upgrade setuptools
#		Log Report
echo -e "\n### OPENSTACK TOOLS: GENERATED @ $(date -u)" >> ${TMP_LOG}

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
# cleanup
cd /
rm -rf /tmp/java8
# set Variables
ln -S /usr/java/jdk1.8.0_40 /usr/java/latest
# Setup Variables
export JAVA_HOME=/usr/java/latest
export JRE_HOME=$JAVA_HOME/jre
#		Log Report
echo -e "\n### JAVA: GENERATED @ $(date -u)" >> ${TMP_LOG}

### API SERVER INSTALLATION
# -- SERVER CREATION
# Make Demo Directory
cd ${API_SRV}
# Install Node.JS Libraries
npm install express --save
npm install request --save
# -- PACKAGE FILE GENERATION
cat<<EOF > ${API_SRV}/Package.json
{}
EOF
# -- API SERVER CODE
cat<<EOF > ${API_SRV}/server.js
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
// Modules
var util = require('util');
var request = require('request');
var fs = require('fs');
var express = require('express');
// Frontend Controller Object
var app = express();
// URL
var swift_url = "https://swift-yyc.cloud.cybera.ca:8080/v1/AUTH_4b6be558d44e4dba8fb6e4aa49934c0b";
// GET Request API Call - Homepage
app.get('/', function (req, res) 
{
	// Send Response to Clients Browser
	res.send('<html><body><h1>SMACK Energy Forecasting</h1><br /><br />SMACK Energy Forecasting API Portal<br/><br/>Please Read below for options<br/><br/><h2>API Endpoints:</h2><br/><p><b>/nwp</b>:<br/><ul><li>/nwp?date=YYYYMMDD&rt=HH&fh=XX&var=VARNAME</li></ul><br/><b>Historical Power Data:</b><br/><ul><li><li>/hist?date=YYYYMMDD&hour=HH&min=&&</li><li>MORE COMING SOON</li><ul><p></body></html>');
});
// GET Request API Call - /nwp – basic returns message
app.get('/nwp', function(req, res) 
{
	    var rq = req.query;
        if ( rq.date != null && rq.rt != null && rq.fh != null && rq.var != null )
        {
                // Perform Query Analysis and Data Fetch
                if (rq.date == "" || rq.rt == "")
                {
                        res.send('Data transfer is limited. Please make appropriate calls.');
                }
                else
                {
                	// Extract Date
					var date = rq.date;
					var yyyy = date.substring(0,4);
					var mm = date.substring(4,6);
					var dd = date.substring(6,8);
					var dt = yyyy+'/'+mm+'/'+dd+'/'+rq.rt

					request({'url':swift_url+'/nwptxt?prefix='+dt}, function (err, resp, bdy)
					{
						var rt_objs = bdy.split("\n").map(function(obj)
						{
							// Single Variable Single Forecast
							if (rq.var != "" && rq.fh != "")
							{
								if( obj.search(dt+'/'+rq.fh+'/'+rq.var) != -1)
									return obj;
							}
							// Single Variable All Forecasts
							else if (rq.var != "" && rq.fh == "")
							{
								if( obj.search(rq.var) != -1)
									return obj;
							}
							// All Variables Single Forecast
							else if (rq.var == "" && rq.fh != "")
							{
								if (obj.search(dt+'/'+rq.fh) != -1)
									return obj;
							} 
						});

						rt_objs = rt_objs.filter(function(e){return e;});

						if( rt_objs.length > 0)
						{
							var cnt = 0;
							var accumulator = [];
							// Loop through and download files from swift
							for(fl in rt_objs)
							{	
								if ( rt_objs[fl] != undefined )
								{
									request({'url':swift_url+'/nwptxt/'+rt_objs[fl]}, function (err, rsp, bdy) 
									{
										if (bdy != undefined) {
											n_bdy = bdy.split("\n");
											dim = n_bdy[0].split(" ");
											new_bdy = n_bdy.slice(1);
											// FOR EDITING THE STRUCTURE OF THE OBJECT LISTING (FARMS)
											//for(f in new_bdy) 
											//{	
											//	Perform Changes Here
											//}
											data = { 'date': dt, 'var': rt_objs[fl].substring(14), 'size_i': dim[0], 'size_j': dim[1], 'data': new_bdy };
											accumulator.push(data);
											if(cnt == rt_objs.length-1) { res.send(accumulator); }
												cnt++;
										}
									});
								}
							}
						}
						else
						{
							res.send('{"error":"bad date"}');
						}
					});
                }
        }
        else
        {
                // Send Response to Client’s Browser
                res.send('Please Use one of the Available API Calls - For more help try /nwp/help');
        }
});
// Historical Data Range
app.get('/hist', function(req, res) {
	if(req.query.date != null) {
		var date = req.query.date;
		// Extract Date
		var yyyy = date.substring(0,4);
		var mm = date.substring(4,6);
		var dd = date.substring(6,8);
		if (req.query.hour != null && req.query.hour != ""){ if (req.query.min != null){ var rt = req.query.hour+""+req.query.min; }else{ var rt = req.query.hour; }} else { if(req.query.hour == "" && req.query.min != null) {res.send("Error: Please format requests like: /hist?date=YYYYMMDD?hour=HH?min=MM"); return;} else {var rt = req.query.hour;} }
		var dt = yyyy+"/"+mm+"/"+dd;
		// Request Files
		request({'url':swift_url+'/hist?limit=1440&prefix='+dt}, function (err, resp, bdy)
		{
			// Retrieve List of Files
			var objs = bdy.split("\n").map(function (obj)
			{;
				// Return only the single minute - RT - (HHMM)
				if (obj.search(dt+"/"+rt) != -1){
					return obj;
				}
			});
			// Remove Empty Listings
			objs = objs.filter(function(e){return e});
			// Ensure not empty
			if (objs.length > 0)
			{
				var cnt = 0;
				var accumulator = [];
				// Loop through and download files from swift
				for(fl in objs)
				{	
					if ( objs[fl] != undefined )
					{
						request({'url':swift_url+'/hist/'+objs[fl]}, function (err, rsp, bdy) 
						{
							if (bdy != undefined) {
								new_bdy = JSON.parse(bdy);
								// FOR EDITING THE STRUCTURE OF THE OBJECT LISTING (FARMS)
								//for(f in new_bdy) 
								//{	
								//	Perform Changes Here
								//}
								data = { 'date': dt, 'rt': rsp.req.path.substring(rsp.req.path.length-4,rsp.req.path.length), 'sites': new_bdy};
								accumulator.push(data);
								if(cnt == objs.length-1) { res.send(accumulator); }
								cnt++;
							}
						});
					}
				}
			}
			else
			{
				res.send(JSON.stringify({'error':'bad_date'}));
			}
		});
	}
	else {
		res.send("Please Use the following format: /hist?date=YYYYMMDD&hour=HH&min=MM");
	}
});
// Setup API Listener on port 3000 and wait for requests
app.listen(3000, function(){
	console.log('SMACK API is up on port 3000!');
});
EOF
node "${API_SRV}/server.js" &
# npm start &
#		Log Reporting
echo -e "\n### API SERVER: GENERATED @ $(date -u)" >> ${TMP_LOG}

### FILE GENERATION
# -- GENERATE SSH AUTHENTICATION 
#		DEVELOPER  ACCESS
cat <<EOF >> /home/centos/.ssh/authorized_keys
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCxKElPZ2bWfQeDo3zB1eMS4MyIfImUgEoGD8jnr/42zNtwHnmINel4Gr8dcPza/mjmz5YfZztpi81EtDxRkdrldVIaej9qa0XXmpuAqr0dw1chVLxwZ3mGk9CxipGAJ5wBKVsGGm0CqIlEy/7muOA1nLX5aycgEecTlHNZhM998kpyjnjlfvJkLa4feBiHiyWvnfhH0lgYpcgMNZsWcFAAn2EytSh6s5AMd1h/6I+7rxCXhbVGwhLjTAilg7UYLRVLl/7DCEbBYlbrsPmmXWZ0jueHbMt2+oM8DPLNZR8D5EnbV5u8eJSFWTBGiBwaROl4qZC3DGjDCfbXre/xmx/V Generated-by-Nova
EOF
#		MONITOR ACCESS
cat<<EOF >> /home/centos/.ssh/authorized_keys
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDPYWeYBlZE1vyc7Vz2yQsI8yK4HsqGq7BB3FhFH+2nW8cjwaj81QfzbN2UhYxIhv7T3iffRQrZ3v2UjI2LEIgFrKYFw+mw0ocpNq9K8z3UwUP3f+e6g7rNkn1m124ZnI0IvFDCJmAdH275bEtowMI16LcrNVAOlXp/YHP3PTyK0apSeih9iJ3hGpcVRraL+MhT8bzaW22fCyDb1pdl60PxenQRUcUvlE1/yntTwiVtd188Vqiaqjo1ffldTlH0G0uhrGsHMkUW65Z8eDXYeebAcy9pp2SQ1LojSGw7zHYacnM872atcc0UNQFnq/FC+MyDE0rM6safIFi+8y0FtGTR Generated-by-Nova
EOF
#		LOCAL PVT KEY
ssh-keygen -q -N "" -t rsa -b 2048 -f /home/centos/.ssh/id_rsa
chmod 700 /home/centos/.ssh/id_rsa
chown centos /home/centos/.ssh/id_rsa
#		Log Report
echo -e "\n### AUTHENTICATION: GENERATED @ $(date -u)" >> ${TMP_LOG}


# -- GENERATE ENVIRONMENT FILES
mkdir ${SMACK_CONF}/env
#		SMACK ENV File
cat<<EOF > ${SMACK_CONF}/env/smack-env.sh
#!/bin/bash
# SMACK ENERGY FORECASTING - ENVIRONMENT VARIABLES
#-------------------------------------------------
export SMACK_MAIN=${SMACK_MAIN}
export SMACK_BIN=${SMACK_BIN}
export SMACK_DOC=${SMACK_DOC}
export SMACK_TMP=${SMACK_TMP}
export SMACK_EXT=${SMACK_EXT}
export SMACK_LOG=${SMACK_LOG}
export SMACK_CONF=${SMACK_CONF}
export SMACK_INIT=${SMACK_INIT}
export SMACK_SKEL=${SMACK_SKEL}
export SMACK_SCHD=${SMACK_SCHD}
export SMACK_MON=${SMACK_MON}
export SMACK_LOAD=${SMACK_LOAD}
# API SERVER ROOT
export API_SRV=${API_SRV}
# JAVA
export JAVA_HOME=${JAVA_HOME}
export JRE_HOME=${JRE_HOME}
# OPENSTACK ENVIRONMENT
export OS_USERNAME=${OS_USERNAME}
export OS_PASSWORD=${OS_PASSWORD}
export OS_PROJECT_NAME=${OS_PROJECT_NAME}
export OS_TENANT_NAME=${OS_TENANT_NAME}
export OS_AUTH_URL=${OS_AUTH_URL}
export OS_ZONE=${OS_ZONE}
export OS_REGION=${OS_REGION}
export OS_SWIFT_URL=${OS_SWIFT_URL}
export OS_ACCT_ID=${OS_ACCT_ID}
# EXECUTABLE PATH
export PATH=\$PATH:\${SMACK_BIN}\${JAVA_HOME}/bin:/usr/local/bin:/usr/bin
EOF
#		Log Report
echo -e "\n### ENVIRONMENT SCRIPT :  GENERATED @ $(date -u)" >> ${TMP_LOG}


# -- GENERATE STARTUP SCRIPT
mkdir ${SMACK_EXT}/api
#		Start-API Script
cat<<EOF > ${SMACK_EXT}/api/start-api.sh
#!/bin/bash
# Stop Node Servers
declare id=$(pgrep node)
if ! [[ -z ${id} ]]; then
	kill ${id};
fi
# Start API Server
node ${API_SRV}/server.js & > /dev/null
EOF
chmod +x ${SMACK_EXT}/api/start-api.sh
#		UP.SH
cat<<EOF > ${SMACK_MON}/up.sh
#!/bin/bash
at -f ${SMACK_EXT}/api/start-api.sh now
EOF
chmod +x ${SMACK_MON}/up.sh
#		Log Report
echo -e "\n### STARTUP SCRIPT :  GENERATED @ $(date -u)" >> ${TMP_LOG}

# -- GENERATE BASH PROFILE
#		Profile.D/SMACK
cat<<EOF > /etc/profile.d/smack.sh
# Configure SMACK Environment
shopt -s expand_aliases
source ${SMACK_CONF}/env/smack-env.sh
# SMACK Command Aliases
figlet -c SMACK Energy Forecasting
echo -e "\t\tSMACK Energy Forecasting - Making an Impact\n"
echo -e "\n#TIP---For a list of commands type smack and press tab.\n"
EOF
#		Log Report
echo -e "\n### BASHRC :  GENERATED @ $(date -u)" >> ${TMP_LOG}

## -- GENERATE CRONTAB SCHEDULING
#		API Startup Script
cat<<EOF > ${SMACK_SCHD}/api.cron 
@reboot ${SMACK_MON}/up.sh
EOF
# Generate Main Crontab
for files in ${SMACK_SCHD}; do 
	cat files >> ${SMACK_TMP}/tmp.cron
done
# Setup Crontab
crontab -u root ${SMACK_TMP}/tmp.cron

# SET FILE AS LOADED
touch ${SMACK_LOAD}
fi

# SETUP PERMISSIONS
chmod +x ${SMACK_BIN}/*
chown -R centos ${SMACK_MAIN}
chown -R centos ${SMACK_HOME}
echo -e "\n### PERMISSIONS: GENERATED @ $(date -u)" >> ${TMP_LOG}

### CLEANUP AND CLOSE
echo -e "\n------ INSTALLATION PROCEDURE COMPLETE ------" >> ${TMP_LOG}
# -- LOG REPORTS
cat ${TMP_LOG} >> ${SMACK_LOG}/install_log
# -- CLEANUP TMP FILES
rm -rf /tmp/*
# -- Reboot System for User
reboot