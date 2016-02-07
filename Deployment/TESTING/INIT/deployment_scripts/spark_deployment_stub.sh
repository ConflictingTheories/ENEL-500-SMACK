#!/bin/bash
# Service User Creation
SMACK_DIR=/usr/local/smack
HDP_DIR=/usr/local/smack/hdp

# Basic Utilities
yum -y install gcc-c++ wget curl curl-devel figlet python
yum -y install make binutils git nmap man maven libffi-devel
yum -y install nano python-devel python-pip links nodejs npm
yum -y groupinstall "Development Tools"
yum -y install zlib-devel bzip2-devel openssl-devel libxml2-devel
yum -y install ncurses-devel sqlite-devel readline-devel zlibrary-devel
yum -y install tk-devel gdbm-devel db4-devel libpcap-devel xz-devel

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

# Install Hadoop 2.6.x
#---------------------
# Hadoop Directory
mkdir $SMACK_DIR
cd $SMACK_DIR
mkdir $HDP_DIR
cd hdp
# Download Hadoop
wget http://apache.mirrors.spacedump.net/hadoop/common/stable/hadoop-2.7.1.tar.gz
# unpack
tar -xvzf hadoop-2.7.1.tar.gz
# Remove Tar
rm -f hadoop-2.7.1.tar.gz
# Install Swift Plugin
cd $HDP_DIR/hadoop-2.7.1/
wget http://mvnrepository.com/artifact/org.apache.hadoop/hadoop-openstack/2.7.1
# Configure Hadoop
cat << EOF > $HDP_DIR/hadoop-2.7.1/etc/hadoop/core-site.xml
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
	<property>
		<name>fs.defaultFS</name>
		<value>swift://nwp.smack</value>
		<description>NameNode URI</description>
	</property>
	<property>
		<name>fs.swift.blocksize</name>
		<value>32768</value>
	</property>
	<property>
		<name>fs.swift.partsize</name>
		<value>512</value>
		<description>upload every half MB</description>
	</property>
	<property>
		<name>fs.swift.requestsize</name>
		<value>128</value>
	</property>
	<property>
		<name>fs.swift.connect.timeout</name>
		<value>15000</value>
	</property>
	<property>
		<name>fs.swift.socket.timeout</name>
		<value>60000</value>
	</property>
	<property>
		<name>fs.swift.connect.retry.count</name>
		<value>4</value>
	</property>
	<property>
		<name>fs.swift.connect.throttle.delay</name>
		<value>0</value>
	</property>
	<property>
		<name>fs.swift.service.smack.auth.url</name>
		<value>https://swift-yyc.cloud.cybera.ca:8080/v1/AUTH_2b86ecd5b18f4fafb1d55adb79072def</value>
		<description>SMACK - Storage URL</description>
	</property>
	<property>
		<name>fs.swift.service.smack.project</name>
		<value>SMACK</value>
	</property>
	<property>
		<name>fs.swift.service.smack.username</name>
		<value>confidential.inc@gmail.com</value>
	</property>
	<property>
		<name>fs.swift.service.smack.password</name>
		<value>Hacker0013</value>
	</property>
	<property>
		<name>fs.swift.service.smack.public</name>
		<value>true</value>
	</property>
EOF
# Hadoop FS
cat << EOF > $HDP_DIR/hadoop-2.7.2/etc/hdfs-site.xml
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
<property>
 <name>dfs.replication</name>
 <value>1</value>
</property>

<property>
  <name>dfs.name.dir</name>
    <value>file:///home/hadoop/hadoopdata/hdfs/namenode</value>
</property>

<property>
  <name>dfs.data.dir</name>
    <value>file:///home/hadoop/hadoopdata/hdfs/datanode</value>
</property>
</configuration>
EOF
# Configure Yarn

# Install Hive

# Configure Hive

# Install Spark - From Source

# Configure Spark

# Start Hadoop + Spark + Yarn

# Create Bashrc File
cat << EOF >> /etc/bashrc
# Added by SMACK
#---------------
# SMACK
export SMACK_DIR=/usr/local/smack
export SMACK_DIR_BIN=/usr/local/smack/bin
export SMACK_DIR_LOG=/usr/local/smack/log
export SMACK_DIR_SKEL=/usr/local/smack/skel
export SMACK_DIR_TMP=/usr/local/smack/tmp
export SMACK_LOAD=/usr/local/smack/log/smack_loaded
export SMACK_INSTALL_LOG=/usr/local/smack/log/install_log
# Hadoop
export HADOOP_VERSION="hadoop-2.7.2"
export HADOOP_PREFIX="$HDP_DIR/\$HADOOP_VERSION"
export HADOOP_HOME=\$HADOOP_PREFIX
export HADOOP_COMMON_HOME=\$HADOOP_PREFIX
export HADOOP_CONF_DIR=\$HADOOP_PREFIX/etc/hadoop
export HADOOP_HDFS_HOME=\$HADOOP_PREFIX
export HADOOP_MAPRED_HOME=\$HADOOP_PREFIX
export YARN_HOME=\$HADOOP_PREFIX
# Java
export JAVA_HOME=/usr/java/jdk1.8.0_40
export JRE_HOME=\$JAVA_HOME/jre
# Spark

# Path
export PATH=\$PATH:\$HADOOP_HOME/bin:/usr/local/bin
export PATH=\$:PATH:\$HADOOP_HOME/sbin:\$SMACK_DIR_BIN:/usr/bin
EOF
# Permissions

# Cleanup/Exit