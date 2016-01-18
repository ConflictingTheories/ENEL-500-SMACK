#!/bin/bash
# Display Message
figlet -c SMACK Energy Forecasting
figlet -cf digital Object Storage Download Wizard
# Download from Swift Here
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

# PROMPTING WIZARD
echo -e "\nCONTAINERS:"
swift list
read -p "Which Container would you like to list: " CONTAINER
echo -e "\nCONTAINER: $CONTAINER"
swift list $CONTAINER | more
read -p "What Object would you like to download: " OBJECT
echo -e "Downloading $OBJECT from $CONTAINER..."
swift download $CONTAINER $OBJECT
echo -e "Downloading $OBJECT Complete."