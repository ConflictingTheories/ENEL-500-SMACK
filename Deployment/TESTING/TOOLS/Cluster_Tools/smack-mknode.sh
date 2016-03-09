#!/bin/bash
# Output Welcome Screen
if [[ -z "\${OS_USERNAME}" || -z "\${OS_PASSWORD}" ]]; then
	echo -e "Error: You are not logged in. \n\tPlease run 'smack-login' and then try again."
	exit 1
else
	clear
	figlet -c SMACK Energy Forecasting
fi

while getopts n:f:k:x:i:dh option
do
        case "\${option}"
        in
                n) NAME="\${OPTARG}";;
				f) FLAVOUR="\${OPTARG}";;
				k) KEY="\${OPTARG}";;
				x) SCRIPT="\${OPTARG}";;
				i) IMAGE="\${OPTARG}";;
				d) DEFUALT="TRUE";;
				h) HELP="TRUE";;
        esac
done

# Default Instance Information
declare INT_NAME="default"
declare INT_FLAVOR="m1.tiny"
declare INT_IMAGE="907f21d1-305c-4dee-a64a-43fc1a3701a4"
declare INT_OS="linux"
declare INT_KEY="DevAccess"
declare INT_SECURITY="Default"
declare INT_SCRIPT=""

if ! [[ "\${HELP}" == "TRUE" ]]; then
	echo -e "\nSMACK LOGIN UTILTIY\n\tUsage:\n\t\t-n\tInstance Name\n\t\t-f\t\Flavour\n\t\t-k\tAccess Key\n\t\t-x\tDeployment Script\n\t\t-d\t\Use Default Values\n\t\t-h\tHelp Message\n"
fi

# use Wizard or Defaults
if ! [[ "\${DEFAULT}" == "TRUE" ]]; then
	echo "For Defaults Just Press Enter at Prompt."
	if [[ -z "\${NAME}" ]]; then
		echo -e "\tName (*default):"
		read NAME
	fi
	if [[ -z "\${FLAVOUR}" ]]; then
		echo -e "\tFlavour (*m1.tiny):"
		read FLAVOUR
	fi
	if [[ -z "\${KEY}" ]]; then
		echo -e "\tKey (*DevAccess):"
		read KEY
	fi
	if [[ -z "\${SCRIPT}" ]]; then
		echo -e "\tSetup Script (*setup-node.sh):"
		read SCRIPT
	fi
fi

#  Check for new name and change if necessary
if ! [[ -z "\${NAME}" ]]; then
	INT_NAME="\${NAME}"
fi
if ! [[ -z "\${FLAVOUR}" ]]; then
	INT_FLAVOR="\${FLAVOUR}"
fi
if ! [[ -z "\${KEY}" ]]; then
	INT_KEY="\${KEY}"
fi
if ! [[ -z "\${IMAGE}" ]]; then
	INT_IMAGE="\${IMAGE}"
fi
if ! [[ -z "\${SCRIPT}" ]]; then
	INT_SCRIPT="\${SCRIPT}"
fi
# Display instance information
echo -e "Launching VM Instance: \${INT_NAME}"
echo -e "\tOS Type: \${INT_OS}\n\tFlavour: \${INT_FLAVOR}"
echo -ne "\tImage: \$(nova --os-user-name \${OS_USERNAME} \\
      	--os-project-name \${OS_PROJECT_NAME} \\
      	--os-password \${OS_PASSWORD} \\
      	--os-region-name \${OS_REGION} \\
      	--os-auth-url \${OS_AUTH_URL} \\
  		image-list | grep \${INT_IMAGE} | sed 's/ACTIVE//' | sed s/\${INT_IMAGE}// | sed 's/|//g')"
echo -e "\n\tSecurity Group: \${INT_SECURITY}"
echo -e "\tKey: \${INT_KEY}"
echo -e "\tLaunch Script: \${INT_SCRIPT}"
echo -e "\t------------\n"
# Boot up new instance in cloud
nova --os-user-name "\${OS_USERNAME}" \\
    --os-project-name "\${OS_PROJECT_NAME}" \\
    --os-password "\${OS_PASSWORD}" \\
    --os-region-name "\${OS_REGION}" \\
    --os-auth-url "\${OS_AUTH_URL}" \\
	boot \\
	--flavor "\${INT_FLAVOR}" \\
	--image "\${INT_IMAGE}" \\
	--key-name "\${INT_KEY}" \\
	--user-data "\${INT_SCRIPT}" \\
	--security-group "\${INT_SECURITY}" \\
	"\${INT_NAME}"
# Finish Message
echo -e "\nVM Node Creation Finished. \n\n\t**PLEASE NOTE: Installation of script may take upto a couple hours to \n\t\tcomplete before node is fully deployed.\n"
