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
5. git

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
  — 学习python3.7.1稳定版
  
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
git
● 案例2:配置git
1.  安装git版本控制软件
2.  设置用户信息,如用户名、email等
3.  设置默认编辑器为vim
4.  查看用户配置

● 老师的git
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
git 客户端使用
● 命令
git init
git add <files> /git add . /git add --all
git status .
git commit -m "first_commit"
git commit -am "first_commit"   #先add，再commit
git ls-files
git rm <files>  #删除版本库文件


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
git 服务端





























