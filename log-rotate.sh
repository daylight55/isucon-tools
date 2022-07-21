#!/bin/bash
set -xe

ISUCON_1_HOST=${1:-isu11-2}
# ISUCON_2_HOST=${2:-isu-2}
# ISUCON_3_HOST=${3:-isu-3}

for remote in ${ISUCON_1_HOST}; do
  echo "Logrotate to ${remote}"
  
done
