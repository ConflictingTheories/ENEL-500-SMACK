#!/bin/bash
# Display Message
figlet -c SMACK Energy Forecasting
figlet -cf digital Object Storage Listing Wizard
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
read -p "Which Container (type quit to exit): " CONTAINER
while [ "$CONTAINER" != "quit" ]; do
	swift list $CONTAINER
	read -p "Which Container (Leave empty to quit): " CONTAINER
done