#!/bin/bash

PROJECT_DIR=/app
GIT_BRANCH=staging
APP_REPO_NAME=jj-autocode
GIT_REPO=https://github.com/FissionHQ/${APP_REPO_NAME}.git
APP_HOME_DIR=${PROJECT_DIR}/${APP_REPO_NAME}
SUPERVISOR_CONF_FILE=/etc/supervisord.d/jjui_app.conf
SUPERVISOR_LOG=/var/log/jj-autocode-server/
SUPERVISOR_PROG_NAME=jjui_app
now=$(date +"%FT%T")

echo "coping ${APP_HOME_DIR}/.env to PROJECT_DIR folder as a env-adamui-backup-${now}"
cp -r ${APP_HOME_DIR}/.env ${APP_HOME_DIR}/env-adamui-backup-${now}


cd ${PROJECT_DIR} && git clone --single-branch --branch ${GIT_BRANCH} ${GIT_REPO}

cd  ${APP_HOME_DIR} && npm install -g --unsafe-perm=true --allow-root

echo 'restart the app'

supervisorctl restart "${SUPERVISOR_PROG_NAME}"

echo "Completed. Try accessing the page now, Check logs if are seeing any issues"