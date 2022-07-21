#!/bin/sh
source ./.env

for remote in ${ISUCON_1_HOST} ${ISUCON_2_HOST} ${ISUCON_3_HOST}; do
  echo "Deploying to ${remote}"
  ssh ${remote} "bash -s" < ./func/install.sh
  ./func/send.sh ${remote}
  ssh ${remote} "bash -s" < ./func/github-and-symbolic.sh ${GIT_REMOTE_REPOSITORY} ${APP_NAME} ${APP_DIR}
done

ssh ${ISUCON_1_HOST} "bash -s" <<EOF
echo "<==== GIT COMMIT ${GIT_REMOTE_REPOSITORY}   ====>"
cd ${APP_DIR}
git add .
git commit -m "first commit"
git push -u origin master
EOF

ssh ${ISUCON_2_HOST} "bash -s" <<EOF
echo "<==== ${ISUCON_2_HOST} GIT RESET HARD  ====>"
cd ${APP_DIR}
git fetch
git reset --hard origin/master
EOF

ssh ${ISUCON_3_HOST} "bash -s" <<EOF
echo "<==== ${ISUCON_3_HOST} GIT RESET HARD  ====>"
cd ${APP_DIR}
git fetch
git reset --hard origin/master
EOF
