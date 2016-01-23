#!/bin/bash
# Output Welcome Screen
if [ -z "\$OS_USERNAME" ] || [ -z "\$OS_PASSWORD" ]; then
	echo -e "Error: You are not logged in. \n\tPlease run 'smack-login' and then try again."
	exit 1
else
	figlet -c SMACK Energy Forecasting
fi
# Default Instance Information
INT_NAME=default
INT_FLAVOR=m1.tiny
INT_IMAGE=907f21d1-305c-4dee-a64a-43fc1a3701a4
INT_OS=linux
INT_KEY=DevAccess
INT_SECURITY=Default
INT_SCRIPT=setup-node.sh
# Boot and Launch Instance
echo "For Defaults Just Press Enter at Prompt."
echo -e "\tName (*default):"
read NAME
echo -e "\tFlavour (*m1.tiny):"
read FLAVOUR
echo -e "\tKey (*DevAccess):"
read KEY
echo -e "\tSetup Script (*setup-node.sh):"
read SCRIPT
#  Check for new name and change if necessary
if ! [ -z "\$NAME" ]; then
  	    INT_NAME=\$NAME
fi
if ! [ -z "\$FLAVOUR" ]; then
	INT_FLAVOR=\$FLAVOUR
fi
if ! [ -z "\$KEY" ]; then
	INT_KEY=\$KEY
fi
if ! [ -z "\$SCRIPT" ]; then
	INT_SCRIPT=\$SCRIPT
fi
# Display instance information
echo -e "Launching VM Instance: \$INT_NAME"
echo -e "\tOS Type: \$INT_OS\n\tFlavour: \$INT_FLAVOR"
echo -ne "\tImage: \$(nova --os-user-name \$OS_USERNAME \\
      	--os-project-name \$OS_PROJECT_NAME \\
      	--os-password \$OS_PASSWORD \\
      	--os-region-name \$OS_REGION \\
      	--os-auth-url \$OS_AUTH_URL \\
  		image-list | grep \$INT_IMAGE | sed 's/ACTIVE//' | sed s/\$INT_IMAGE// | sed 's/|//g')"
echo -e "\n\tSecurity Group: \$INT_SECURITY"
echo -e "\tKey: \$INT_KEY"
echo -e "\tLaunch Script: \$INT_SCRIPT"
echo -e "\t------------\n"
# Boot up new instance in cloud
nova --os-user-name \$OS_USERNAME \\
    --os-project-name \$OS_PROJECT_NAME \\
    --os-password \$OS_PASSWORD \\
    --os-region-name \$OS_REGION \\
    --os-auth-url \$OS_AUTH_URL \\
	boot \\
	--flavor \$INT_FLAVOR \\
	--image \$INT_IMAGE \\
	--key-name \$INT_KEY \\
	--user-data \$INT_SCRIPT \\
	--security-group \$INT_SECURITY \\
	\$INT_NAME