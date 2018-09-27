NGINX搭建：
 #########################################
步骤1：
装基础包：gcc,pcre-devel,openssl-devel
gcc:C语言编译器
pcre-devel:devel结尾的都是依赖包

 ############################################
步骤2：
创建用户：useradd -s /sbin/nologin nginx  
#为的是安全，root启动的nginx,可是系统会自动降级为创建的用户。

root
rwx
vsftp,httpd,nginx[共享]
root启动的程序，Liunx会自动把root降级为普通用户，具体是哪个，看装的是哪个包
 #############################################
步骤3：
源码包安装
./configure \
> --prefix=/usr/local/nginx \
> --user=nginx \
> --group=nginx \
> --with-http_ssl_mod当忘记后如下处理：
[root@proxy nginx-1.10.3]# ./configure --help | grep ssl
#常用模块
#--with-http_ssl_module \ --with-http_stub_status_module \
#--with-stream \ --without-http_ssi_module \ --without-http_autoindex_module
   ############################################
步骤4：启动服务
/usr/local/nginx/sbin/nginx   //启动服务
/usr/local/nginx/sbin/nginx -s stop //停止服务
/usr/local/nginx/sbin/nginx -s reload //不关服务的情况下，重新加载配置文件
/usr/local/nginx/sbin/nginx -V //查看nginx版本
  ###########################################
步骤5：查看nginx服务状态

netstat -antulp | grep nginx   #netstat 查看所有启动的端口[
一个端口只能给一个软件使用]状态
-a：查看所有服务端口
-n：查看端口，数字形式
-t：查看所有TCP端口
-u：查看所有UDP端口
-l：只查看服务正在监听的端口
-p：查看正在使用该服务的程序（program）

  ##########################################
NGINX升级：
 #############################################
1.10
/usr/local/nginx/
  html/  conf/  logs/   sbin/
升级，只需要升级/usr/local/nginx/sbin下的nginx程序


nginx-1.12.2/src 放源代码
现代化软件：模块化设计

cd nginx-1.12.2/
1）./configure  
   目录nginx-1.12.2/会出现objs目录，这个目录下有src，都是C源代码
2）make（一定不要make install，要不然会覆盖掉原来的html conf objs）
3）备份原来的/usr/local/nginx/sbin/nginx
4）更新nginx，把/root/lnmp_soft/nginx-1.12.2/objs/nginx 复制到安装目录下的sbin
5）killall nginx 
6）make upgrade  #可执行可不执行

nginx不要装rpm包，因为不能自己选择功能模块

 ############################################
基本web
了解全局配置（用户，日志，进程，并发量）
http{
server{                         #一个server一个虚拟主机
       listen 80;
       server_name www.example.com;
       root html;                #这里是相对路径，可以写绝对路径
      }           
}

 ############################################
用户认证
步骤1：
server{
       listen 80;
       server_name localhost;      
       auth_basic “Input Password”;    #””里面不能打中文
       auth_basic_user_file “/usr/local/nginx/pass”;    #文件名可以自定义

步骤2：
 htpassword -c 路径 用户
 
 ##########################################
虚拟web主机（1台服务器，1个软件，多个网站）
创建一个基于域名的虚拟主机

扩展其他虚拟主机：
1.基于端口的虚拟主机（参考模板）
server {
        listen       8080;              //端口
        server_name  web1.example.com;          //域名
        ......
}
    server {
        listen       8000;
        server_name  web1.example.com;
      .......
}
2.基于IP的虚拟主机（参考模板）
server {
        listen       192.168.0.1:80;          //端口
        server_name  web1.example.com;          //域名
  ... ...
}
    server {
        listen       192.168.0.2:80;
        server_name  web1.example.com;
... ...
}

补充：  
vim 
ctrl + v 键盘下键 -------->全选操作
x------------------------------->删除



