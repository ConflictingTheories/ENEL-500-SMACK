#!/bin/bash
export KEYSTONE_URL="https://keystone-yyc.cloud.cybera.ca:5000/v2.0"
export NOVA_URL="https://nova-yyc.cloud.cybera.ca:8774/v2/2b86ecd5b18f4fafb1d55adb79072def"
export CINDER_URL="https://cinder-yyc.cloud.cybera.ca:8776/v1/2b86ecd5b18f4fafb1d55adb79072def"
export CINDER2_URL="https://cinder-yyc.cloud.cybera.ca:8776/v2/2b86ecd5b18f4fafb1d55adb79072def"
export GLANCE_URL="http://glance-yyc.cloud.cybera.ca:9292"
export EC2_URL="https://nova-yyc.cloud.cybera.ca:8773/services/Cloud"
export SWIFT_URL="https://swift-yyc.cloud.cybera.ca:8080/v1/AUTH_2b86ecd5b18f4fafb1d55adb79072def"
export OS_PROJECT_NAME="SMACK"
export OS_ZONE="Nova"
export OS_REGION="Calgary"
export STORAGE_ACCT="AUTH_4b6be558d44e4dba8fb6e4aa49934c0b"
export STORAGE_TOKEN="7eefd48208754002a2e03bf0de11c3e4"
export STORAGE_URL="https://swift-yyc.cloud.cybera.ca:8080/v1/AUTH_4b6be558d44e4dba8fb6e4aa49934c0b"
export SMACK_DIR=/usr/local/smack
export SMACK_DIR_BIN=/usr/local/smack/bin
export SMACK_DIR_LOG=/usr/local/smack/log
export SMACK_DIR_SKEL=/usr/local/smack/skel
export SMACK_DIR_TMP=/usr/local/smack/tmp
export SMACK_LOAD=/usr/local/smack/log/smack_loaded
export SMACK_INSTALL_LOG=/usr/local/smack/log/install_log
export CRON_PATH=/usr/local/smack/cron
export SHINY_SRV=/srv/shiny-server
export API_SRV=/srv/api-server
export PATH=${PATH}:${SMACK_DIR_BIN}
export PATH=${PATH}:${JAVA_HOME}/bin
export PATH=${PATH}:/usr/local/bin
echo -e "\n### INSTALL BEGINNING ###" >> $SMACK_INSTALL_LOG
echo -e "\n### DECLARATIONS: COMPLETE" >> $SMACK_INSTALL_LOG
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
echo -e "\nDIRECTORIES: COMPLETE" >> $SMACK_INSTALL_LOG
yum -y install gcc-c++ wget curl curl-devel figlet python
yum -y install make binutils git nmap man maven libffi-devel
yum -y install nano python-devel python-pip links nodejs npm
yum -y groupinstall "Development Tools"
yum -y install zlib-devel bzip2-devel openssl-devel libxml2-devel
yum -y install ncurses-devel sqlite-devel readline-devel zlibrary-devel
yum -y install tk-devel gdbm-devel db4-devel libpcap-devel xz-devel zip-devel
echo -e "\nTOOLCHAIN: COMPLETE" >> $SMACK_INSTALL_LOG
if ! [ -e $SMACK_LOAD ]; then
mkdir /tmp/python27
cd /tmp/python27
wget "https://python.org/ftp/python/2.7.8/Python-2.7.8.tgz"
tar -xzvf Python-2.7.8.tgz
cd Python-2.7.8
./configure --prefix=/usr/local --enable-unicode=ucs4 --enable-shared LDFLAGS="-Wl,-rpath /usr/local/lib"
make && make altinstall
cd /
rm -rf /tmp/python27
echo -e "\nPYTHON 2.7: COMPLETE" >> $SMACK_INSTALL_LOG
mkdir /tmp/python3
cd /tmp/python3
wget "https://www.python.org/ftp/python/3.5.0/Python-3.5.0.tgz"
tar -xzvf Python-3.5.0.tgz
cd Python-3.5.0
./configure --prefix=/usr/local --enable-shared LDFLAGS="-Wl,-rpath /usr/local/lib"
make && make altinstall
cd /
rm -rf /tmp/python3
echo -e "\nPYTHON 3.5: COMPLETE" >> $SMACK_INSTALL_LOG
mkdir /tmp/pipinstall
cd /tmp/pipinstall
wget "https://bitbucket.org/pypa/setuptools/raw/bootstrap/ez_setup.py"
/usr/local/bin/python2.7 ez_setup.py
/usr/local/bin/python3.5 ez_setup.py
/usr/local/bin/easy_install-2.7 pip
/usr/local/bin/easy_install-3.3 pip
cd /
rm -rf /tmp/pipinstall
echo -e "\nPIP 2.7/3.5: COMPLETE" >> $SMACK_INSTALL_LOG
/usr/local/bin/pip2.7 install requests['security']
/usr/local/bin/pip2.7 install python-openstackclient
/usr/local/bin/pip2.7 install python-swiftclient
/usr/local/bin/pip2.7 install --upgrade setuptools
/usr/local/bin/pip2.7 install numpy
/usr/local/bin/pip2.7 install scipy
/usr/local/bin/pip3.5 install requests['security']
/usr/local/bin/pip3.5 install python-openstackclient
/usr/local/bin/pip3.5 install python-swiftclient
/usr/local/bin/pip3.5 install --upgrade setuptools
/usr/local/bin/pip3.5 install scipy
/usr/local/bin/pip3.5 install numpy
echo -e "\nOPENSTACK CLIENTS: COMPLETE" >> $SMACK_INSTALL_LOG
yum -y install R
R -e "install.packages('shiny', repos='http://cran.stat.sfu.ca/')"
R -e "install.packages('shiny', repos='http://cran.stat.sfu.ca/')"
R -e "install.packages('shinydashboard', repos='http://cran.stat.sfu.ca/')"
R -e "install.packages('devtools', repos='http://cran.stat.sfu.ca/')"
R -e "install.packages('ggplot2', repos='http://cran.stat.sfu.ca/')"
R -e "install.packages('dplyr', repos='http://cran.stat.sfu.ca/')"
mkdir /tmp/shiny
cd /tmp/shiny
wget "https://download3.rstudio.org/centos5.9/x86_64/shiny-server-1.4.1.759-rh5-x86_64.rpm"
yum -y install --nogpgcheck shiny-server-1.4.1.759-rh5-x86_64.rpm
mv /etc/shiny-server/shiny-server.conf /etc/shiny-server/shiny-server.conf.bak
cat /etc/shiny-server/shiny-server.conf.bak | sed 's/3838/80/g' > /etc/shiny-server/shiny-server.conf
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
echo -e "\nR AND SHINY SERVER: COMPLETE" >> $SMACK_INSTALL_LOG
mkdir /tmp/java7
cd /tmp/java7
wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/7u79-b15/jdk-7u79-linux-x64.rpm"
rpm -ivh jdk-7u79-linux-x64.rpm
alternatives --install /usr/bin/java java /usr/java/jdk1.7.0_79/bin/java 2
alternatives --install /usr/bin/javac javac /usr/java/jdk1.7.0_79/bin/javac 2
alternatives --set java /usr/java/jdk1.7.0_79/bin/java
alternatives --set javac /usr/java/jdk1.7.0_79/bin/javac
JAVA_HOME=/usr/java/jdk1.7.0_79
JRE_HOME=$JAVA_HOME/jre
cd /
rm -rf /tmp/java7
mkdir /tmp/java8
cd /tmp/java8
wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u40-b25/jdk-8u40-linux-x64.rpm"
rpm -ivh jdk-8u40-linux-x64.rpm
alternatives --install /usr/bin/java java /usr/java/jdk1.8.0_40/bin/java 2
alternatives --install /usr/bin/javac javac /usr/java/jdk1.8.0_40/bin/javac 2
alternatives --set java /usr/java/jdk1.8.0_40/bin/java
alternatives --set javac /usr/java/jdk1.8.0_40/bin/javac
JAVA_HOME=/usr/java/jdk1.8.0_40
JRE_HOME=$JAVA_HOME/jre
cd /
rm -rf /tmp/java8
echo -e "\nJDK/JRE 7+8: COMPLETE" >> $SMACK_INSTALL_LOG
cat << EOF > $SMACK_DIR/cron/nwp-load.cron
SMACK_DIR=/usr/local/smack
SMACK_DIR_BIN=/usr/local/smack/bin
SMACK_DIR_LOG=/usr/local/smack/log
SMACK_DIR_SKEL=/usr/local/smack/skel
SMACK_DIR_TMP=/usr/local/smack/tmp
SMACK_LOAD=/usr/local/smack/log/smack_loaded
SMACK_INSTALL_LOG=/usr/local/smack/log/install_log
CRON_PATH=/usr/local/smack/cron
SHINY_SRV=/srv/shiny-server
API_SRV=/srv/api-server
KEYSTONE_URL="https://keystone-yyc.cloud.cybera.ca:5000/v2.0"
NOVA_URL="https://nova-yyc.cloud.cybera.ca:8774/v2/2b86ecd5b18f4fafb1d55adb79072def"
CINDER_URL="https://cinder-yyc.cloud.cybera.ca:8776/v1/2b86ecd5b18f4fafb1d55adb79072def"
CINDER2_URL="https://cinder-yyc.cloud.cybera.ca:8776/v2/2b86ecd5b18f4fafb1d55adb79072def"
GLANCE_URL="http://glance-yyc.cloud.cybera.ca:9292"
EC2_URL="https://nova-yyc.cloud.cybera.ca:8773/services/Cloud"
SWIFT_URL="https://swift-yyc.cloud.cybera.ca:8080/v1/AUTH_2b86ecd5b18f4fafb1d55adb79072def"
OS_PROJECT_NAME="SMACK"
OS_ZONE="Nova"
OS_REGION="Calgary"
STORAGE_ACCT="AUTH_4b6be558d44e4dba8fb6e4aa49934c0b"
STORAGE_TOKEN="7eefd48208754002a2e03bf0de11c3e4"
STORAGE_URL="https://swift-yyc.cloud.cybera.ca:8080/v1/AUTH_4b6be558d44e4dba8fb6e4aa49934c0b"
PATH=/bin:/usr/bin:/usr/local/smack/bin:/usr/local/smack/cron/bin:/usr/local/bin
5 */6 * * * /usr/local/smack/cron/bin/ret_nwp.sh
25 */6 * * * /usr/local/smack/cron/bin/chk_nwp.sh
45 */6 * * * /usr/local/smack/cron/bin/str_nwp.sh
0 0 * * * /usr/local/smack/cron/bin/clr_nwp.sh
EOF
cat << EOF > $CRON_PATH/bin/ret_nwp.sh
#!/bin/bash
shopt -s expand_aliases
source /usr/local/smack/smack-env.sh
declare TMP_DIR="\${SMACK_DIR_TMP}/nwp-load"
if ! [ -e "\${TMP_DIR}" ]; then
	mkdir "\${TMP_DIR}"
