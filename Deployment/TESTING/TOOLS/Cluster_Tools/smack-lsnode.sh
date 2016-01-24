#!/bin/bash
# Output Welcome Screen
if [ -z "\${OS_USERNAME}" ] || [ -z "\${OS_PASSWORD}" ]; then
	echo -e "Error: You are not logged in.\n\tPlease run 'smack-login' and then try again."
	exit 1
else
	figlet -c SMACK Energy Forecasting
fi
# List Nodes in Cloud
figlet -cf digital NODES LISTING
nova --os-user-name "\${OS_USERNAME}" \\
 	    --os-project-name "\${OS_PROJECT_NAME}" \\
      	--os-password "\${OS_PASSWORD}" \\
      	--os-region-name "\${OS_REGION}" \\
      	--os-auth-url "\${OS_AUTH_URL}" \\
      	--os-auth-url "\${OS_AUTH_URL}" \\
      	list