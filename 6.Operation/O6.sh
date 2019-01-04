###############################################################################
Subversion
SVN版本控制
●自由开原的版本控制软件
●运维：shell代码、配置文件[100]、标准化
共享目录/仓库
client<-------->svnserve/apache/nginx<------->repository

●svn
file://
ftp://
http://

●ftp模型
锁定-修改-解锁的问题
--不必要的串行，效率低

●SVN模型
拷贝-修改-合并
--拷贝,自动建立副本
--并行工作
--合并版本
--个别冲突问题（都改了同一行），需要人为解决
######################################################################################
●搭建svn仓库
步骤1：装包subversion

步骤2：创建仓库
[root@web1 ~]# mkdir /var/svn
[root@web1 ~]# svn
svn            svndumpfilter  svnrdump       svnsync        
svnadmin       svnlook        svnserve       svnversion     
[root@web1 ~]# svnadmin create /var/svn/443A
[root@web1 ~]# ls /var/svn/443A
conf  db  format  hooks  locks  README.txt

步骤3：本地导入初始化数据
--导入的数据不是明文的
--判断仓库目录大小，仓库是否变了
cd /usr/lib/systemd/system
svn import . file:///var/svn/443A/ -m "I am king"

步骤4：修改配置文件
●conf/svnserve.conf
PS：1.定格写，不能有空格；2.改4行
//19行 匿名无权限 read---->none
//20行 有效帐号可写（包含可读）
//27行 指定密码文件
//34行 打开acl访问控制列表
●conf/passwd     #设定用户密码
[users]
tom = 1
harry = 1
●conf/authz    #定义ACL访问控制
[/]
harry = rw
tom = rw

步骤5：起服务
svnserve -d -r /var/svn/443A
ss -utanlp | grep svn  #看到3690端口

####################################################################################
●客户机测试
1）将服务器上的代码下载到本地
[root@web2 ~]# cd /tmp
[root@web2 ~]# svn --username harry --password 123456 \
co svn://192.168.2.100/ code        
//建立本地副本,从服务器192.168.2.100上co下载代码到本地code目录
//用户名harry,密码123456

2）更改文件并上传
cd /root/code
vim 文件名                          //挑选任意文件修改其内容
svn commit -m "I am King"    //将本地修改的数据同步到服务器
svn update                   //将服务器上新的数据同步到本地

3)仓库信息
svn info svn://192.168.2.100    //查看版本仓库基本信息
svn log svn://192.168.2.100     //查看版本仓库的日志，改动信息

4）添加文件,上传
[root@web2 code]# echo "test" > test.sh        //本地新建一个文件
[root@web2 code]# svn ci -m "new file"            //提交失败，该文件不被svn管理
[root@web2 code]# svn add test.sh                //将文件或目录加入版本控制
[root@web2 code]# svn ci -m "new file"            //再次提交，成功

5）其他操作
svn mkdir subdir                //创建子目录
svn rm timers.target            //使用svn删除文件
svn cat svn://192.168.2.100/user.list

6）数据恢复
rm -rf 文件  ------------> svn update
sed -i 'd' 文件 ---------------> svn revert 文件

sed -i  '7a #9999999999' user.slice-------->svn ci -m "xx" 
-------->svn merge -r8:1 user.slice #从最新的版本号8，还原回版本1

#####################################################################################
●多人协同工作

●修改不同文件
[root@web1 mycode]# sed -i "3a ###harry modify#####"  tmp.mount
[root@web1 mycode]# svn ci -m  "has modified"

root@web2 mycode]# sed -i "3a ###tom modify#####"  umount.target
[root@web2 mycode]# svn ci -m "has modified"

[root@web2 mycode]# svn update
[root@web1 mycode]# svn update

●修改相同文件，不同行
[root@srv5 ~]# cd harry
[root@web1 mycode]# sed -i "3a ###harry modify#####" user.slice
[root@web1 mycode]# svn ci -m  "modified"
[root@web2 mycode]# sed -i "6a ###tom  modify#####"  user.slice
[root@web2 mycode]# svn ci -m "modified"        //提交失败
Sending        svnserve
Transmitting file data .svn: Commit failed (details follow):
svn: File '/user.slice' is out of date（过期）
[root@web2 mycode]# svn update                    //提示失败后，先更新再提交即可
[root@web2 mycode]# svn ci -m "modified"        //提交成功
Sending        user.slice
Transmitting file data .

