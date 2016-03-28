#!/bin/bash
# Display Message
clear
figlet -c SMACK Energy Forecasting
figlet -cf digital Container Creation Wizard
# Download from Swift Here
# Check for Login
if [[ -z "\${OS_USERNAME}" || -z "\${OS_PASSWORD}" ]]; then
	echo -e "\nPlease Login First. Use 'smack-login' and follow the prompts.\n"
	exit
fi

# Manual Usage
while getopts c:h option
do
        case "\${option}"
        in
                c) CONTAINER="\${OPTARG}";;
                h) HELP="TRUE";;
        esac
done

# -h
if [[ "\${HELP}" == "TRUE" ]]; then
        echo -e "\nSMACK Object Storage Container Creation\n\nUsage\n\t\t-h\tList This Help Message\n\t\t-c\tContainer to List\n"
        exit
fi

# -c
if [[ -z "\${CONTAINER}" ]]; then
        echo -e "\nWelcome to the Container Creation Wizard.\n\tTo create a container please follow the instructions.\n\nCurrent Containers:\n"
        swift list 2> /dev/null
        read -p "Enter name of container you wish to create: (leave blank to do nothing)" CONTAINER
fi
# Check for empty
if [[ -z "\${CONTAINER}" ]]; then 
        exit
else
        # TYPE I    
        swift post "\${CONTAINER}" 2> /dev/null
        echo -e "\nContainer Successfully Created"
fi