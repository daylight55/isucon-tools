#!/bin/bash

ISUCON_1_HOST=${1:-isu-1}
ISUCON_2_HOST=${2:-isu-2}
ISUCON_3_HOST=${3:-isu-3}

<< COMMENTOUT
TODO:
- git用の鍵を送って、コンフィグやらインストールやら一発で済ませるスクリプト
- スロークエリログ、nginxのalp用のログ出力用のコンフィグ
- gitコミットする時標準エディターが違う
  - nanoが標準になっててビビる
  - EDITOR=vim の設定とか ~/.bashrc 環境変数とかエイリアス
  alias gp=”git push origin HEAD”
  データベースが違う場合の対応などもあるかも
  https://zenn.dev/m_kawaguchi/articles/00fd650010edb0
-mysql, mysqlのコンフィグとかetc配下のコンフィグ管理方法
- git管理する
- isucon12-qualify/etc ディレクトリ作って、ここに今あるコンフィグをファイルコピーしてコミット、かつコミットした後にこのファイルのシンボリックリンクを貼る
- gitリポジトリの開発スタートまでの準備までする
COMMENTOUT

install() {
  # alpのインストール
  mkdir tools && cd tools
  wget https://github.com/tkuchiki/alp/releases/download/v0.3.1/alp_linux_amd64.zip
  unzip alp_linux_amd64.zip
  # パスの通っているディレクトリにalpをインストール
  sudo install ./alp /usr/local/bin

  # os確認用
  # cat /etc/os-release
  # pt-query-digest
  # ubuntu20.04用のLATEST
  # https://www.percona.com/downloads/percona-toolkit/LATEST/
  wget https://www.percona.com/downloads/percona-toolkit/3.4.0/binary/debian/focal/x86_64/percona-toolkit_3.4.0-3.focal_amd64.deb
  sudo apt-get install -y libdbd-mysql-perl libdbi-perl libio-socket-ssl-perl libnet-ssleay-perl libterm-readkey-perl
  sudo dpkg -i percona-toolkit_3.4.0-3.focal_amd64.deb

  # NetDataのインストール
  # Ubuntu 20.04のデフォルトのaptリポジトリには、NetdataDebianパッケージが含まれています。
  sudo apt install -y netdata
  # ブラウザで見る場合 http://18.181.175.5:19999

  # でふぉをvimにする
  sudo update-alternatives --set editor /usr/bin/vim.basic
}

for remote in ${ISUCON_1_HOST} ${ISUCON_2_HOST} ${ISUCON_3_HOST}
  do
    echo "Deploying to ${remote}"
    ssh ${remote} "cd /home/isucon/isucon12-qualify && $install"
    ssh ${remote} "cd /home/isucon/isucon12-qualify && ./logrotate.sh"
  done
done

# ssh remote exec command
# ssh -i ~/.ssh/ -t isucon@ install
