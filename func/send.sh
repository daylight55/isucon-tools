#!/bin/bash
SCRIPT_DIR=$(cd $(dirname $0);pwd)

remote=$1

# Github接続用の秘密鍵を送る
scp ${GITHUB_PRIV_KEY_PATH} ${remote}:~/.ssh/
# .ssh/configを送る
scp ${SCRIPT_DIR}/../.ssh/remote-config ${remote}:~/.ssh/config