fi 
cd "\${TMP_DIR}"
declare nwp_srv="http://dd.weather.gc.ca/model_hrdps/west/grib2"
declare -a nwp_tz=( "00" "06" "12" "18" )
declare -a nwp_sec=("000" "001" "002" "003" "004" "005" "006" \\
					"007" "008" "009" "010" "011" "012" "013" \\
					"014" "015" "016" "017" "018" "019" "020" \\
					"021" "022" "023" "024" "025" "026" "027" \\
					"028" "029" "030" "031" "032" "033" "034" \\
					"035" "036" "037" "038" "039" "040" "041" \\
					"042" "043" "044" "045" "046" "047" "048")
declare nwp_pre="CMC_hrdps_west_"
declare nwp_suf="-00.grib2"
declare nwp_ds="\$(date +%Y%m%d)"
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
declare -i fcnt=0
for a in \${nwp_tz[@]}; do
	for b in \${nwp_sec[@]}; do
		for c in \${nwp_var[@]}; do
			declare filename="\${nwp_pre}\${c}\${nwp_ds}\${a}_P\${b}\${nwp_suf}"
			declare directory="/\${a}/\${b}/"
			declare http_path="\${nwp_srv}\${directory}\${filename}"
			curl -s -O "\${http_path}" > /dev/null
			((fcnt=\${fcnt}+1))
		done
	done
