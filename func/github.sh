#!/bin/bash
GIT_REMOTE_REPOSITORY="git@github.com:daylight55/isucon11-test.git"

# webappディレクトリにetcコンフィグを持ってくる
WEBAPP_DIR=/home/isucon/webapp
cd ${WEBAPP_DIR}
mkdir etc
sudo cp /etc/nginx/nginx.conf ${WEBAPP_DIR}/etc/nginx.conf
sudo cp /etc/mysql/my.cnf ${WEBAPP_DIR}/etc/my.cnf
sudo cp /etc/mysql/conf.d/mysql.cnf ${WEBAPP_DIR}/etc/mysql.cnf
sudo cp /etc/systemd/system/isucondition.ruby.service ${WEBAPP_DIR}/etc/isucondition.ruby.service

# etcにシンボリックリンクを貼る
sudo ln -sb ${WEBAPP_DIR}/etc/nginx.conf /etc/nginx/nginx.conf
sudo ln -sb ${WEBAPP_DIR}/etc/my.cnf /etc/mysql/my.cnf
sudo ln -sb ${WEBAPP_DIR}/etc/mysql.cnf /etc/mysql/conf.d/mysql.cnf
sudo ln -sb ${WEBAPP_DIR}/etc/isucondition.ruby.service /etc/systemd/system/isucondition.ruby.service

# git config~push
git config --global user.name "isucon"
git config --global user.email "isucon@example.com"
git init
git add .
git commit -m "first commit"
echo "....${GIT_REMOTE_REPOSITORY}"
git remote add origin ${GIT_REMOTE_REPOSITORY}
git push -u origin master
