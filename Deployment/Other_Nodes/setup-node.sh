#!/bin/bash
#--------------------------------------------------------
# 				SMACK ENERGY FORECASTING 
#--------------------------------------------------------
#			- Basic Init Script for Nodes -
#--------------------------------------------------------
#	Draft Cloud-Init Script for Setting up a basic node
#   on the cloud. This computer is a bare-bones skeleton.
#
#	Think of this computer possibly one of the workers, or
#	even a spark master nore, or some such node. It could
#	be anything really - nothing but basics installed
#--------------------------------------------------------

# DIRECTORY AND FILE INFORMATION
#-------------------------------
SMACK_DIR=/usr/local/smack
SMACK_DIR_BIN=/usr/local/smack/bin
SMACK_DIR_LOG=/usr/local/smack/log
SMACK_DIR_TMP=/usr/local/smack/tmp
SMACK_LOAD=$SMACK_DIR_LOG/smack_loaded
SMACK_INSTALL_LOG=$SMACK_DIR_LOG/install_log
# Shiny Server
SHINY_SRV=/srv/shiny-server
# Log Reporting
echo -e "\n### INSTALL BEGINNING ###" >> $SMACK_INSTALL_LOG

# GENERATE DIRECTORY STORAGE
#-------------------------------
mkdir $SMACK_DIR
mkdir $SMACK_DIR_BIN
mkdir $SMACK_DIR_LOG
mkdir $SMACK_DIR_TMP
# Log Reporting
echo -e "\nDIRECTORIES: COMPLETE" >> $SMACK_INSTALL_LOG

# UPDATE PACKAGES AND TOOLCHAIN
#--------------------------------
#yum -y update
#yum -y install gcc-c++ wget curl curl-devel figlet python
#yum -y install make binutils git nmap man maven R 
#yum -y install nano python-devel python-pip links
#yum -y groupinstall "Development Tools"

# Log Reporting
echo -e "\nTOOLCHAIN: COMPLETE" >> $SMACK_INSTALL_LOG

# ENSURE ONLY RUNS ONCE
#--------------------------------
if ! [ -e $SMACK_LOAD ]; then

# INSTALL PYTHON 3.5
#--------------------------------
#mkdir /tmp/python3
#cd /tmp/python3
#wget "https://www.python.org/ftp/python/3.5.0/Python-3.5.0.tgz"
#tar -xzvf Python-3.5.0.tgz
#cd Python-3.5.0
#./configure
#make 
#make altinstall
#cd /
#rm -rf /tmp/python3

# Log Reporting
echo -e "\nPYTHON 3.5: COMPLETE" >> $SMACK_INSTALL_LOG

# INSTALL JAVA RUNTIME VERSION (7/8)
#------------------------------------
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
alternatives --install /usr/bin/jar jar /usr/java/jdk1.7.0_79/bin/jar 2
alternatives --install /usr/bin/javac javac /usr/java/jdk1.7.0_79/bin/javac 2
# Set Version to 1.7
alternatives --set java /usr/java/jdk1.7.0_79/bin/java
alternatives --set javac /usr/java/jdk1.7.0_79/bin/javac
alternatives --set jar /usr/java/jdk1.7.0_79/bin/jar
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
# Add version 1.7 to list
alternatives --install /usr/bin/java java /usr/java/jdk1.8.0_40/bin/java 2
alternatives --install /usr/bin/jar jar /usr/java/jdk1.8.0_40/bin/jar 2
alternatives --install /usr/bin/javac javac /usr/java/jdk1.8.0_40/bin/javac 2
# Set Version to 1.7
alternatives --set java /usr/java/jdk1.8.0_40/bin/java
alternatives --set javac /usr/java/jdk1.8.0_40/bin/javac
alternatives --set jar /usr/java/jdk1.8.0_40/bin/jar
# set Variables
JAVA_HOME=/usr/java/jdk1.8.0_40
JRE_HOME=$JAVA_HOME/jre
# cleanup
cd /
rm -rf /tmp/java8


# INSTALL HADOOP 2.X AND CONFIGURE
#-----------------------------------
#
#

# INSTALL YARN AND CONFIGURE
#-----------------------------------
#
#

# INSTALL HIVE AND CONFIGURE
#-----------------------------------
#
#

# INSTALL SPARK AND CONFIGURE
#-----------------------------------
#
#

# INSTALL WEB SERVER (SHINY) AND CONFIGURE
#-----------------------------------
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


# INSTALL WEB DEMO - FOR PRESENTATION
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

# ADD ADDITIONAL SOFTWARE BELOW
#-----------------------------------
#
#
#
#
#

# ADD WELCOME MESSAGE TO INSTANCE
#----------------------------------
cat << EOT >> /etc/bashrc
# Add Executable Path
echo -e "\nAdding Path: /usr/local/smack/bin\n"
export PATH=\$PATH:$SMACK_DIR_BIN
# Display Title Screen for SMACK
figlet -c SMACK Energy Forecasting
echo -e "\t\tSMACK Energy Forecasting - Making an Impact\n"
echo -e "Welome:\n"
EOT

# Initialize file for Completion
touch $SMACK_LOAD

fi

# FINISHED