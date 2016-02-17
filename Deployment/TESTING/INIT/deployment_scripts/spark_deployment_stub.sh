#!/bin/bash
# Misc
declare x1="ke"
declare x2="00"
declare x3="13"
declare x4="ac"
# Service User Creation
export SMACK_DIR=/usr/local/smack
export HDP_VER="hadoop-2.6.4"
export SPARK_VER="spark-1.6.0"
export HDP_P=hdp
export HDP_DIR=$SMACK_DIR/$HDP_P
export SPARK_P=spark
export SPARK_DIR=$SMACK_DIR/$SPARK_P

# Credentials and Storage Info
export OS_AUTH_URL="https://keystone-yyc.cloud.cybera.ca:5000/v2.0"
export OS_PROJECT_NAME="SMACK"
export OS_REGION="Calgary"
export OS_HDFS_MAIN="swift://hdfs.smack/"
export OS_HDFS_PUB_BOOL="True"
export OS_PASSWORD="H${x4}${x1}r${x2}${x3}"
export OS_USERNAME="confidential.inc@gmail.com"

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
cd $HDP_DIR
# Download Hadoop
wget http://apache.sunsite.ualberta.ca/hadoop/common/$HDP_VER/$HDP_VER.tar.gz
tar -xzvf $HDP_VER.tar.gz
# Remove Tar
rm -f $HDP_VER.tar.gz
HDP_DIR=$HDP_DIR/$HDP_VER
mkdir $HDP_DIR/namenode
mkdir $HDP_DIR/datanode
# Configure Hadoop
cat << EOF > $HDP_DIR/etc/hadoop/core-site.xml
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
	<property>
		<name>fs.defaultFS</name>
		<value>$OS_HDFS_MAIN</value>
		<description>NameNode URI</description>
	</property>
	<property>
  		<name>fs.swift.impl</name>
  		<value>org.apache.hadoop.fs.swift.snative.SwiftNativeFileSystem</value>
  		<description>File system implementation for Swift</description>
	</property>
	<property>
  		<name>fs.swift.blocksize</name>
  		<value>131072</value>
  		<description>Split size in KB</description>
	</property>
	<property>
  		<name>fs.swift.service.smack.auth.url</name>
  			<value>$OS_AUTH_URL/tokens</value>
  			<description>Keystone authenticaiton URL</description>
	</property>
	<property>
  		<name>fs.swift.service.smack.region</name>
  		<value>$OS_REGION</value>
  		<description>Region name</description>
	</property>
	<property>
  		<name>fs.swift.service.smack.tenant</name>
  		<value>$OS_PROJECT_NAME</value>
  		<description>Tenant name</description>
	</property>
	<property>
  		<name>fs.swift.service.smack.username</name>
  		<value>$OS_USERNAME</value>
	</property>
	<property>
  		<name>fs.swift.service.smack.password</name>
  		<value>$OS_PASSWORD</value>
	</property>
	<property>
		<name>fs.swift.service.smack.public</name>
		<value>$OS_HDFS_PUB_BOOL</value>
	</property>
	<property>
  		<name>fs.swift.service.smack.location-aware</name>
  		<value>true</value>
  		<description>Flag to enable location-aware computing</description>
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
		<value>10000</value>
	</property>
	<property>
		<name>fs.swift.socket.timeout</name>
		<value>10000</value>
	</property>
	<property>
		<name>fs.swift.connect.retry.count</name>
		<value>4</value>
	</property>
	<property>
		<name>fs.swift.connect.throttle.delay</name>
		<value>0</value>
	</property>
</configuration>
EOF
# Hadoop FS
cat << EOF > $HDP_DIR/etc/hdfs-site.xml
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
<property>
 <name>dfs.replication</name>
 <value>1</value>
</property>

<property>
  <name>dfs.name.dir</name>
    <value>file://$HDP_DIR/namenode</value>
</property>

<property>
  <name>dfs.data.dir</name>
    <value>file://$HDP_DIR/datanode</value>
</property>
</configuration>
EOF
# Download and Unpack Spark
mkdir $SPARK_DIR
cd $SPARK_DIR
wget http://apache.sunsite.ualberta.ca/spark/$SPARK_VER/$SPARK_VER-bin-hadoop2.6.tgz
tar -xzvf $SPARK_VER-bin-hadoop2.6.tgz
rm -f $SPARK_VER-bin-hadoop2.6.tgz
cd $SPARK_VER-bin-hadoop2.6
SPARK_DIR=$(pwd)

