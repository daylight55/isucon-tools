#!/bin/bash
set -xe

mkdir tools && cd tools

# alp
wget https://github.com/tkuchiki/alp/releases/download/v1.0.10/alp_linux_amd64.zip
unzip alp_linux_amd64.zip
# パスの通っているディレクトリにalpをインストール
sudo install ./alp /usr/local/bin

# os確認用
# cat /etc/os-release
## pt-query-digest
# ubuntu20.04用のLATEST
# https://www.percona.com/downloads/percona-toolkit/LATEST/
wget https://www.percona.com/downloads/percona-toolkit/3.4.0/binary/debian/focal/x86_64/percona-toolkit_3.4.0-3.focal_amd64.deb
sudo apt-get install -y libdbd-mysql-perl libdbi-perl libio-socket-ssl-perl libnet-ssleay-perl libterm-readkey-perl
sudo dpkg -i percona-toolkit_3.4.0-3.focal_amd64.deb

## NetData
# Ubuntu 20.04のデフォルトのaptリポジトリには、NetdataDebianパッケージが含まれています。
sudo apt install -y netdata
# ブラウザで見る場合 http://18.181.175.5:19999

## エディター
# デフォルトのエディターをvimにする
sudo update-alternatives --set editor /usr/bin/vim.basic
