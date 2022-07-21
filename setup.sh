#!/bin/sh
source ./.env

ISUCON_1_HOST=${1:-isu10-1}
ISUCON_2_HOST=${2:-isu10-2}
ISUCON_3_HOST=${3:-isu10-3}

for remote in ${ISUCON_1_HOST}; do
  echo "Deploying to ${remote}"
  ssh ${remote} "bash -s" < ./func/install.sh
  ./func/send.sh ${remote}
  ssh ${remote} "bash -s" < ./func/github-and-symbolic.sh ${GIT_REMOTE_REPOSITORY} ${APP_NAME}
done

ssh ${ISUCON_1_HOST} "bash -s" <<EOF
echo "<==== GIT COMMIT ${GIT_REMOTE_REPOSITORY}   ====>"
git add .
git commit -m "first commit"
git push -u origin master
EOF

ssh ${ISUCON_2_HOST} "bash -s" <<EOF
echo "<==== ${ISUCON_2_HOST} GIT RESET HARD  ====>"
git fetch
git reset --hard origin/master
EOF

ssh ${ISUCON_3_HOST} "bash -s" <<EOF
echo "<==== ${ISUCON_3_HOST} GIT RESET HARD  ====>"
git fetch
git reset --hard origin/master
EOF
