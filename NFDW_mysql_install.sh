#!/bin/bash
MYSQL_RPM_DIR=$1
MYSQL_DIR="/data/mysql_data/mysql"
######################################################
#删除冲突包
rpm -qa | egrep -i  "(mariadb|mysql|postfix)"  | xargs -i rpm -ev --nodeps {}

#添加mysql用户
useradd -r mysql &>/dev/null

#判断mysql的rpm包目录是否给定/存在
if [ $# -ne 1 ]; then
    echo "$0 <MYSQL_RPM_DIR>"
    exit 1
elif [ ! -d ${MYSQL_RPM_DIR} ]; then
    echo "${MYSQL_RPM_DIR} 不存在"
    exit 2
fi

#安装mysql
     yum -y install perl-JSON  perl-Data-Dumper.x86_64 net-tools
     [ -f /etc/my.cnf ] && \cp /etc/my.cnf{,.bak}  && rm -rf /etc/my.cnf
     rpm -ivh ${MYSQL_RPM_DIR}/mysql-community-common-5.7.24-1.el7.x86_64.rpm  
     rpm -ivh ${MYSQL_RPM_DIR}/mysql-community-libs-5.7.24-1.el7.x86_64.rpm 
     rpm -ivh ${MYSQL_RPM_DIR}/mysql-community-client-5.7.24-1.el7.x86_64.rpm 
     rpm -ivh ${MYSQL_RPM_DIR}/mysql-community-server-5.7.24-1.el7.x86_64.rpm

#修改数据库根目录,并且创建该目录
     rm -rf ${MYSQL_DIR} &>/dev/null
     sed -i "/^datadir/s:/var/lib/mysql:${MYSQL_DIR}:"  /etc/my.cnf
     sed -i "/^socket/s:/var/lib/:/data/mysql_data/:"  /etc/my.cnf
     echo "
[client]
default-character-set=utf8
socket=${MYSQL_DIR}/mysql.sock

[mysql]
default-character-set=utf8
socket=${MYSQL_DIR}/mysql.sock
"  >> /etc/my.cnf  
     [ ! -d ${MYSQL_DIR} ]  && mkdir -p ${MYSQL_DIR}
     [ -d ${MYSQL_DIR} ]  && chown -R mysql.mysql ${MYSQL_DIR}

#启动mysql，并且修改密码
     mysqld --initialize --user=mysql

     systemctl restart mysqld
     systemctl enable mysqld
     TMP_PASS=`grep "temp.* password" /var/log/mysqld.log  | tail -1 | sed -r 's/([0-9].*:)\s(.*)/\2/'`
     mysql -uroot -p${TMP_PASS} -e "alter user root@localhost identified by 'NFDWpassword123$'" --connect-expired-password  &>/dev/null

     [ $? -eq  0 ] && echo -e "\033[32;1m mysql安装完成 \033[0m"
