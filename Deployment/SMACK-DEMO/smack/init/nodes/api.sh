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
res.send('<html><body><h1>SMACK Energy Forecasting</h1><br/><br/>SMACK Energy Forecasting API Portal<br/>\\
	<br/>Please Read below for options<br/><br/><h2>API Endpoints:</h2><br/><p><b>Weather Prediction Data (NWP):</b>\\
	<br/><ul><li>/nwp?date=YYYYMMDD&rt=XX&fh=XX&var=VARNAME</li><br/><li>Variables:<br/><ul><li>DEN_TGL_80, WIND_TGL_10, WIND_TGL_40, WIND_TGL_80</li></ul>\\
	</li></ul><br/><b>Historical Power Data:</b>\\
	<br/><ul><li>/hist?date=YYYYMMDD&hour=XX&min=XX</li></ul>\\
	<br/><b>Predicted Power Data:</b><br/>\\
	<ul><li>/pred?date=YYYYMMDD&rt=XX&site=XXXX</li><li>Available Wind Farms(sites):<br/>\\
	<ul><li>ARD1, AKE1, BUL1, BUL2, BSR1, BTR1, CR1, CRR1, CRW1, SCR2, SCR3, SCR4, TAB1, KHW1, NEP1, OWF1, IEW1, IEW2, HAL1, GWW1</li></ul>\\
	</li></ul><ul><li>MORE COMING SOON</li></ul><p></body></html>');
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
							try{
								new_bdy = JSON.parse(bdy);
								// FOR EDITING THE STRUCTURE OF THE OBJECT LISTING (FARMS)
								//for(f in new_bdy) 
								//{	
								//	Perform Changes Here
								//}
							}
							catch(e)
							{
								new_bdy = JSON.parse('{"error":"bad json"}');
							}
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

// GET Request API Call - Prediction Data
app.get('/pred', function(req, res) 
{
	var rq = req.query;
	if ( rq.date != null && rq.rt != null && rq.site != null )
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

            	request({'url':swift_url+'/PwrPred?prefix='+dt}, function (err, resp, bdy)
            	{
            		var rt_objs = bdy.split("\n").map(function(obj)
            		{
						// Single Site
						if (rq.site != "")
						{
							if( obj.search(rq.site) != -1)
								return obj;
						}
						// All Sites
						else if (rq.site == "")
						{
							if( obj.search(dt+'/') != -1)
								return obj;
						}
					});

            		rt_objs = rt_objs.filter(function(e){return e;});

            		if( rt_objs.length > 0)
            		{
            			var cnt = 0;
            			var accumulator = [];
						// Loop through and download files from swift
						rt_objs = rt_objs.filter(function (e){ if (e.search('_SUCCESS') == -1 && e != dt){return e} });
						rt_objs = rt_objs.filter(function (e){if(e.search('part-00000') != -1){return e}});
                        //console.log(rt_objs);
                        for(fl in rt_objs)
                        {
                        	if ( rt_objs[fl] != undefined )
                        	{
                        		request({'url':swift_url+'/PwrPred/'+rt_objs[fl]}, function (err, rsp, bdy)
                        		{
                        			if (bdy != undefined) {
                        				new_bdy = bdy;
                        					if ( bdy != "" )
                        					{
                        						try
                        						{
                        							//console.log(bdy);
                        							new_bdy = JSON.parse(bdy);
                        						}
                        						catch(e)
                        						{
                                            		// Replace with
                                            		new_bdy = JSON.parse('{"error":"bad json"}');
                                            	}
                                            }
                                            // FOR EDITING THE STRUCTURE OF THE OBJECT LISTING (FARMS)
                                            //for(f in new_bdy)
                                            //{
                                            //      Perform Changes Here
                                            //}
                                            container = 'PwrPred/';
                                            file_end = '/part-00000';
                                            pUrl = rsp.req.path;
                                            indexStart = pUrl.indexOf(container);
                                            indexEnd = pUrl.indexOf(file_end);
                                            sitename = pUrl.substring(indexStart+19, indexStart+21);
                                            runtime = pUrl.substring(indexStart+22, indexEnd);
                                            data = { 'date': yyyy+'/'+mm+'/'+dd, 'rt': runtime, 'site': sitename, 'data': new_bdy };
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
cat <<EOF > $SMACK_DIR_BIN/smack-ssnode
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
cat <<EOF > $SMACK_DIR_BIN/smack-rmnode
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

# SETUP PERMISSIONS
chmod +x ${SMACK_BIN}/*
chown -R centos ${SMACK_MAIN}
chown -R centos ${SMACK_HOME}
# Set Cluster Information
source /usr/local/smack/smack-env.sh
smack-setip -n api
echo -e "\n### PERMISSIONS: GENERATED @ $(date -u)" >> ${TMP_LOG}

### CLEANUP AND CLOSE
echo -e "\n------ INSTALLATION PROCEDURE COMPLETE ------" >> ${TMP_LOG}
# -- LOG REPORTS
cat ${TMP_LOG} >> ${SMACK_LOG}/install_log
# -- CLEANUP TMP FILES
rm -rf /tmp/*
# -- Reboot System for User
reboot