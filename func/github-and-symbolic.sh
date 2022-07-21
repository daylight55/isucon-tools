#!/bin/bash
set -e

#TODO: ディレクトリチェック処理入れる

GIT_REMOTE_REPOSITORY="${1}"
APP_NAME="${2}"
APP_DIR="${3}"

echo "<==== STOP SYSTEMD UNIT      ====>"
sudo systemctl disable --now apparmor
sudo systemctl disable --now ${APP_NAME}.go
sudo systemctl enable --now ${APP_NAME}.ruby

# webappディレクトリにetcコンフィグを持ってくる
echo "<==== COPY ETC FILES     ====>"
WEB_APP_DIR=/home/isucon/${APP_DIR}
cd ${WEB_APP_DIR}
mkdir etc
sudo cp /etc/nginx/nginx.conf ${WEB_APP_DIR}/etc/nginx.conf
sudo cp /etc/mysql/my.cnf ${WEB_APP_DIR}/etc/my.cnf
sudo cp /etc/systemd/system/${APP_NAME}.ruby.service ${WEB_APP_DIR}/etc/${APP_NAME}.ruby.service

echo "<==== SYMBOLIC LINK     ====>"
# etcにシンボリックリンクを貼る
sudo ln -sb ${WEB_APP_DIR}/etc/nginx.conf /etc/nginx/nginx.conf
# NOTICE: my.cnfのシンボリックリンクは/etc/mysqlの場合読まれないので/etc直下に置く
sudo ln -sb ${WEB_APP_DIR}/etc/my.cnf /etc/my.cnf
sudo ln -sb ${WEB_APP_DIR}/etc/${APP_NAME}.ruby.service /etc/systemd/system/${APP_NAME}.ruby.service

# git config~push
echo "<==== GIT SETTING     ====>"
git config --global user.name "isucon"
git config --global user.email "isucon@example.com"
git init
git remote add origin ${GIT_REMOTE_REPOSITORY}