●修改相同文件，相同行
[root@web1 mycode]# sed  -i  '1c [UNIT]' tuned.service
[root@web1 mycode]# svn ci -m "modified"
[root@web2 mycode]# sed  -i  '1c [unit]' tuned.service
[root@web2 mycode]# svn ci -m "modified"
Sending        tuned.service
Transmitting file data .svn: Commit failed (details follow):
svn: File '/tuned.service' is out of date(过期)
[root@web2 mycode]# svn update                    //出现冲突，需要解决
Conflict discovered in 'tuned.service'.
Select: (p) postpone, (df) diff-full, (e) edit,
        (mc) mine-conflict, (tc) theirs-conflict,
        (s) show all options:p                    //选择先标记p，随后解决
[root@web2 mycode]# ls
tuned.service   tuned.service.mine        tuned.service.r10    tuned.service.r9
[root@web2 mycode]# mv tuned.service.mine tuned.service
[root@web2 mycode]# rm -rf tuned.service.r10 tuned.service.r9
[root@web2 mycode]# svn ci -m "modified"    //解决冲突

#######################################################################################
●备份数据,还原备份数据
dump，load
[root@web1 ~]# svnadmin dump /var/svn/project > project.bak  //备份
[root@web1 ~]# svnadmin create /var/svn/project2               //新建空仓库
[root@web1 ~]# svnadmin load /var/svn/project2 < project.bak      //还原

●还原到指定版本
[root@vm1 conf]# svn update -r 1
正在升级 '.':
.. ..
更新到版本 1。
#######################################################################################
●注册使用github
git clone https://github.com/redhatedu/courese
#clone指令用于将服务器仓库中的资料打包下载到本地
cd 仓库名称
git init
git remote add origin https://github.com/youjiahe/mynote.git
git commit -m "test"
git push
#commit和push实现提交代码的功能
git pull
#pull更新，类似于svn update
#####################################################################################
RPM

rpm -ivh #
rpm -qf  #查看某些文件，目录是出自哪个软件包
rpm -qa  #查看已经安装的包
rpm -qi  #查看软件包信息
rpm -ql  #查看改软件包包含哪些文件目录
rpm -e   #
rpm -qc  #查看软件包的配置文件

●源码------>RPM （用工具）
  --压缩包    #把源码编译好的结果文件目录 打包 
  --描述信息
●yumdownloader httpd  #下来httpd rpm包

实现:
1)装包rpm-bulid
2)放源码
[root@web1 ~]# rpmbuild -ba xx.spec0000
[root@web1 ~]# ls rpmbuild/
BUILD  BUILDROOT  RPMS  SOURCES  SPECS  SRPMS
#SOURCES 放源码包(tar包)，RPMS 放rpm结果，
#SPECS人为操作 
3）修改配置文件
vim nginx.spec,根据内容填写
------------------------------------------
Name:nginx        
Version:1.12.2
Release:    10
Summary: Nginx is a web server software.    
License:GPL    
URL:    www.test.com    
Source0:nginx-1.12.2.tar.gz
#BuildRequires:    
#Requires:    
%description
nginx [engine x] is an HTTP and reverse proxy server.
%post
useradd nginx                       //非必需操作：安装后脚本(创建账户)
%prep
%setup –q                            //自动解压源码包，并cd进入目录
%build
./configure
make %{?_smp_mflags}
%install
make install DESTDIR=%{buildroot}
cp /root/rpmbuild/SPECS/nginx.sh %{buildroot}/usr/local/nginx/    
##注意，cp非必须操作，注意，这里是将一个脚本拷贝到安装目录，必须提前准备该文件
%files
%doc
/usr/local/nginx/*            //对哪些文件与目录打包
%changelog
--------------------------------------------------------------------

4)安装依赖包
   [root@web1 ~]# yum -y install  gcc  pcre-devel zlib-devel openssl-devel

5）rpmbuild创建RPM软件包
  [root@web1 ~]# rpmbuild -ba /root/rpmbuild/SPECS/nginx.spec
  [root@web1 ~]# ls /root/rpmbuild/RPMS/x86_64/nginx-1.12.2-10.x86_64.rpm
  [root@web1 ~]# rpm -qpi RPMS/x86_64/nginx-1.12.2-10.x86_64.rpm 

6)[root@web1 ~]# rpm -qpl nginx-1.12.2-10.x86_64.rpm
