# Configure Spark
# Core Configuration for HDFS Access
cp $HDP_DIR/etc/hadoop/core-site.xml $SPARK_DIR/conf/core-site.xml
# JAR necessary for Swift Communication
cp $HDP_DIR/share/hadoop/tools/lib/hadoop-openstack-2.6.4.jar $SPARK_DIR/lib/hadoop-openstack-2.6.4.jar
# Spark Environment Script
cat << EOF > $SPARK_DIR/conf/spark-env.sh
#!/bin/bash
# This file is sourced when running various Spark programs.
# Copy it as spark-env.sh and edit that to configure Spark for your site.
# Options read when launching programs locally with
# ./bin/run-example or ./bin/spark-submit
# - HADOOP_CONF_DIR, to point Spark towards Hadoop configuration files
# - SPARK_LOCAL_IP, to set the IP address Spark binds to on this node
# - SPARK_PUBLIC_DNS, to set the public dns name of the driver program
# - SPARK_CLASSPATH, default classpath entries to append
SPARK_CLASSPATH=$SPARK_HOME/lib/hadoop-openstack-2.6.4.jar
# Options read by executors and drivers running inside the cluster
# - SPARK_LOCAL_IP, to set the IP address Spark binds to on this node
# - SPARK_PUBLIC_DNS, to set the public DNS name of the driver program
# - SPARK_CLASSPATH, default classpath entries to append
# - SPARK_LOCAL_DIRS, storage directories to use on this node for shuffle and RDD data
# - MESOS_NATIVE_JAVA_LIBRARY, to point to your libmesos.so if you use Mesos
# Options for the daemons used in the standalone deploy mode
# - SPARK_MASTER_IP, to bind the master to a different IP address or hostname
SPARK_MASTER_IP=$(ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | cut -f1  -d'/')
# - SPARK_MASTER_PORT / SPARK_MASTER_WEBUI_PORT, to use non-default ports for the master
# - SPARK_MASTER_OPTS, to set config properties only for the master (e.g. "-Dx=y")
# - SPARK_WORKER_CORES, to set the number of cores to use on this machine
# - SPARK_WORKER_MEMORY, to set how much total memory workers have to give executors (e.g. 1000m, 2g)
# - SPARK_WORKER_PORT / SPARK_WORKER_WEBUI_PORT, to use non-default ports for the worker
# - SPARK_WORKER_INSTANCES, to set the number of worker processes per node
# - SPARK_WORKER_DIR, to set the working directory of worker processes
# - SPARK_WORKER_OPTS, to set config properties only for the worker (e.g. "-Dx=y")
# - SPARK_DAEMON_MEMORY, to allocate to the master, worker and history server themselves (default: 1g).
# - SPARK_HISTORY_OPTS, to set config properties only for the history server (e.g. "-Dx=y")
# - SPARK_SHUFFLE_OPTS, to set config properties only for the external shuffle service (e.g. "-Dx=y")
# - SPARK_DAEMON_JAVA_OPTS, to set config properties for all daemons (e.g. "-Dx=y")
# - SPARK_PUBLIC_DNS, to set the public dns name of the master or workers
# Generic options for the daemons used in the standalone deploy mode
# - SPARK_CONF_DIR      Alternate conf dir. (Default: ${SPARK_HOME}/conf)
# - SPARK_LOG_DIR       Where log files are stored.  (Default: ${SPARK_HOME}/logs)
# - SPARK_PID_DIR       Where the pid file is stored. (Default: /tmp)
# - SPARK_IDENT_STRING  A string representing this instance of spark. (Default: $USER)
# - SPARK_NICENESS      The scheduling priority for daemons. (Default: 0)
EOF
# Start Hadoop + Spark + Yarn
$HDP_DIR/bin/hdfs namenode -format
$SPARK_DIR/sbin/start-master.sh

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
export HADOOP_VERSION="${HDP_VER}"
export HADOOP_PREFIX="${HDP_DIR}"
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
export SPARK_HOME="${SPARK_DIR}"
export SPARK_MASTER_IP="$(hostname -i)"
# Path
export PATH=\$PATH:\$HADOOP_HOME/bin:/usr/local/bin
export PATH=\$PATH:\$HADOOP_HOME/sbin:\$SMACK_DIR_BIN:/usr/bin
EOF
# Permissions

# Cleanup/Exit