done
T="\$(date)"
touch "\${CRON_PATH}/log/nwp-load.log"
echo -e "\nret_nwp.sh - run @ \${T}\n\tRetreived: \${fcnt} Files" >> "\$CRON_PATH/log/nwp-load.log"
smack-logout > /dev/null
EOF
cat << EOF > $CRON_PATH/bin/chk_nwp.sh
#!/bin/bash
shopt -s expand_aliases
source /usr/local/smack/smack-env.sh
declare TMP_DIR="\${SMACK_DIR_TMP}/nwp-load"
if ! [ -e "\${TMP_DIR}" ]; then
	mkdir "\${TMP_DIR}"
fi 
cd "\${TMP_DIR}"
echo -e "\chk_nwp.sh - run @ \${T}\n" >> "\${CRON_PATH}/log/nwp-load.log"
smack-logout > /dev/null
EOF
cat << EOF > $CRON_PATH/bin/str_nwp.sh
#!/bin/bash
shopt -s expand_aliases
source /usr/local/smack/smack-env.sh
TMP_DIR="\${SMACK_DIR_TMP}/nwp-load"
if ! [ -e "\${TMP_DIR}" ]; then
	mkdir "\${TMP_DIR}"
fi 
cd "\${TMP_DIR}"
declare nwp_ds="\$(date +%Y%m%d)"
declare nwp_con="nwp"
declare nwp_pse="grib2"
if [ "\$(smack-lsdb 2> /dev/null | grep \${nwp_con})" != "\${nwp_con}" ]; then
	smack-mkdb -c "\${nwp_con}" > /dev/null
