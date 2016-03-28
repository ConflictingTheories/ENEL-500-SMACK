#!/bin/bash
##############################################################################
##																		  	##
##						SMACK ENERGY FORECASTING						  	##
##								2015-2016									##
##--------------------------------------------------------------------------##
##																		  	##
##	 ___  __  __    __    ___  _  _    ____  _  _  ____  ____   ___  _  __ 	##
##	/ __)(  \/  )  /__\  / __)( )/ )  ( ___)( \( )( ___)(  _ \ / __)( \/ )	##
##	\__ \ )    (  /(__)\( (__  )  (    )__)  )  (  )__)  )   /( (_-. \  /	##
##	(___/(_/\/\_)(__)(__)\___)(_)\_)  (____)(_)\_)(____)(_)\_) \___/ (__)	##
##	 ____  _____  ____  ____  ___    __    ___  ____  ____  _  _  ____ 		##
##	( ___)(  _  )(  _ \( ___)/ __)  /__\  / __)(_  _)(_  _)( \( )/ __)		##
##	 )__)  )(_)(  )   / )__)( (__  /(__)\ \__ \  )(   _)(_  )  (( (_-.		##
##	(__)  (_____)(_)\_)(____)\___)(__)(__)(___/ (__) (____)(_)\_)\___/		##
##																			##
##																			##
##############################################################################
##																			##
##				--	Smack Object/Container Removal Tool  --					##
##																			##
##############################################################################
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
while getopts o:c:h option
do
        case "\${option}"
        in
        		o) OBJECT="\${OPTARG}"
                c) CONTAINER="\${OPTARG}";;
                h) HELP="TRUE";;
        esac
done

# -h
if [[ "\${HELP}" == "TRUE" ]]; then
        echo -e "\nSMACK Object Storage Container Creation\n\nUsage\n\t\t-h\tList This Help Message\n\t\t-c\tContainer to remove\n\t-o\tObject to remove\n"
        exit
fi

# -c
if [[ -z "\${CONTAINER}" ]]; then
        echo -e "\nWelcome to the Container Deletion Wizard.\n\tTo delete a container please follow the instructions.\n\nCurrent Containers:\n"
        swift list 2> /dev/null
        read -p "Enter name of container you wish to delete: (leave blank to do nothing)" CONTAINER
fi
# Check for empty
if [[ -z "\${CONTAINER}" ]]; then 
        exit
else
        # TYPE I
        # retrieve upto 10000 objects
        declare objects=$(swift list ${CONTAINER} 2> /dev/null)
             
        swift delete "\${CONTAINER}" $objects 2> /dev/null
        echo -e "\nContainer Successfully Created"
fi