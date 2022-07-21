#!/bin/bash
set -xe

source ./.env

ssh ${ISUCON_1_HOST} "bash -s" < ./func/deploy.sh ${APP_NAME} ${APP_DIR}