fi
declare -i fcnt=0
for filename in *\${nwp_ds}*.grib2; do
	smack-upload -c "\${nwp_con}" -o "\${nwp_pse}/\${filename}" -f "\${filename}"
	((fcnt=\${fcnt}+1))
done
T="\$(date)"
echo -e "\nstr_nwp.sh - run @ \${T}\n\tStored: \${fcnt} Files\n" >> "\${CRON_PATH}/log/nwp-load.log"
smack-logout > /dev/null
EOF
cat << EOF > $CRON_PATH/bin/clr_nwp.sh
#!/bin/bash
shopt -s expand_aliases
source /usr/local/smack/smack-env.sh
declare TMP_DIR="\${SMACK_DIR_TMP}/nwp-load"
if ! [ -e "\${TMP_DIR}" ]; then
	mkdir "\${TMP_DIR}"
fi 
cd "\${TMP_DIR}"
declare nwp_ds="\$(date +%Y%m%d)"
declare -a files="\$(ls *\${nwp_ds}*.grib2 2> /dev/null)"
declare -i fcnt="\${#files[@]}";((fcnt=\${fcnt}-1))
rm -f "*\${nwp_ds}*.grib2"
T="\$(date)"
echo -e "\nclr_nwp.sh - run @ \${T}\n\tRemoved: \${fcnt} Files\n" >> "\${CRON_PATH}/log/nwp-load.log"
smack-logout > /dev/null
EOF
crontab "${CRON_PATH}/nwp-load.cron"
echo -e "\nCRON SCHEDULING: COMPLETE" >> $SMACK_INSTALL_LOG
cat << EOF >> $SMACK_DIR/smack-env.sh
#!/bin/bash
export SMACK_DIR=/usr/local/smack
export SMACK_DIR_BIN=/usr/local/smack/bin
export SMACK_DIR_LOG=/usr/local/smack/log
export SMACK_DIR_SKEL=/usr/local/smack/skel
export SMACK_DIR_TMP=/usr/local/smack/tmp
export SMACK_LOAD=/usr/local/smack/log/smack_loaded
export SMACK_INSTALL_LOG=/usr/local/smack/log/install_log
export CRON_PATH=/usr/local/smack/cron
export SHINY_SRV=/srv/shiny-server
export API_SRV=/srv/api-server
export JAVA_HOME=$JAVA_HOME
export JRE_HOME=$JRE_HOME
export KEYSTONE_URL="https://keystone-yyc.cloud.cybera.ca:5000/v2.0"
export NOVA_URL="https://nova-yyc.cloud.cybera.ca:8774/v2/2b86ecd5b18f4fafb1d55adb79072def"
export CINDER_URL="https://cinder-yyc.cloud.cybera.ca:8776/v1/2b86ecd5b18f4fafb1d55adb79072def"
export CINDER2_URL="https://cinder-yyc.cloud.cybera.ca:8776/v2/2b86ecd5b18f4fafb1d55adb79072def"
export GLANCE_URL="http://glance-yyc.cloud.cybera.ca:9292"
export EC2_URL="https://nova-yyc.cloud.cybera.ca:8773/services/Cloud"
export SWIFT_URL="https://swift-yyc.cloud.cybera.ca:8080/v1/AUTH_2b86ecd5b18f4fafb1d55adb79072def"
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
declare uname="confidential.inc@gmail.com"
declare xname="H\${x4}\${x1}r\${x2}\{x3}"
declare pname="SMACK"
alias smack-get='curl -s -H "X-Auth-Token: \${STORAGE_TOKEN}" -X GET'
alias smack-put='curl -s -H "X-Auth-Token: \${STORAGE_TOKEN}" -X PUT'
alias smack-post='curl -s -H "X-Auth-Token: \${STORAGE_TOKEN}" -X POST'
alias smack-delete='curl -s -H "X-Auth-Token: \${STORAGE_TOKEN}" -X DELETE'
alias smack-login="source \${SMACK_DIR_BIN}/smack-login"
alias smack-logout="source \${SMACK_DIR_BIN}/smack-logout"
alias pip27=/usr/local/bin/pip2.7
alias python27=/usr/local/bin/python2.7
export PATH="\${PATH}:\${SMACK_DIR_BIN}"
export PATH="\${PATH}:\${JAVA_HOME}/bin"
export PATH="\${PATH}:/usr/local/bin"
smack-login -u "\${uname}" -x "\${xname}" -p "\${pname}" > /dev/null
EOF
echo -e "\nSMACK ENVIRONMENT SCRIPT: COMPLETE" >> $SMACK_INSTALL_LOG
mkdir $SHINY_SRV/demo
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
echo -e "\nSHINY DEMO: COMPLETE" >> $SMACK_INSTALL_LOG
mkdir $API_SRV/api_demo
cd $API_SRV/api_demo
npm install express --save
npm install request --save
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
node "${API_SRV}/api_demo/app.js" &
echo -e "\nAPI DEMO: COMPLETE" >> $SMACK_INSTALL_LOG
cat << EOT >> /etc/bashrc
shopt -s expand_aliases
source /usr/local/smack/smack-env.sh
smack-logout > /dev/null
figlet -c SMACK Energy Forecasting
echo -e "\t\tSMACK Energy Forecasting - Making an Impact\n"
echo -e "\n#TIP---For a list of commands type smack and press tab.\n"
EOT
echo -e "\nWELCOME: COMPLETE" >> $SMACK_INSTALL_LOG
cat << EOF >> $SMACK_DIR_BIN/smack-lsnode
#!/bin/bash
if [ -z "\${OS_USERNAME}" ] || [ -z "\${OS_PASSWORD}" ]; then
	echo -e "Error: You are not logged in.\n\tPlease run 'smack-login' and then try again."
	exit 1
