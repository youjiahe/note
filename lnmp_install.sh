#!/bin/bash
#Nginx
wget ftp://192.168.4.254/share/lnmp_soft.tar.gz
tar -xf /root/lnmp_soft.tar.gz
cd  /root/lnmp_soft/
useradd -s /sbin/nologin nginx
tar -xf nginx-1.12.2.tar.gz
cd nginx-1.12.2/
yum -y install gcc pcre-devel openssl-devel
./configure  --with-http_ssl_module --with-stream --with-http_stub_status_module --without-http_autoindex_module --without-http_ssi_module
make && make install
ln -s /usr/local/nginx/sbin/nginx /bin/
nginx
netstat -utanlp | grep nginx
#LNMP_INSTALL
cd  /root/lnmp_soft/
yum -y install php php-mysql php-fpm-5.4.16-42.el7.x86_64.rpm 
sed -i '65,71s/#//;70s/_params/\.conf/;69d' /usr/local/nginx/conf/nginx.conf
/usr/local/nginx/sbin/nginx -s reload
systemctl restart php-fpm
echo '<?php
$i=99;
echo $i;
echo "\n";
?>' > /usr/local/nginx/html/index.php
curl localhost/index.php

