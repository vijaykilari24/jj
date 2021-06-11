#!/bin/bash

PROJECT_DIR=/app
GIT_BRANCH=staging
APP_REPO_NAME=jj-autocode
GIT_REPO=https://github.com/FissionHQ/${APP_REPO_NAME}.git
APP_HOME_DIR=${PROJECT_DIR}/${APP_REPO_NAME}
SUPERVISOR_CONF_FILE=/etc/supervisord.d/jjui_app.conf
SUPERVISOR_LOG=/var/log/jj-autocode-server/
SUPERVISOR_PROG_NAME=jjui_app


cd ${PROJECT_DIR} && git clone --single-branch --branch ${GIT_BRANCH} ${GIT_REPO}

cd  ${APP_HOME_DIR} && npm install -g --unsafe-perm=true --allow-root

cat /app/jj-adam-ui-env > ${APP_HOME_DIR}/.env

echo "creating log files if not exist"
touch ${SUPERVISOR_LOG}/jjui_app.err.log ${SUPERVISOR_LOG}/jjui_app.out.log


echo "copying the supervisor_script if modified"
cp --update -p ${APP_HOME_DIR}/supervisor_scripts/${SUPERVISOR_PROG_NAME}.conf ${SUPERVISOR_CONF_FILE}

echo 'restart the app'
# Reread supervisor configuration.
supervisorctl reread 
# Restart service(s) whose configuration has changed. Usually run after 'reread'.
supervisorctl update

supervisorctl stop "${SUPERVISOR_PROG_NAME}"
sleep 5
supervisorctl start "${SUPERVISOR_PROG_NAME}"

echo "Completed. Try accessing the page now, Check logs if are seeing any issues"