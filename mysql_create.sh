#!/bin/bash
yum -y install perl-JSON 
rpm -qa | grep mysql-community-

if [ $? -ne 0 ];then
[ ! -e mysql-community-server-5.7.17-1.el7.x86_64.rpm ] && tar -xf /root/mysql-5.7.17.tar
rpm -Uvh mysql-community-*.rpm
fi

systemctl status mysqld | grep "active (running)"
[ $? -eq 0 ] && systemctl stop mysqld

msq_l=`awk '/\[mysqld\]/{print NR}' /etc/my.cnf`
cmt_l=`awk '/^#$/{print NR}' /etc/my.cnf | head -1`
if [ -d /var/lib/mysql ]; then 
    rm -rf /var/lib/mysql
    start=$[$msq_l+1]
    stop=$[$cmt_l-1]
    [ $start -le $stop ] && sed -i "${start},${stop}d" /etc/my.cnf
fi

systemctl restart mysqld
sed -i '/\[mysqld\]/a validate_password_length=6' /etc/my.cnf
sed -i '/\[mysqld\]/a validate_password_policy=0' /etc/my.cnf
systemctl restart mysqld
systemctl enable  mysqld
pass=`grep "tem.* password" /var/log/mysqld.log  |sort -n | awk '{print $NF}' |tail -1`
echo "alter user root@localhost identified by '123456';" | mysql -uroot -p$pass --connect-expired-password
mysql -u root -p123456
