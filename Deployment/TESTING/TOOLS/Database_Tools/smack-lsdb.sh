#!/bin/bash
# Display Message
clear
figlet -c SMACK Energy Forecasting
figlet -cf digital Object Storage Listing Wizard
# Download from Swift Here
# Check for Login
if [[ -z "\${OS_USERNAME}" || -z "\${OS_PASSWORD}" ]]; then
	echo -e "\nPlease Login First. Use 'smack-login' and follow the prompts.\n"
	exit
fi
# Manual Usage
while getopts lso:c:h option
do
        case "\${option}"
        in
                l) ROOT="TRUE";;
                c) CONTAINER="\${OPTARG}";;
                s) STAT="TRUE";;
				h) HELP="TRUE";;
				o) OBJECT="\${OPTARG}";;
        esac
done
# -h
if [[ "\${HELP}" == "TRUE" ]]; then
	echo -e "\nSMACK Object Storage Listing\n\nUsage\n\t\t-l\tList Root Container\n\t\t-h\tList This Help Message\n\t\t-s\tList Container Statistics\n\t\t-c\tContainer to List\n\t\t-o\tObject to List Statistics\n"
	exit
fi

# -l 
if [[ "\${ROOT}" == "TRUE" ]]; then
	swift list
	exit
fi
# Prompting Wizard
if [[ -z "\${CONTAINER}" ]]; then
	echo -e "\nCONTAINERS:"
	swift list
	read -p "Which Container (type quit to exit): " CONTAINER
else
	swift list "\${CONTAINER}"
	exit
fi
# -s
if [[ "\${STAT}" == "TRUE" ]]; then
	swift stat "\${CONTAINER}"
	exit
fi
# -o
if [[ -n "\${OBJECT}" ]]; then
	swift stat "\${CONTAINER}" "\${OBJECT}"
	exit
fi

# Prompting Loop
while [[ "\${CONTAINER}" != "quit" ]]; do
	swift list "\${CONTAINER}"
	read -p "Which Container (type 'quit' to leave): " CONTAINER
done