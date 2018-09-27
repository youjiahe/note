 ##############################################
Http服务基础

基于B/S	架构的网页服务
-服务端提供网页
-浏览器下载并显示网页

HTML
HTTP
Ddos

1.装包 httpd
2.配置 
虚拟机server0：
网页全局主配置文件：/etc/httpd/conf/httpd.conf

（1）配置网站域名
Servername:本站点注册的DNS名称
主配文件修改ServerName server0.example.com:80[端口号不由这里决定，是Listen决定]

（2）修改网页默认目录配置文件
DocumentRoot:网页文件根目录[理解为网页的起点] 如更改为/var/www/myweb
Firefox server0..example.com/pub [可以到达网页文件根目录下的/pub，
也就是/var/www/myweb/pub] 
 
（3）Listen监听地址端口：（默认80，一般不改）
（4）directoryIndex：起始页/文件名（默认index.html，一般不改)

 #############################################
虚拟Web主机
      作用：由同一个服务器提供多个不同的Web站点

区分方式（构建方式）----------重点
-基于域名的
-基于端口的
-基于IP地址的

 ##############################################
四、搭建基于域名的虚拟Web主机
配置文件
方法一：修改主配置文件：/etc/httpd/conf/*.conf（行数300容易改错，也会影响主配置文件打开速度）
方法二：调用配置文件：/etc/httpd/conf.d/*conf（可以保持主配置文件的完整性，简洁性，日后维护也比较简单）

<VirtualHost IP地址：端口号>
ServerName 此站点的DNS名称
DocumentRoot 此站点的网页根目录
</VIrtualHost>

注意事项：
一旦使用虚拟Web主机，
主配置文件中ServerName与DocumentRoot失效
所有站点都必须使用虚拟Web主机来完成

 #############################################
五、配置网页访问控制
使用<Directory>配置区段
-每个文件夹自动继承父目录权限
-

1.新建调用配置文件
<Directory /var/www/myweb/private>
Require ip 172.25.0.11 #只允许172.25.0.11访问
</Directory>

补充：
[Require all denied  #允许所有
Require all granted #拒绝所有]   

2.起服务httpd
3.验证

补充：
vimdiff        #对比两个文件一致性
killall  httpd  #杀死进程
Ls -Z   看文件的标识（安全上下文值）

 #############################################
六、使用自定根目录
1.新建目录
2.修改虚拟web主机配置文件，以新建目录作为网页根目录
3.修改访问控制配置文件，把新建目录改为允许所有
4.起服务
5.SELinux策略，安全上下文值（标识）
  ---为所有重点的文件路径都做了标识
  ---除非针对子目录有明确设置

  需要给新建目录打上与默认目录/var/www相同的标记
 [chcon -R  --reference=/var/www /webroot]
 

 #############################################
七、部署动态网站
静态网页
服务端的原始网页=浏览器访问到的网页
--用简单语言写成的网页，html网页，txt网页，png
--httpd直接把网页传给浏览器

动态页面
服务端的原始网页！=浏览器访问到的网页
--用专业网站语言写的，如PHP网页，Python网页、JSP网页
--需要httpd翻译再传给浏览器

步骤：
虚拟机server0：
1.部署python页面

2.方便用户的访问，页面跳转
  在虚拟Web主机配置文件中加上网站跳转指令
<VirtualHost *:80>
ServerName webapp0.example.com
DocumentRoot /var/www/nsd02
alias / /var/www/nsd02/webinfo.wsgi[
当客户端访问网页文件根目录时，实现页面跳转，将webinfo.wsgi呈现]
</VirtualHost>

3.重启服务

4.装包翻译
mod_wsgi[负责解析python页面的代码]
5.修改虚拟web主机配置文件，实现http进行翻译
加上一行
wsgiScriptAlias / /var/www/nsd02/webinfo.wsgi

6.重启httpd服务

UNIX时间戳：自1970-1-1算起，到达现在经历的秒数

补充：
7.修改虚拟主机侦听在端口8909
8.SELinux策略[
1.布尔值：影响服务的权限
2.安全上下文，影响目录，文件的访问
3.非默认端口开放，]（修改非默认端口开放）
  查看http端口：semanage port -l | grep http
  添加http端口：semanage port -a -t http_port_t -p tcp 8909[
-a: 添加；
-t：类型
-p：协议]
