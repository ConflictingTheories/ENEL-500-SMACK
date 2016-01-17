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