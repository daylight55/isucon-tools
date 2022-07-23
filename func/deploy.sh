# TODO:
# ミドルウェア再起動、ログローテーション(trucate)、ベンチマーク実行、ログ解析(一番欲しい情報だけ標準出力する) 空コミット作ってプッシュまで一気にやる
set -e

APP_NAME=$1
APP_DIR=$2

echo "<==== RESTART       ====>"
cd ${APP_DIR}

# checkout main
git fetch origin
git reset --hard origin/master

# データベース初期化
bash ./sql/init.sh

# ログローテーション
echo "<==== LOG ROTATE       ====>"
sudo mv /var/log/nginx/access.log /var/log/nginx/access.log.`date +%Y%m%d-%H%M%S`
sudo rm -f /var/log/mysql/mysql-slow.log
sudo nginx -s reopen
sudo mysqladmin flush-logs

# 各種サービスの再起動
echo
echo "<==== RESTART SERVICES ====>"
sudo systemctl daemon-reload
sudo systemctl restart mysql
sudo systemctl restart ${APP_NAME}
sudo systemctl restart nginx
