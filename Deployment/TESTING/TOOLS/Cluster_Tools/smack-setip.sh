#!/bin/bash
shopt -s expand_alias
# Display Message
if [[ -z "\${OS_USERNAME}" || -z "\${OS_PASSWORD}" ]]; then
	echo -e "Error: You are not logged in. \n\tPlease run 'smack-login' and then try again."
	exit 1
else
	clear
	figlet -c SMACK Energy Forecasting
	figlet -cf digital IP Config
fi
# Configure IP Here
echo -e "Downloading and Reading Data\n"
smack-download -c clusters -o "conf/master-ip" -x "--output=$SMACK_DIR/tmp/master-ip" 1> /dev/null
declare new_ip="$(cat $SMACK_DIR/tmp/master-ip)"
echo -e "Master IP Found: ${new_ip}"
cat "${SMACK_DIR}/spark/spark-latest/conf/spark-env.sh" |  sed -r "s/SPARK_MASTER_IP=[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}/SPARK_MASTER_IP=${new_ip}/g" > ${SMACK_DIR}/spark/spark-latest/conf/spark-env.sh
echo -e "\nWriting Master IP Data"
rm "$SMACK_DIR/tmp/master-ip"
echo -e "\nIP Change Complete\n"