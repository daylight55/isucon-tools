#!/bin/bash

sudo mv /var/log/nginx/access.log /var/log/nginx/access.log.`date +%Y%m%d-%H%M%S`
sudo rm /var/log/mysql/mysql-slow.log
sudo nginx -s reopen
sudo mysqladmin flush-logs
