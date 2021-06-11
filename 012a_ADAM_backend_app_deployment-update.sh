#!/usr/bin/env bash
PROJECT_DIR=/app
GIT_BRANCH=Staging
APP_REPO_NAME=jj-autocode-server
GIT_REPO=https://github.com/FissionHQ/${APP_REPO_NAME}.git
APP_HOME_DIR=${PROJECT_DIR}/${APP_REPO_NAME}
VIR_ENV=venvs
VIR_ENV_NAME=adamserver
ENV_FILES_FOLDER="${PROJECT_DIR}/jj-adam-api-env"
SUPERVISOR_CONF_FILE=/etc/supervisord.d/jjserver_app.conf
SUPERVISOR_LOG=/var/log/jj-autocode-server/
SUPERVISOR_PROG_NAME=jjserver_app
SUPERVISOR_CELERY_CONF_FILE=/etc/supervisord.d/jjcelery_adam.conf
SUPERVISOR_CELERY_PROG_NAME=jjcelery_adam
now=$(date +"%FT%T")

echo "coping .env to PROJECT_DIR folder as a env-adamserver-${now}"
cp -r ${APP_HOME_DIR}/.env ${PROJECT_DIR}/env-adamserver-backup-${now}

echo "clone repository"
cd ${APP_HOME_DIR} && git checkout ${GIT_BRANCH} && git pull origin ${GIT_BRANCH}

echo "install requirements.txt file"
/${PROJECT_DIR}/${VIR_ENV}/${VIR_ENV_NAME}/bin/pip install -r requirements.txt


echo "makemigrations,migrate,loaddata & superuser commands"
while true; do
    read -p "Do you wish to run makemigrations for this service?" yn
    case $yn in
        y | Y | yes | YES ) /${PROJECT_DIR}/${VIR_ENV}/${VIR_ENV_NAME}/bin/python manage.py makemigrations; break;;
        n | N | no | NO ) break;;
        * ) echo "Please answer yes(y) or no(n).";;
    esac
done
while true; do
    read -p "Do you wish to run migrate for this service?" yn
    case $yn in
        y | Y | yes | YES ) /${PROJECT_DIR}/${VIR_ENV}/${VIR_ENV_NAME}/bin/python manage.py migrate; break;;
        n | N | no | NO ) break;;
        * ) echo "Please answer yes(y) or no(n).";;
    esac
done
while true; do
    read -p "Do you wish to run loaddata for this service?" yn
    case $yn in
        y | Y | yes | YES ) /${PROJECT_DIR}/${VIR_ENV}/${VIR_ENV_NAME}/bin/python manage.py loaddata standards datasetclass dataformats; break;;
        n | N | no | NO ) break;;
        * ) echo "Please answer yes(y) or no(n).";;
    esac
done
while true; do
    read -p "Do you wish to create superuser for this service?" yn
    case $yn in
        y | Y | yes | YES ) /${PROJECT_DIR}/${VIR_ENV}/${VIR_ENV_NAME}/bin/python manage.py createsuperuser; break;;
        n | N | no | NO ) break;;
        * ) echo "Please answer yes(y) or no(n).";;
    esac
done
while true; do
    read -p "Do you wish to create/update static-files for this service?" yn
    case $yn in
        y | Y | yes | YES ) /${PROJECT_DIR}/${VIR_ENV}/${VIR_ENV_NAME}/bin/python manage.py collectstatic; break;;
        n | N | no | NO ) break;;
        * ) echo "Please answer yes(y) or no(n).";;
    esac
done
while true; do
    read -p "Do you wish to create/update Postgres DB tables/sql files for this service?" yn
    case $yn in
        y | Y | yes | YES ) /${PROJECT_DIR}/${VIR_ENV}/${VIR_ENV_NAME}/bin/python manage.py runplsql; break;;
        n | N | no | NO ) break;;
        * ) echo "Please answer yes(y) or no(n).";;
    esac
done

echo 'restart the app'

supervisorctl restart "${SUPERVISOR_PROG_NAME} ${SUPERVISOR_CELERY_PROG_NAME}"

echo "Completed. Try accessing the page now, Check logs if are seeing any issues"