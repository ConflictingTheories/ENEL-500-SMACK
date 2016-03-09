#!/bin/bash
# SMACK -  Make Upload Utility
# Display Message
clear
figlet -c SMACK Energy Forecasting
figlet -cf digital Object Storage Upload Wizard
# Upload Files
# Check for Login
if [[ -z "\${OS_USERNAME}" || -z "\${OS_PASSWORD}" ]]; then
	echo -e "\nPlease Login First. Use 'smack-login' and follow the prompts.\n"
	exit
fi
# Manual Usage
while getopts ac:e:f:ho:H: option
do
        case "\${option}"
        in
                a) ALL="TRUE";;
                c) CONTAINER="\${OPTARG}";;
                e) EXT="\${OPTARG}";;
                f) FILE="\$OPTARG";;
				h) HELP="TRUE";;
				o) NAME="\${OPTARG}";;
				H) HEADERS="\${OPTARG}";;
        esac
done
# -H
if ! [[ -z "\${HEADERS}" ]]; then
	declare HEADERS="-H \${HEADERS}"
fi
# -h 
if [[ "\${HELP}" == "TRUE" ]]; then
	echo -e "SMACK Upload\n\nUsage:\n\t\t-a\tUpload All Files in Directory\n\t\t-e\tUpload all Files with extension\n\t\t-f\tUpload file\n\t\t-o\tObject Name to be saved as\n\t\t-h\tDisplay this Help Message\n"
	exit
fi
# -e Set
if ! [[ -z "\${EXT}" ]]; then
	# Upload all files of extension passed
	echo -e "Function Not Implemented Yet"
	exit
fi
# PROMPTING WIZARD
if [[ -z "\${CONTAINER}" ]]; then
	echo -e "\nCONTAINERS:"
	swift list
	read -p "Please Enter Container: " CONTAINER
fi
# -a Set
if [[ "\${ALL}" == "TRUE" ]]; then
	for files in \$(ls); do
		echo -e "\nUploading \${files} into container \${CONTAINER}...\n"
		swift upload "\${HEADERS}" --object-name "\${files}" "\${CONTAINER}" "\${files}"  2> /dev/null
	done
	exit
fi
if [[ -z "\${FILE}" ]]; then
	read -p "Please Enter the File you wish to Upload: " FILE
fi
if [[ -z "\${NAME}" ]]; then
	read -p "Please Enter a name for the object: " NAME
fi
# TYPE I
echo -e "\nUploading \${FILE} into container \${CONTAINER}...\n"
swift upload "\${HEADERS}" --object-name "\${NAME}" "\${CONTAINER}" "\${FILE}" 2> /dev/null
echo -e "\nUploading Object \${NAME} Complete.\n"