else
	figlet -c SMACK Energy Forecasting
fi
figlet -cf digital NODES LISTING
nova --os-user-name "\${OS_USERNAME}" \\
 	    --os-project-name "\${OS_PROJECT_NAME}" \\
      	--os-password "\${OS_PASSWORD}" \\
      	--os-region-name "\${OS_REGION}" \\
      	--os-auth-url "\${OS_AUTH_URL}" \\
      	list
EOF
if [ -e "$SMACK_DIR_BIN/smack-lsnode" ]; then
	echo -e "\nLIST NODES: COMPLETE" >> $SMACK_INSTALL_LOG
else
	echo -e "\nLIST NODES: ERROR" >> $SMACK_INSTALL_LOG
fi
cat << EOF > $SMACK_DIR_BIN/smack-mknode
#!/bin/bash
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
declare INT_NAME="default"
declare INT_FLAVOR="m1.tiny"
declare INT_IMAGE="907f21d1-305c-4dee-a64a-43fc1a3701a4"
declare INT_OS="linux"
declare INT_KEY="DevAccess"
declare INT_SECURITY="Default"
declare INT_SCRIPT=""
if ! [ "\${HELP}" == "TRUE" ]; then
	echo -e "\nSMACK LOGIN UTILTIY\n\tUsage:\n\t\t-n\tInstance Name\n\t\t-f\t\Flavour\n\t\t-k\tAccess Key\n\t\t-x\tDeployment Script\n\t\t-d\t\Use Default Values\n\t\t-h\tHelp Message\n"
