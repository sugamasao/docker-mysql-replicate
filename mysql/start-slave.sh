# #!/bin/sh

# 検証用途なので以下の点を割り切っている
# MySQL本体はMYSQL_ALLOW_EMPTY_PASSWORDを許可し、パスワードなしrootログイン可能
# slaveの同期は本来masterのロックなども考慮すべきだが、dockerで同時に起動するので厳密な同期は考慮しない

MASTER_HOST=mysql_master

# depends_onでは不十分なので繋がるまで待つ
while ! mysqladmin ping -h ${MASTER_HOST} --silent; do
  sleep 1
done

# masterからレプリケーション用のポジションを取得
BIN_LOG=`mysql -u root -h ${MASTER_HOST} -e "SHOW MASTER STATUS\G" | grep File: | awk '{print $2}'`
POSITION=`mysql -u root -h ${MASTER_HOST} -e "SHOW MASTER STATUS\G" | grep Position: | awk '{print $2}'`

# SLAVE設定
mysql -u root -e "RESET SLAVE";
mysql -u root -e "CHANGE MASTER TO MASTER_HOST='${MASTER_HOST}', MASTER_USER='root', MASTER_PASSWORD='', MASTER_LOG_FILE='${BIN_LOG}', MASTER_LOG_POS=${POSITION};"
mysql -u root -e "START SLAVE"
