#!/bin/bash

PROJECT_DIR=/app
GIT_BRANCH=develop
APP_REPO_NAME=jj-login-app
GIT_REPO=https://github.com/FissionHQ/${APP_REPO_NAME}.git
APP_NAME=UI
APP_HOME_DIR=${PROJECT_DIR}/${APP_REPO_NAME}/${APP_NAME}
SUPERVISOR_LOG=/var/log/jj-autocode-server/
SUPERVISOR_CONF_FILE=/etc/supervisord.d/jjui_login.conf
SUPERVISOR_PROG_NAME=jjui_login

echo "Pull latest code"
cd "${PROJECT_DIR}"
git clone --single-branch --branch ${GIT_BRANCH} ${GIT_REPO}
cd  ${APP_HOME_DIR} 

echo "installing NPM packages"
/usr/bin/npm install

echo "copying the supervisor_script if modified"
cp --update -p ${APP_HOME_DIR}/supervisor_scripts/${SUPERVISOR_PROG_NAME}.conf ${SUPERVISOR_CONF_FILE}

echo "creating log files if not exist"
mkdir -p ${SUPERVISOR_LOG} >/dev/null 2>&1 && touch ${SUPERVISOR_LOG}/jjui_login.err.log ${SUPERVISOR_LOG}/jjui_login.out.log

echo 'restart the app'

supervisorctl reread "${SUPERVISOR_PROG_NAME}"
supervisorctl stop "${SUPERVISOR_PROG_NAME}"
sleep 5
supervisorctl start "${SUPERVISOR_PROG_NAME}"

echo "Completed. Try accessing the page now, Check logs if are seeing any issues"