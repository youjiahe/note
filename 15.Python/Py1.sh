Python自动化运维 day01
1.教学支持、坚持
2.课程安排
   2.1 python开发入门
   2.2 python开发进阶
    2.3 运维开发实战
   2.4 web开发实战
3.鸡血
4.python简介
   4.1 环境
   4.2 pycharm
5.git
6.python运行方式
7.Python语法结构
8.语句
  8.1 print
  8.2 input
##############################################################################
开班
●教学支持
  616720276 QQ群
●坚持
  1.每天500行
  2.分清主次
  3.多动手
●老师:
  石博文： 1311794174 #QQ
  教学群： 616720276 
##############################################################################
python简介
●python起源
Guido van Rossum 作者  1991年

●python版本 
  python2.X 目前所有系统默认支持的版本
  python3.X 
  — 2009年发布
  — 语法有较大的调整
  — python的发展趋势
  — 学习python3.6.1稳定版
  
●为什么要学python
  — 高级：有高级的数据结构，缩短开发时间与代码量，非常的简洁；
  — 面向对象：为数据和逻辑相分离的结构化和过程编程添加了新的活力
  — 可升级：提供了基本的开发模块，可以在他的上面开发软件，实现代码重用
  — 可扩展：通过将其分离为多个文件或模块加以组织管理

●python网站
 https://www.python.org/

##############################################################################
设置pycharm  #教学环境默认有
● Pycharm是由JetBrains打造的一款Python IDE
● 支持的功能有:
–  调试、语法高亮
–  Project管理、代码跳转
–  智能提示、自动完成
–  单元测试、版本控制
● 下载地址:https://www.jetbrains.com/pycharm/download

● 使用pycharm
打开pycharm
选择create new project
在左上角找到file-----setting----editor
找到editor——font——size
解释器editor—project——project interpreter
左侧小齿轮Add local
选择虚拟环境 /usr/local/bin/python3.6  添加3.6
##############################################################################
环境准备
案例1:准备python开发环境
1.  下载最新版本的python3
2.  下载pycharm社区版
3.  安装python3,使其支持Tab键补全
4.  配置pycharm,使其符合自己的习惯
##############################################################################
git #老师用这个来共享代码
● 案例2:配置git
1.  安装git版本控制软件
2.  设置用户信息,如用户名、email等
3.  设置默认编辑器为vim
4.  查看用户配置
##############################################################################
git 客户端使用
● 命令汇总
git config --global user.name "youjiahe"
git config --global user.email "youjiahe@163.com"
git config --global core.editor vim
git config --list
git init
git add <files> /git add . /git add --all
git status .
git commit -m "first_commit"
git commit -am "first_commit"   #先add，再commit
git ls-files
git rm <files>  #删除版本库文件
git remote rename origin old-origin
git remote remove origin
git remote add origin git@192.168.4.1:nsd1806/core_py.git
git push -u origin --all
git clone git@192.168.4.1:nsd1806/core_py.git
git pull
##############################################################################
git 客户端使用
● git pull 与 git clone 的区别
//clone 是本地没有 repository 时，将远程 repository 整个下载过来。
//pull 是本地有 repository 时，将远程 repository 里新的 commit 数据(如有的话)下载过来。
##############################################################################
git 客户端使用
● git常见问题
1.权限问题
  chmod 600 id_rsa
2.host解析问题
   git remote add origin git@192.168.4.1:/nsd1806/core_py.git
3.将密钥交给代理
   ssh-agent   #下面有命令解析
   ssh-add  
##############################################################################
● git config -global
[root@room9pc01 ~]# git config --global user.name "youjiahe"
[root@room9pc01 ~]# git config --global user.email "youjiahe@163.com"
[root@room9pc01 ~]# git config --global core.editor vim
[root@room9pc01 ~]# git config --list
user.name=youjiahe
user.email=youjiahe@163.com
core.editor=vim
[root@room9pc01 tedu]# cat ~/.gitconfig
[user]
	name = youjiahe
	email = youjiahe@163.com
[core]
	editor = vim
	
##############################################################################
git
•  工作区:就是你在电脑里能看到的目录
•  暂存区:英文叫stage, 或index。一般存放在 ".git目
   录下" 下的index文件(.git/index)中,所以我们把
    暂存区有时也叫作索引(index)
•  版本库:工作区有一个隐藏目录.git,这个不算工作
   区,而是Git的版本库

##############################################################################
● git使用
& 创建自己的版本库
[root@room9pc01 python]# mkdir youjiahe
[root@room9pc01 python]# cd youjiahe
[root@room9pc01 py01]# git init
初始化空的 Git 版本库于 /root/tedu/youjiahe/.git/

& 创建脚本并且添加到暂存区
[root@room9pc01 py01]# echo "print('hello world')" > hello.py
[root@room9pc01 py01]# git add hello.py  #git add --all/ git add .
[root@room9pc01 py01]# git status .
[root@room9pc01 py01]# echo "print('welcome')" > welcome.py
[root@room9pc01 py01]# ls
hello.py  welcome.py
[root@room9pc01 py01]# git add .
[root@room9pc01 py01]# git status -s  # A-新增文件  D-本地删除文件
A  hello.py
A  welcome.py  

& 把暂存区的文件提交到版本库中
[root@room9pc01 py01]# git commit -m "first_commit"
[master（根提交） ae8ae41] first_commit
 2 files changed, 2 insertions(+)
 create mode 100644 hello.py
 create mode 100644 welcome.py

