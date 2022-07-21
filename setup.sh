#!/bin/sh
source ./.env

ISUCON_1_HOST=${1:-isu11-2}
# ISUCON_2_HOST=${2:-isu-2}
# ISUCON_3_HOST=${3:-isu-3}

for remote in ${ISUCON_1_HOST}; do
  echo "Deploying to ${remote}"
  ssh ${remote} "bash -s" < ./func/install.sh
  ./func/send.sh ${remote}
  ssh ${remote} "bash -s" < ./func/github-and-symbolic.sh ${GIT_REMOTE_REPOSITORY} ${APP_NAME}
done
