#!/bin/bash
# Display Message
figlet -c SMACK Energy Forecasting
figlet -cf digital Object Storage Upload Wizard
# Upload Files
# Check for Login
if [ -z "$OS_USERNAME" ] | [ -z "$OS_PASSWORD" ]; then
	echo -e "\nPlease Login First. Use 'smack-login' and follow the prompts.\n"
	return
fi

# IF Parameters use them - else use wizard
#
#
#
#
#

# PROMPTING WIZARD
echo -e "\nCONTAINERS:"
swift list
read -p "Please Enter Container: " CONTAINER
read -p "Please Enter the File you wish to Upload: " FILE
read -p "Please Enter a name for the object: " NAME
echo -e "\nUploading $FILE into container $CONTAINER...\n"
swift upload --object-name $NAME $CONTAINER $FILE
echo -e "\nUploading Object $NAME Complete.\n" 