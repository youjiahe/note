#!/bin/bash
#Nginx
wget ftp://192.168.4.254/share/lnmp_soft.tar.gz &>/dev/null
echo -e "\033[32m Lnmp_soft.tar下载完成[OK]\033[0m"
echo -e "\033[32m 正在安装nginx........[OK]\033[0m"
tar -xf /root/lnmp_soft.tar.gz
cd  /root/lnmp_soft/
useradd -s /sbin/nologin nginx &>/dev/null
tar -xf nginx-1.12.2.tar.gz &>/dev/null
cd nginx-1.12.2/
yum -y install gcc pcre-devel openssl-devel &>/dev/null
./configure  --with-http_ssl_module --with-stream --with-http_stub_status_module --without-http_autoindex_module --without-http_ssi_module &>/dev/null

make &>/dev/null  && make install &>/dev/null
ln -s /usr/local/nginx/sbin/nginx /bin/
nginx
netstat -utanlp | grep nginx &>/dev/null
[ $? -eq 0 ] && echo -e "\033[32m nginx安装并启动完成...... [OK]\033[0m"

#LNMP_INSTALL
cd  /root/lnmp_soft/

yum -y install php php-mysql php-fpm-5.4.16-42.el7.x86_64.rpm &>/dev/null
echo -e "\033[32m php php-mysql php-fpm安装完成[OK]\033[0m"
\cp  /usr/local/nginx/conf/nginx.conf.default /usr/local/nginx/conf/nginx.conf 
sed -i '65,71s/#//;70s/_params/\.conf/;69d' /usr/local/nginx/conf/nginx.conf
/usr/local/nginx/sbin/nginx -s reload

if [ $1 == "-m" ];then 
   yum -y install mariadb mariadb-server mariadb-devel &>/dev/null
   systemctl restart mariadb
   netstat -utanlp | grep :3306 &>/dev/null
   [ $? -eq 0 ] && echo -e "\033[32m mariadb安装并启动完成...... [OK]\033[0m"
fi

systemctl restart php-fpm  
echo '<?php
$i=99;
echo $i;
echo "\n";
?>' > /usr/local/nginx/html/index.php
curl -s localhost/index.php