fi
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
if [ -e "$SMACK_DIR_BIN/smack-mknode" ]; then
	echo -e "\nMAKE NODE: COMPLETE" >> $SMACK_INSTALL_LOG
else
	echo -e "\nMAKE NODE: ERROR" >> $SMACK_INSTALL_LOG
fi
cat << EOF > $SMACK_DIR_BIN/smack-login
#!/bin/bash
figlet -c SMACK Energy Forecasting
figlet -cf digital Cloud Login
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
if [ "\${HELP}" == "TRUE" ]; then
	echo -e "SMACK Login:\n\n\tUsage:\n\t\t-u\t:\tUsername\n\t\t-x\t:\tPassword\n\t\t-p\t:\tProject Name\n\t\t-h\t:\tHelp Message\n"
fi
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
export KEYSTONE_URL="https://keystone-yyc.cloud.cybera.ca:5000/v2.0"
export NOVA_URL="https://nova-yyc.cloud.cybera.ca:8774/v2/2b86ecd5b18f4fafb1d55adb79072def"
export CINDER_URL="https://cinder-yyc.cloud.cybera.ca:8776/v1/2b86ecd5b18f4fafb1d55adb79072def"
export CINDER2_URL="https://cinder-yyc.cloud.cybera.ca:8776/v2/2b86ecd5b18f4fafb1d55adb79072def"
export GLANCE_URL="http://glance-yyc.cloud.cybera.ca:9292"
export EC2_URL="https://nova-yyc.cloud.cybera.ca:8773/services/Cloud"
export SWIFT_URL="https://swift-yyc.cloud.cybera.ca:8080/v1/AUTH_2b86ecd5b18f4fafb1d55adb79072def"
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
if [ -e "$SMACK_DIR_BIN/smack-login" ]; then
	echo -e "\nLOGIN: COMPLETE" >> $SMACK_INSTALL_LOG
else
	echo -e "\nLOGIN: ERROR" >> $SMACK_INSTALL_LOG
fi
cat << EOF > $SMACK_DIR_BIN/smack-logout
#!/bin/bash
figlet -c SMACK Energy Forecasting
figlet -cf digital Logging Out...
unset OS_USERNAME
unset OS_PASSWORD
unset OS_PROJECT_NAME
unset OS_REGION
unset OS_AUTH_URL
unset OS_ZONE
unset KEYSTONE_URL
unset GLANCE_URL
unset CINDER_URL
unset CINDER2_URL
unset SWIFT_URL
unset NOVA_URL
unset EC2_URL
EOF
if [ -e "${SMACK_DIR_BIN}/smack-logout" ]; then
	echo -e "\nLOGOUT: COMPLETE" >> $SMACK_INSTALL_LOG
else
	echo -e "\nLOGOUT: ERROR" >> $SMACK_INSTALL_LOG
