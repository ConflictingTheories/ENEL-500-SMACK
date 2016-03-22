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

### DEFINITIONS 
# -- SMACK DEFINITIONS
#		Main Directory
export SMACK_MAIN="_%%_SMACK_MAIN_%%_"
#		Documentation
export SMACK_DOC="_%%_SMACK_DOC_%%_"
#		Toolchain Binaries
export SMACK_BIN="_%%_SMACK_BIN_%%_"
#		Configuration Files
export SMACK_CONF="_%%_SMACK_CONF_%%_"
#		Initilization Files
export SMACK_INIT="_%%_SMACK_INIT_%%_"
#		Scheduling Files
export SMACK_SCHD="_%%_SMACK_SCHD_%%_"
#		Skeleton Files
export SMACK_SKEL="_%%_SMACK_SKEL_%%_"
#		Temporary Storage
export SMACK_TMP="_%%_SMACK_TMP_%%_"
#		Log Files
export SMACK_LOG="_%%_SMACK_LOG_%%_"
# 		External Tools
export SMACK_EXT="_%%_SMACK_EXT_%%_"
#		Smack Monitoring Files
export SMACK_MON="_%%_SMACK_MON_%%_"
#		SMACK User Custom Files
export SMACK_HOME="_%%_SMACK_HOME_%%_"
#		Completion Flag
export SMACK_LOAD="_%%_SMACK_LOAD_%%_"
# -- API SPECIFIC DEFINITIONS
#		Node JS Server Root
export WEB_SRV="_%%_WEB_SRV_%%_"
# -- GENERAL DEFINITIONS
# 		Temporary Log File
export TMP_LOG="/tmp/tmp_log"
# 		Environment Path
export PATH="${PATH}:_%%_PATH_%%_"
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
mkdir ${SMACK_HOME}
# -- Speficic Directories
mkdir ${WEB_SRV}
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
echo -e "\n### JAVA INSTALLATION: GENERATED @ $(date -u)" >> ${TMP_LOG}

### WEB SERVER INSTALLATION
# -- SERVER CREATION
# install R + Packages
yum -y install R
R -e "install.packages('shiny', repos='http://cran.stat.sfu.ca/')"
R -e "install.packages('shinydashboard', repos='http://cran.stat.sfu.ca/')"
R -e "install.packages('devtools', repos='http://cran.stat.sfu.ca/')"
R -e "install.packages('ggplot2', repos='http://cran.stat.sfu.ca/')"
R -e "install.packages('dplyr', repos='http://cran.stat.sfu.ca/')"
R -e "install.packages('leaflet', repos='http://cran.stat.sfu.ca/')"
R -e "install.packages('jsonlite', repos='http://cran.stat.sfu.ca/')"
R -e "install.packages('reshape', repos='http://cran.stat.sfu.ca/')"
R -e "install.packages('xlsx', repos='http://cran.stat.sfu.ca/')"

# install shiny-server daemon
mkdir /tmp/shiny
cd /tmp/shiny
wget "https://download3.rstudio.org/centos5.9/x86_64/shiny-server-1.4.1.759-rh5-x86_64.rpm"
yum -y install --nogpgcheck shiny-server-1.4.1.759-rh5-x86_64.rpm
# Set to Port 80
mv /etc/shiny-server/shiny-server.conf /etc/shiny-server/shiny-server.conf.bak
cat /etc/shiny-server/shiny-server.conf.bak | sed 's/3838/80/g' > /etc/shiny-server/shiny-server.conf
# Link to Server
ln -S /srv/shiny-server ${WEB_SRV}
# Cleanup
rm -rf /tmp/shiny
# -- SERVER FILE GENERATION
# 		Index Page
cat <<EOF > ${WEB_SRV}/index.html
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
# 		Shiny Web Application
cat <<EOF > ${WEB_SRV}/app.R
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
#		Log Report
echo -e "\n### WEB SERVER: GENERATED @ $(date -u)" >> ${TMP_LOG}


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
export WEB_SRV=${WEB_SRV}
# JAVA
export JAVA_HOME=${JAVA_HOME}
export JRE_HOME=${JRE_HOME}
# EXECUTABLE PATH
export PATH=\$PATH:\${SMACK_BIN}\${JAVA_HOME}/bin:/usr/local/bin:/usr/bin
EOF
#		Log Report
echo -e "\n### ENVIRONMENT SCRIPT :  GENERATED @ $(date -u)" >> ${TMP_LOG}


# -- GENERATE STARTUP SCRIPT
mkdir ${SMACK_EXT}/api
#		Start-API Script
cat<<EOF > ${SMACK_EXT}/web/start-web.sh
#!/bin/bash
# Stop Node Servers
declare id=$(pgrep shiny-server)
if ! [[ -z ${id} ]]; then
	kill ${id};
fi
# Start API Server
shiny-server &
EOF
#		UP.SH
cat<<EOF > ${SMACK_MON}/up.sh
#!/bin/bash
at -f ${SMACK_EXT}/web/start-web.sh
EOF
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
cat<<EOF > ${SMACK_SCHD}/web.cron 
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