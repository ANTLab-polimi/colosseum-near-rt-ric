#!/bin/sh
set -x

NEAR_RT_RIC_OCTET=5
NEAR_RT_RIC_IP_BASE="10.0.$NEAR_RT_RIC_OCTET"
NEAR_RT_RIC_NEW_NAME="colosseum-near-rt-ric-$NEAR_RT_RIC_OCTET"
NEAR_RT_RIC_DIR="$(dirname "$PWD")"
WORKSPACE_DIR="$(dirname "$NEAR_RT_RIC_DIR")"
NEAR_RT_RIC_NEW_DIR=${WORKSPACE_DIR}/${NEAR_RT_RIC_NEW_NAME}
NEAR_RT_RIC_NEW_SETUP_DIR=${NEAR_RT_RIC_NEW_DIR}/setup


# Check if xapp exist - if yes, we do nothing
if [ -d "$NEAR_RT_RIC_NEW_DIR" ]; then
    echo "Directory exists."
    cd $WORKSPACE_DIR
    rm -rf $NEAR_RT_RIC_NEW_NAME
    exit
else
    echo "Directory do not exist."
    echo "Coping directory to $NEAR_RT_RIC_NEW_DIR"
    cd $WORKSPACE_DIR
    # create new dir
    mkdir $NEAR_RT_RIC_NEW_NAME
    cp -r ${NEAR_RT_RIC_DIR}/.vscode ${NEAR_RT_RIC_NEW_DIR}
    # change the remote path directory to the new directory
    sed -i "s#${NEAR_RT_RIC_DIR}#${NEAR_RT_RIC_NEW_DIR}#g" ${NEAR_RT_RIC_NEW_DIR}/.vscode/sftp.json
    # copy xapp-sm-connector
    cd $NEAR_RT_RIC_NEW_DIR

    cp -r ${NEAR_RT_RIC_DIR}/setup ${NEAR_RT_RIC_NEW_DIR}

    # copy setup-scripts
    mkdir setup-scripts
    cd ${NEAR_RT_RIC_DIR}/setup-scripts
    cp $(ls  --ignore=create-new-xapp.sh) ${NEAR_RT_RIC_NEW_DIR}/setup-scripts

    cd ${XAPP_NEW_DIR}/setup-scripts
    # setuplib
    sed -i "s#10.0.2#${NEAR_RT_RIC_IP_BASE}#g" ${NEAR_RT_RIC_NEW_DIR}/setup-scripts/setup-lib.sh
    sed -i "s#36422#$(($(($RIC_OCTET-2))*10000+36422))#g" ${NEAR_RT_RIC_NEW_DIR}/setup-scripts/setup-lib.sh
    # setup-ric-bronze
    sed -i "s#ric#ric${NEAR_RT_RIC_OCTET}#g" ${NEAR_RT_RIC_NEW_DIR}/setup-scripts/setup-ric-bronze.sh
    sed -i "s#db #db${NEAR_RT_RIC_OCTET} #g" ${NEAR_RT_RIC_NEW_DIR}/setup-scripts/setup-ric-bronze.sh
    sed -i "s#e2rtmansim #e2rtmansim${NEAR_RT_RIC_OCTET} #g" ${NEAR_RT_RIC_NEW_DIR}/setup-scripts/setup-ric-bronze.sh
    sed -i "s#e2mgr #e2mgr${NEAR_RT_RIC_OCTET} #g" ${NEAR_RT_RIC_NEW_DIR}/setup-scripts/setup-ric-bronze.sh
    sed -i "s#e2term #e2term${NEAR_RT_RIC_OCTET} #g" ${NEAR_RT_RIC_NEW_DIR}/setup-scripts/setup-ric-bronze.sh
    # e2 termination
    sed -i "s#10.0.2#${NEAR_RT_RIC_IP_BASE}#g" ${NEAR_RT_RIC_NEW_DIR}/setup/e2/RIC-E2-TERMINATION/dockerRouter.txt
    sed -i "s#10.0.2#${NEAR_RT_RIC_IP_BASE}#g" ${NEAR_RT_RIC_NEW_DIR}/setup/e2/RIC-E2-TERMINATION/router.txt
    sed -i "s#36422#$(($(($RIC_OCTET-2))*10000+36422))#g" ${NEAR_RT_RIC_NEW_DIR}/setup/e2/RIC-E2-TERMINATION/config/config.conf
    sed -i "s#36422#$(($(($RIC_OCTET-2))*10000+36422))#g" ${NEAR_RT_RIC_NEW_DIR}/setup/e2/RIC-E2-TERMINATION/sctpThread.h
    # e2 mgr
    sed -i "s#10.0.2#${NEAR_RT_RIC_IP_BASE}#g" ${NEAR_RT_RIC_NEW_DIR}/setup/e2mgr/E2Manager/kube_config.yml
    sed -i "s#10.0.2#${NEAR_RT_RIC_IP_BASE}#g" ${NEAR_RT_RIC_NEW_DIR}/setup/e2mgr/E2Manager/router.txt
    sed -i "s#10.0.2#${NEAR_RT_RIC_IP_BASE}#g" ${NEAR_RT_RIC_NEW_DIR}/setup/e2mgr/E2Manager/resources/configuration.yaml
    # main config
    sed -i "s#10.0.2#${NEAR_RT_RIC_IP_BASE}#g" ${NEAR_RT_RIC_NEW_DIR}/setup/e2term_config.conf
    sed -i "s#36422#$(($(($RIC_OCTET-2))*10000+36422))#g" ${NEAR_RT_RIC_NEW_DIR}/setup/e2term_config.conf

fi

# echo "Moving to the new created directory"

cd ${NEAR_RT_RIC_NEW_DIR}
git init -b main
# # git config --global init.defaultBranch "main"
git config --local user.name "fgjeci" 
git config --local user.email "franci.gjeci@gmail.com"
cp ${NEAR_RT_RIC_DIR}/.git/info/exclude ${NEAR_RT_RIC_NEW_DIR}/.git/info/exclude
git add .
git commit -m "Ric creation"

# create github account
# GitHub CLI api
# https://cli.github.com/manual/gh_api

gh repo create ${NEAR_RT_RIC_NEW_NAME} --private --source=. --remote=origin --push
git push --set-upstream origin main


# gh repo delete fgjeci/${XAPP_NEW_IMAGE_NAME}