fi
cat << EOF > $SMACK_DIR_BIN/smack-suspend
#!/bin/bash
figlet -c SMACK Energy Forecasting
figlet -cf digital Suspending...
if [ -e "${SMACK_DIR_BIN}/smack-suspend" ]; then
	echo -e "\nSUSPEND: COMPLETE" >> $SMACK_INSTALL_LOG
else
	echo -e "\nSUSPEND: ERROR" >> $SMACK_INSTALL_LOG
fi
cat << EOF > $SMACK_DIR_BIN/smack-terminate
#!/bin/bash
figlet -c SMACK Energy Forecasting
figlet -cf digital Terminating...
if [ -e "${SMACK_DIR_BIN}/smack-terminate" ]; then
	echo -e "\nTERMINATE: COMPLETE" >> $SMACK_INSTALL_LOG
else
	echo -e "\nTERMINATE: ERROR" >> $SMACK_INSTALL_LOG
fi
cat << EOF > $SMACK_DIR_BIN/smack-setip
#!/bin/bash
figlet -c SMACK Energy Forecasting
figlet -cf digital IP Config
if [ -e "${SMACK_DIR_BIN}/smack-setip" ]; then
	echo -e "\nIP CONFIG: COMPLETE" >> $SMACK_INSTALL_LOG
else
	echo -e "\nIP CONFIG: ERROR" >> $SMACK_INSTALL_LOG
fi
cat << EOF > $SMACK_DIR_BIN/smack-upload
#!/bin/bash
figlet -c SMACK Energy Forecasting
figlet -cf digital Object Storage Upload Wizard
if [ -z "\${OS_USERNAME}" ] || [ -z "\${OS_PASSWORD}" ]; then
	echo -e "\nPlease Login First. Use 'smack-login' and follow the prompts.\n"
	exit
fi
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
if [ "\${HELP}" == "TRUE" ]; then
	echo -e "SMACK Upload\n\nUsage:\n\t\t-a\tUpload All Files in Directory\n\t\t-e\tUpload all Files with extension\n\t\t-f\tUpload file\n\t\t-o\tObject Name to be saved as\n\t\t-h\tDisplay this Help Message\n"
	exit
fi
if [ "\${ALL}" == "TRUE" ]; then
	echo -e "Function Not Implemented Yet"
	exit
fi
if ! [ -z "\${EXT}" ]; then
	echo -e "Function Not Implemented Yet"
	exit
fi
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
swift upload --object-name "\${NAME}" "\${CONTAINER}" "\${FILE}" 2> /dev/null
echo -e "\nUploading Object \${NAME} Complete.\n" 
EOF
if [ -e "${SMACK_DIR_BIN}/smack-upload" ]; then
	echo -e "\nSWIFT UPLOAD: COMPLETE" >> $SMACK_INSTALL_LOG
else
	echo -e "\nSWIFT UPLOAD: ERROR" >> $SMACK_INSTALL_LOG
fi
cat << EOF > $SMACK_DIR_BIN/smack-download
#!/bin/bash
figlet -c SMACK Energy Forecasting
figlet -cf digital Object Storage Download Wizard
if [ -z "\${OS_USERNAME}" ] || [ -z "\${OS_PASSWORD}" ]; then
	echo -e "\nPlease Login First. Use 'smack-login' and follow the prompts.\n"
	return
fi
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
if [ "\${HELP}" == "TRUE" ]; then
	echo -e "SMACK Download\n\nUsage:\n\t\t-a\tDownload All Files in Container\n\t\t-f\tDownload file Name\n\t\t-o\tObject Name to be Downloaded\n\t\t-h\tDisplay this Help Message\n"
	exit
fi
if [ "\${ALL}" == "TRUE" ]; then
	exit
fi
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
if [ -e "${SMACK_DIR_BIN}/smack-download" ]; then
	echo -e "\nSWIFT DOWNLOAD: COMPLETE" >> $SMACK_INSTALL_LOG
else
	echo -e "\nSWIFT DOWNLOAD: ERROR" >> $SMACK_INSTALL_LOG
