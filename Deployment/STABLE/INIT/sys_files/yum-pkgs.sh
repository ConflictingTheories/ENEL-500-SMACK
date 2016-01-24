#!/bin/bash
# SMACK Package Installation Script
#
#
#	Runs an install of all packages uses by the SMACK Project
#
#
# Environment
source /usr/local/smack/smack-env.sh
# Install Packages
yum -y install gcc-c++ wget curl curl-devel figlet python
yum -y install make binutils git nmap man maven libffi-devel
yum -y install nano python-devel python-pip links nodejs npm
yum -y groupinstall "Development Tools"
yum -y install zlib-devel bzip2-devel openssl-devel libxml2-devel
yum -y install ncurses-devel sqlite-devel readline-devel zlibrary-devel
yum -y install tk-devel gdbm-devel db4-devel libpcap-devel xz-devel zip-devel
# Log Reporting
echo -e "\nTOOLCHAIN: COMPLETE" >> $SMACK_INSTALL_LOG