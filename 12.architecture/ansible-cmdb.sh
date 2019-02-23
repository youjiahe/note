wget https://github.com/fboender/ansible-cmdb/releases/download/1.17/ansible-cmdb-1.17.tar.gz
tar zxf ansible-cmdb-1.17.tar.gz 
cd ansible-cmdb-1.17
make install
ansible all -m setup --tree out/ 
yum -y install httpd
systemctl restart httpd
systemctl enable httpd

while 1>0
do
      ansible-cmdb out/ > /var/www/html/monitor.html
      sleep 30
done 
