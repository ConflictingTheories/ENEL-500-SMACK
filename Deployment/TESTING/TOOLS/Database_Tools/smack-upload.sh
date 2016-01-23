#!/bin/bash
# Display Message
figlet -c SMACK Energy Forecasting
figlet -cf digital Object Storage Upload Wizard
# Upload Files
# Check for Login
if [ -z "$OS_USERNAME" ] || [ -z "$OS_PASSWORD" ]; then
	echo -e "\nPlease Login First. Use 'smack-login' and follow the prompts.\n"
	exit
fi
# Manual Usage
while getopts ac:e:f:ho: option
do
        case "${option}"
        in
                a) ALL="TRUE";;
                c) CONTAINER=${OPTARG};;
                e) EXT=${OPTARG};;
                f) FILE=$OPTARG;;
				h) HELP="TRUE";;
				o) NAME=${OPTARG};;
        esac
done

# -h 
if [ "$HELP" == "TRUE" ]; then
	echo -e "SMACK Upload\n\nUsage:\n\t\t-a\tUpload All Files in Directory\n\t\t-e\tUpload all Files with extension\n\t\t-f\tUpload file\n\t\t-o\tObject Name to be saved as\n\t\t-h\tDisplay this Help Message\n"
	exit
fi

# -a Set
if [ "$ALL" == "TRUE" ]; then
	# Loop Through all files in directory and upload
	exit
fi

# PROMPTING WIZARD
if [ -z "$CONTAINER" ]; then
	echo -e "\nCONTAINERS:"
	swift list
	read -p "Please Enter Container: " CONTAINER
fi
if [ -z "$FILE" ]; then
	read -p "Please Enter the File you wish to Upload: " FILE
fi
if [ -z "$NAME" ]; then
	read -p "Please Enter a name for the object: " NAME
fi
echo -e "\nUploading $FILE into container $CONTAINER...\n"
swift upload --object-name $NAME $CONTAINER $FILE
echo -e "\nUploading Object $NAME Complete.\n" 