fi
cat << EOF > ${SMACK_DIR_BIN}/smack-lsdb
#!/bin/bash
figlet -c SMACK Energy Forecasting
figlet -cf digital Object Storage Listing Wizard
if [ -z "\${OS_USERNAME}" ] || [ -z "\${OS_PASSWORD}" ]; then
	echo -e "\nPlease Login First. Use 'smack-login' and follow the prompts.\n"
	exit
fi
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
if [ "\${HELP}" == "TRUE" ]; then
	echo -e "\nSMACK Object Storage Listing\n\nUsage\n\t\t-l\tList Root Container\n\t\t-h\tList This Help Message\n\t\t-s\tList Container Statistics\n\t\t-c\tContainer to List\n\t\t-o\tObject to List Statistics\n"
	exit
fi
if [ "\${ROOT}" == "TRUE" ]; then
	swift list
	exit
fi
if [ -z "\${CONTAINER}" ]; then
	echo -e "\nCONTAINERS:"
	swift list
	read -p "Which Container (type quit to exit): " CONTAINER
else
	swift list "\${CONTAINER}"
	exit
fi
if [ "\${STAT}" == "TRUE" ]; then
	swift stat "\${CONTAINER}"
	exit
fi
if [ -n "\${OBJECT}" ]; then
	swift stat "\${CONTAINER}" "\${OBJECT}"
	exit
fi
while [ "\${CONTAINER}" != "quit" ]; do
	swift list "\${CONTAINER}"
	read -p "Which Container (Leave empty to quit): " CONTAINER
done
EOF
if [ -e "${SMACK_DIR_BIN}/smack-lsdb" ]; then
	echo -e "\nSWIFT LIST CONTAINER: COMPLETE" >> $SMACK_INSTALL_LOG
else
	echo -e "\nSWIFT LIST CONTAINER: ERROR" >> $SMACK_INSTALL_LOG
fi
cat << EOF > $SMACK_DIR_BIN/smack-mkdb
#!/bin/bash
figlet -c SMACK Energy Forecasting
figlet -cf digital Container Creation Wizard
if [ -z "\${OS_USERNAME}" ] || [ -z "\${OS_PASSWORD}" ]; then
	echo -e "\nPlease Login First. Use 'smack-login' and follow the prompts.\n"
	exit
fi
while getopts c:h option
do
        case "\${option}"
        in
                c) CONTAINER="\${OPTARG}";;
                h) HELP="TRUE";;
        esac
done
if [ "\${HELP}" == "TRUE" ]; then
        echo -e "\nSMACK Object Storage Container Creation\n\nUsage\n\t\t-h\tList This Help Message\n\t\t-c\tContainer to List\n"
        exit
fi
if [ -z "\${CONTAINER}" ]; then
        echo -e "\nWelcome to the Container Creation Wizard.\n\tTo create a container please follow the instructions.\n\nCurrent Containers:\n"
        swift list 2> /dev/null
        read -p "Enter name of container you wish to create: " CONTAINER
fi
swift post "\${CONTAINER}" 2> /dev/null
echo -e "\nContainer Successfully Created"
EOF
if [ -e "${SMACK_DIR_BIN}/smack-mkdb" ]; then
	echo -e "\nSWIFT MAKE CONTAINER: COMPLETE" >> $SMACK_INSTALL_LOG
else
	echo -e "\nSWIFT MAKE CONTAINER: ERROR" >> $SMACK_INSTALL_LOG
fi
cat << EOF > $SMACK_DIR/skel/setup-node.sh
#!/bin/bash
EOF
chmod 777 ${SMACK_DIR_BIN}
chmod 777 ${SMACK_DIR}/skel
chmod 777 ${SMACK_DIR_LOG}
chmod 777 ${SMACK_DIR_TMP}
chmod +x ${SMACK_DIR_BIN}/*
chmod 777 ${CRON_PATH}
chmod 777 ${CRON_PATH}/bin
chmod 777 ${CRON_PATH}/log
chmod +x ${CRON_PATH}/bin/*
echo -e "\nPERMISSIONS: COMPLETE" >> ${SMACK_INSTALL_LOG}
touch $SMACK_LOAD
echo -e "\n### INSTALL: COMPLETE ###" >> ${SMACK_INSTALL_LOG}
fi
