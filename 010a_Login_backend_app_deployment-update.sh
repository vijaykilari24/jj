#!/bin/bash
PROJECT_DIR=/app
GIT_BRANCH=staging
APP_REPO_NAME=jj-login-app
GIT_REPO=https://github.com/FissionHQ/${APP_REPO_NAME}.git
APP_NAME=server
APP_HOME_DIR=${PROJECT_DIR}/${APP_REPO_NAME}/${APP_NAME}
VIR_ENV=venvs
VIR_ENV_NAME=loginserver
ENV_FILES_FOLDER="${PROJECT_DIR}/.env"
SUPERVISOR_CONF_FILE=/etc/supervisord.d/jjserver_login.conf
SUPERVISOR_LOG=/var/log/jj-autocode-server/
SUPERVISOR_PROG_NAME=jjserver_login
now=$(date +"%FT%T")

echo "coping ../server/.envs/.prod to PROJECT_DIR folder as a .prod-backup-${now}"
cp -r ${PROJECT_DIR}/${APP_REPO_NAME}/server/.envs/.prod ${PROJECT_DIR}/prod-loginserver-backup-${now}

echo "Pull latest code"
cd  ${APP_HOME_DIR}
#git checkout ${PROJECT_DIR}/${APP_REPO_NAME}/server/.envs/.prod
git checkout ${GIT_BRANCH} && git pull origin ${GIT_BRANCH}

cd /app/${APP_REPO_NAME}/server
/${PROJECT_DIR}/${VIR_ENV}/${VIR_ENV_NAME}/bin/pip install -r requirements.txt 
while true; do
    read -p "Do you wish to run make-migrations for this service?" yn
    case $yn in
        y | Y | yes | YES ) /app/venvs/loginserver/bin/python manage.py makemigrations --settings=config.settings.prod; break;;
        n | N | no | NO ) break;;
        * ) echo "Please answer yes(y) or no(n).";;
    esac
done
while true; do
    read -p "Do you wish to run migrate for this service? Hint: if make-migration, yes. please select yes." yn
    case $yn in
        y | Y | yes | YES ) /app/venvs/loginserver/bin/python manage.py migrate --settings=config.settings.prod; break;;
        n | N | no | NO ) break;;
        * ) echo "Please answer yes(y) or no(n).";;
    esac
done
while true; do
    read -p "Do you wish to create superuser for this service?" yn
    case $yn in
        y | Y | yes | YES ) /app/venvs/loginserver/bin/python manage.py createsuperuser --settings=config.settings.prod; break;;
        n | N | no | NO ) break;;
        * ) echo "Please answer yes(y) or no(n).";;
    esac
done

echo 'restart the app'
supervisorctl restart "${SUPERVISOR_PROG_NAME}"

echo "Completed. Try accessing the page now, Check logs if are seeing any issues"
