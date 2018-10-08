#!/bin/bash
wget ftp://192.168.4.254/share/lnmp_soft.tar.gz
tar -xf /root/lnmp_soft.tar.gz
cd  /root/lnmp_soft/
useradd -s /sbin/nologin nginx
tar -xf nginx-1.12.2.tar.gz
cd nginx-1.12.2/
yum -y install gcc pcre-devel openssl-devel
./configure  --with-http_ssl_module --with-stream --with-http_stub_status_module
make && make install
ln -s /usr/local/nginx/sbin/nginx /bin/
nginx
netstat -utanlp | grep nginx
