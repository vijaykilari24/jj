#!/bin/bash

PROJECT_DIR=/app
GIT_BRANCH=staging
APP_REPO_NAME=jj-login-app
GIT_REPO=https://github.com/FissionHQ/${APP_REPO_NAME}.git
APP_NAME=UI
APP_HOME_DIR=${PROJECT_DIR}/${APP_REPO_NAME}/${APP_NAME}
SUPERVISOR_LOG=/var/log/jj-autocode-server/
SUPERVISOR_CONF_FILE=/etc/supervisord.d/jjui_login.conf
SUPERVISOR_PROG_NAME=jjui_login
now=$(date +"%FT%T")

echo "coping ../server/.envs/.prod to PROJECT_DIR folder as a .prod-backup-${now}"
cp -r ${PROJECT_DIR}/${APP_REPO_NAME}/server/.envs/.prod ${PROJECT_DIR}/prod-loginserver-backup-${now}

echo "Pull latest code"
cd  ${APP_HOME_DIR}
#git checkout ${PROJECT_DIR}/${APP_REPO_NAME}/server/.envs/.prod
git checkout ${GIT_BRANCH} && git pull origin ${GIT_BRANCH}


echo "installing NPM packages"
/usr/bin/npm install

echo 'restart the app'

supervisorctl restart "${SUPERVISOR_PROG_NAME}"

echo "Completed. Try accessing the page now, Check logs if are seeing any issues"