& 更新文件提交到版本库
[root@room9pc01 py01]# echo "print('Python day1')" > hello.py
[root@room9pc01 py01]# git commit -am 'first_commit'
[master 39d8558] first_commit
 1 file changed, 1 insertion(+), 1 deletion(-)

& 查看版本库文件
[root@room9pc01 py01]# git ls-files
hello.py
welcome.py

& 删除版本库文件
[root@room9pc01 py01]# git rm welcome.py
[root@room9pc01 py01]# git status
[root@room9pc01 py01]# git commit -m "rm test file"
[root@room9pc01 py01]# git ls-files
hello.py

##############################################################################
搭建gitlab 服务端
环境准备
● 准备一台虚拟机 4G内存 40G硬盘
& 装包
[root@python_git docker_pkgs]# ls  #老师提供
[root@python_git docker_pkgs]# yum -y install *.rpm

& 导入镜像
[root@python_git images]# systemctl restart docker
[root@python_git images]# docker load < gitlab_zh.tar
[root@python_git images]# docker images

&修改ssh端口，非22就行
[root@python_git ~]# vim /etc/ssh/sshd_config #修改22为2222
[root@python_git ~]# systemctl restart sshd
##############################################################################
Gitlab启动
●将docker主机ssh端口改为2222后,起动容器
[root@python_git ~]# docker run -d -h gitlab \
--name gitlab \
-p 443:443 -p 80:80 -p 22:22 \
--restart always \
-v /srv/gitlab/config:/etc/gitlab \
-v /srv/gitlab/logs:/var/log/gitlab \
-v /srv/gitlab/data gitlab_zh:latest

//--name gitlab:主机名
//--restart always:容器故障自动充气

●浏览器浏览虚拟机IP
firefox 192.168.4.1  #会看到"GitLab 中文社区版"

●密码大于8位，用root登陆、创建群组、创建项目、创建用户、添加用户到组
##############################################################################
git
推送文件到远程  #有密码
●创建远程仓库
[root@room9pc01 youjiahe]# git remote rename origin old-origin 
error: 不能重命名配置小节 'remote.origin' 到 'remote.old-origin'  #不用管
[root@room9pc01 youjiahe]# git remote add origin http://192.168.4.1/nsd1806/core_py.git
 
●往刚刚创建的项目中推送文件
[root@room9pc01 youjiahe]# git push -u origin --all
Username for 'http://192.168.4.1': root                           do
Password for 'http://root@192.168.4.1':                          do

●回到浏览器项目页面查看内容
 可以看到仓库文件
##############################################################################
git
推送文件到远程准备  #无密码
●ssh免密钥登陆
 粘贴密钥到设置----ssh密钥

●回到真机
[root@room9pc01 youjiahe]# ssh-agent   #启动ssh代理程序
[root@room9pc01 youjiahe]# ssh-add     #添加私钥，让代理程序托管

//ssh-agent 用于管理 ssh private keys，目的是对解密的私钥进行高速缓存。 
//ssh-add 提示并将用户使用的私钥添加到 ssh-agent 维护列表中，此后当公钥连接到远程 SSH 或 SCP 主机时，不再提示信息。
//ssh-add 命令是把专用密钥添加到ssh-agent的高速缓存中。该命令位置在/usr/bin/ssh-add。

●管理区域(小扳手)----project-----选一个项目
   可以看到多了 ssh一行

●无密码方式推送文件
[root@room9pc01 youjiahe]# git remote remove origin #
[root@room9pc01 youjiahe]# git remote add origin git@192.168.4.1:nsd1806/core_py.git
[root@room9pc01 youjiahe]# cp /etc/hosts .
[root@room9pc01 youjiahe]# git add .
[root@room9pc01 youjiahe]# git status
[root@room9pc01 youjiahe]# git commit -m "add files"
[root@room9pc01 youjiahe]# git push origin master
##############################################################################
git
●从远程仓库下载本机
[root@room9pc01 tedu]# rm -rf youjiahe/
[root@room9pc01 tedu]# git clone git@192.168.4.1:nsd1806/core_py.git
##############################################################################
Python运行方式
● 解释器
  & python   #python2
  & python3  #python3
● 运行方式  
  & 进入解释器
    [root@room9pc01 python]# python3  # exit() 、ctrl+d都可以推出
    Python 3.6.1 (default, Mar 20 2018, 00:12:35)
    >>> print('hello world')  
  & 命令行运行  
   [root@room9pc01 core_py]# python3 print.py 
    hello world  
  & 文件指定解释器运行
    [root@room9pc01 core_py]# cat ./print.py
     #!/usr/bin/env python3
     print('hello world')
    [root@room9pc01 core_py]# chmod +x print.py   #给
    [root@room9pc01 core_py]# ./print.py        
    hello world    
############################################################################## 
Python语法结构
1.语法块缩进
  –  4个空格:非常流行, 范·罗萨姆支持的风格  #可读性
2.注释及续行
  #   #“#”为注释
  \   #续行符，解释时视为同一行
3.同行多个语句
  ；  #用“；”分隔
############################################################################## 
● print语句
print(values,...,sep=' ',end='\n')
//sep是两个值间的值
//end是最后一个值后添加的字符串

● input语句
//作用：提示字符串；在提示字符串后写要输入的内容
//可以使用变量接收内容
##############################################################################
案例5:模拟用户登陆
1.  创建名为login.py的程序文件
2.  程序提示用户输入用户名
3.  用户输入用户名后,打印欢迎用户

































