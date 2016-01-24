# SMACK ENERGY FORECASTING - ENVIRONMENT VARIABLES
#-------------------------------------------------
#
#	The purpose of this script is to setup all 
#	required environment declarations in one 
#	simple location
#
#-------------------------------------------------

# SMACK ENVIRONMENT
declare -r -x SMACK_DIR=/usr/local/smack
declare -r -x SMACK_DIR_BIN=/usr/local/smack/bin
declare -r -x SMACK_DIR_LOG=/usr/local/smack/log
declare -r -x SMACK_DIR_SKEL=/usr/local/smack/skel
declare -r -x SMACK_DIR_TMP=/usr/local/smack/tmp
declare -r -x SMACK_LOAD=/usr/local/smack/log/smack_loaded
declare -r -x SMACK_INSTALL_LOG=/usr/local/smack/log/install_log

# CRON JOB ROOT
declare -r -x CRON_PATH=/usr/local/smack/cron

# SHINY SERVER ROOT
declare -r -x SHINY_SRV=/srv/shiny-server

# API SERVER ROOT
declare -r -x API_SRV=/srv/api-server

# JAVA VARIABLES
declare -r -x JAVA_HOME=$JAVA_HOME
declare -r -x JRE_HOME=$JRE_HOME

# OPENSTACK ENVIRONMENT
# URLs for API Access (may need to change)
declare -r -x KEYSTONE_URL="https://keystone-yyc.cloud.cybera.ca:5000/v2.0"
declare -r -x NOVA_URL="https://nova-yyc.cloud.cybera.ca:8774/v2/2b86ecd5b18f4fafb1d55adb79072def"
declare -r -x CINDER_URL="https://cinder-yyc.cloud.cybera.ca:8776/v1/2b86ecd5b18f4fafb1d55adb79072def"
declare -r -x CINDER2_URL="https://cinder-yyc.cloud.cybera.ca:8776/v2/2b86ecd5b18f4fafb1d55adb79072def"
declare -r -x GLANCE_URL="http://glance-yyc.cloud.cybera.ca:9292"
declare -r -x EC2_URL="https://nova-yyc.cloud.cybera.ca:8773/services/Cloud"
declare -r -x SWIFT_URL="https://swift-yyc.cloud.cybera.ca:8080/v1/AUTH_2b86ecd5b18f4fafb1d55adb79072def"

# SERVICE AUTHENTICATION CREDENTIALS
# Cron Authentication Using Token and URL with curl requests
declare -x OS_PROJECT_NAME="SMACK"
declare -x OS_ZONE="Nova"
declare -x OS_REGION="Calgary"
declare -x -r STORAGE_ACCT="AUTH_4b6be558d44e4dba8fb6e4aa49934c0b"
declare -x -r STORAGE_TOKEN="7eefd48208754002a2e03bf0de11c3e4"
declare -x -r STORAGE_URL="https://swift-yyc.cloud.cybera.ca:8080/v1/AUTH_4b6be558d44e4dba8fb6e4aa49934c0b"

# Authenticated API Calls
alias smack-get='curl -s -H "X-Auth-Token: \${STORAGE_TOKEN}" -X GET'
alias smack-put='curl -s -H "X-Auth-Token: \${STORAGE_TOKEN}" -X PUT'
alias smack-post='curl -s -H "X-Auth-Token: \${STORAGE_TOKEN}" -X POST'
alias smack-delete='curl -s -H "X-Auth-Token: \${STORAGE_TOKEN}" -X DELETE'
# Login Authenication overwrite
alias smack-login="source \${SMACK_DIR_BIN}/smack-login"
alias smack-logout="source \${SMACK_DIR_BIN}/smack-logout"
# Python Aliases
alias pip27=/usr/local/bin/pip2.7
alias python27=/usr/local/bin/python2.7

# EXECUTABLE PATH
export PATH=\${PATH}:\${SMACK_DIR_BIN}
export PATH=\${PATH}:\${JAVA_HOME}/bin
export PATH=\${PATH}:/usr/local/bin
