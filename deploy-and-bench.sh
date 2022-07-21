#!/bin/bash
set -xe

source ./.env

ssh ${ISUCON_1_HOST} "bash -s" < ./func/deploy-and-bench.sh ${TARGET_IP} ${APP_NAME} ${APP_DIR}
