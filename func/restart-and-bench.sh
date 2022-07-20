# TODO:
# ミドルウェア再起動、ログローテーション(trucate)、ベンチマーク実行、ログ解析(一番欲しい情報だけ標準出力する) 空コミット作ってプッシュまで一気にやる
set -e

TARGET_IP=$1

main(){
    cd ${HOME}/webapp

    # checkout main
    git fetch origin
    git reset --hard origin/master

    # ログローテーション
    echo "<==== LOG ROTATE       ====>"
    sudo mv /var/log/nginx/access.log /var/log/nginx/access.log.`date +%Y%m%d-%H%M%S`
    sudo rm /var/log/mysql/mysql-slow.log
    sudo nginx -s reopen
    sudo mysqladmin flush-logs

    # 各種サービスの再起動
    echo
    echo "<==== RESTART SERVICES ====>"
    sudo systemctl restart mysql
    sudo systemctl restart web-ruby
    sudo systemctl restart nginx

    sleep 5

    # ベンチマークの実行
    echo
    echo "<==== BENCHMARK        ====>"
    cd ${HOME}
    ./bench/bench --target-url "${TARGET_IP}"

    # alp, pt-query-digest で解析
    echo
    echo "<==== ACCESS LOG       ====>"
    sudo cat /var/log/nginx/access.log | alp ltsv -m "/api/schedules/[0-9a-zA-Z]+" --sort avg -r | tee alp_$(date +%Y%m%d-%H%M%S).txt
    sudo pt-query-digest /var/log/mysql/mysql-slow.log | tee digest_$(date +%Y%m%d-%H%M%S).txt
}

main | tee restart-and-bench.txt
