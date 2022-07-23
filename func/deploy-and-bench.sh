# TODO:
# ミドルウェア再起動、ログローテーション(trucate)、ベンチマーク実行、ログ解析(一番欲しい情報だけ標準出力する) 空コミット作ってプッシュまで一気にやる
# set -ex

TARGET_URL=$1
APP_NAME=$2
APP_DIR=$3

main(){
    # TARGET_URL=$1
    # APP_NAME=$2
    # APP_DIR=$3

    # cd ${APP_DIR}

    # # checkout main
    # git fetch origin
    # git reset --hard origin/master

    # # ログローテーション
    # echo "<==== LOG ROTATE       ====>"
    # sudo mv /var/log/nginx/access.log /var/log/nginx/access.log.`date +%Y%m%d-%H%M%S`
    # sudo rm /var/log/mysql/mysql-slow.log
    # sudo nginx -s reopen
    # sudo mysqladmin flush-logs

    # # 各種サービスの再起動
    # echo
    # echo "<==== RESTART SERVICES ====>"
    # sudo systemctl restart mysql
    # sudo systemctl restart ${APP_NAME}
    # sudo systemctl restart nginx

    # sleep 5

    # ベンチマークの実行
    # echo
    # echo "<==== BENCHMARK        ====>"
    # cd ${HOME}/${APP_DIR}/bench
    # ./bench --target-url "${TARGET_URL}"

    # alp, pt-query-digest で解析
    echo
    echo "<==== ACCESS LOG       ====>"
    # ex) alp ltsv -m "/api/schedules/[0-9a-zA-Z]+" --sort avg -r
    sudo cat /var/log/nginx/access.log | alp json -m "/api/player/competition/[0-9a-zA-Z]+/ranking,/api/player/player/[0-9a-zA-Z]+,/api/organizer/competition/[0-9a-zA-Z]+/score,/api/organizer/competition/[0-9a-zA-Z]+/finish" --sort sum -r | tee alp_$(date +%Y%m%d-%H%M%S).txt

    echo
    echo "<==== SLOW QUERY LOG       ====>"
    sudo pt-query-digest /var/log/mysql/mysql-slow.log | tee digest_$(date +%Y%m%d-%H%M%S).txt
}

main | tee /tmp/score.txt

# gitのコミットメッセージに結果を出力する
cd ${HOME}/${APP_DIR}
git commit --allow-empty --file='/tmp/score.txt'
git push origin HEAD
