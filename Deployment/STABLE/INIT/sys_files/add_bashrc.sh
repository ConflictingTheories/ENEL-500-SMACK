## ADDED BY SMACK------------>

# Add Executable Path
echo -e "\nAdding Path: $SMACK_DIR_BIN\n"
export PATH=\$PATH:$SMACK_DIR_BIN
export PATH=\$PATH:$JAVA_HOME/bin
export PATH=\$PATH:/usr/local/bin
export JAVA_HOME=$JAVA_HOME
export JRE_HOME=$JRE_HOME

# SMACK Command Aliases
alias smack-login="source $SMACK_DIR_BIN/smack-login"
alias smack-logout="source $SMACK_DIR_BIN/smack-logout"
# Python Aliases
alias pip27=/usr/local/bin/pip2.7
alias python27=/usr/local/bin/python2.7
# Display Title Screen for SMACK
figlet -c SMACK Energy Forecasting
echo -e "\t\tSMACK Energy Forecasting - Making an Impact\n"
echo -e "Welcome to the Development Machine:\n"
echo -e "\n#TIP---For a list of commands type smack and press tab.\n"