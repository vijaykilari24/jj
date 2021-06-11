#!/bin/bash
PROJECT_DIR=/app
GIT_BRANCH=development
APP_REPO_NAME=jj-login-app
GIT_REPO=https://github.com/FissionHQ/${APP_REPO_NAME}.git
APP_NAME=server
APP_HOME_DIR=${PROJECT_DIR}/${APP_REPO_NAME}/${APP_NAME}
VIR_ENV=venvs
VIR_ENV_NAME=loginapp
ENV_FILES_FOLDER="${PROJECT_DIR}/.env"
SUPERVISOR_CONF_FILE=/etc/supervisord.d/jjserver_login.conf
SUPERVISOR_LOG=/var/log/jj-autocode-server/
SUPERVISOR_PROG_NAME=jjserver_login


cd /app/
git clone --single-branch --branch ${GIT_BRANCH} ${GIT_REPO} 

mkdir -p ${PROJECT_DIR}/${VIR_ENV}
cd ${PROJECT_DIR}/${VIR_ENV}
# creating virtualenv 
python3 -m venv ${VIR_ENV_NAME}

cd /app/${APP_REPO_NAME}/server

/${PROJECT_DIR}/${VIR_ENV}/${VIR_ENV_NAME}/bin/pip install -r requirements.txt 

# copy envs variables file to .prod

cp /app/jj-login-api-env > ${APP_HOME_DIR}/.envs/.prod

/app/loginserver/bin/python manage.py makemigrations --settings=config.settings.prod
/app/loginserver/bin/python manage.py createsuperuser --settings=config.settings.prod
/app/loginserver/bin/python manage.py runserver --settings=config.settings.prod

echo "copying the supervisor_script if modified"
cp --update -p ${APP_HOME_DIR}/supervisor_scripts/${SUPERVISOR_PROG_NAME}.conf ${SUPERVISOR_CONF_FILE}

echo "creating log files if not exist"
mkdir -p ${SUPERVISOR_LOG} && touch ${SUPERVISOR_LOG}/jjserver_login.err.log ${SUPERVISOR_LOG}/jjserver_login.out.log


echo 'restart the app'
supervisorctl stop "${SUPERVISOR_PROG_NAME}"
sleep 5
supervisorctl start "${SUPERVISOR_PROG_NAME}"

echo "Completed. Try accessing the page now, Check logs if are seeing any issues"