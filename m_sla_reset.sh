#!/bin/bash
id=${HOSTNAME##*[a-Z]}
sed -i "/^server_id/d" /etc/my.cnf
sed -i "/\[mysqld\]/a server_id=$id" /etc/my.cnf
systemctl restart mysqld

mysql -uroot -p123456 -e "stop slave;"
mysql -uroot -p123456 -e "reset slave;"
mysql -uroot -p123456 -e "change master to master_host=\"$1\",master_user=\"repluser\",master_password=\"123456\",master_log_file=\"$2\",master_log_pos=$3;"
mysql -uroot -p123456 -e "start slave;"
mysql -uroot -p123456 -e "show slave status\G;" | grep -i yes
