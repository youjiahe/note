运维开发实战
NSD DEVOPS DAY05
1.Jenkins
##################################################################################
●Jenkins概述
	•  Jenkins是由java编写的一款开源软件
	•  作为一款非常流行的CI(持续集成)工作软件,用于构建
	    和测试各种项目
	•  Jenkins 的主要功能是监视重复工作的执行,例如软
	    件工程的构建或在 cron下设置的 jobs
●Jenkins特点
	•  简单、可扩展、用户界面友好
	•  支持各种SCM(软件配置管理)工具,如SVN、GIT、CVS等
	•  能够构建各种风格的项目
	•  可以选择安装多种插件
	•  跨平台,几乎可以支持所有的平台
●持续集成
	•  持续集成(CI)是当下最为流行的应用程序开发实践方式
	•  程序员在代码仓库中集成了修复bug、新特性开发或是功能革新
	•  CI工具通过自动构建和自动测试来验证结果。这可以
		检测到当前程序代码的问题,迅速提供反馈
●持续集成流程
   1. 程序员提交代码更新到软件仓库(SVN/GIT) <-----------------+
  2. CI服务器基于计划任务查询仓库，并下载代码            |
  3. CI服务器运行构建过程并生成软件包(war包)             |
   4. 向开发团队发送构建通知 -------------------------------------------+
                                                                                
##################################################################################
扩展知识
●语言分类：
  解释型 ： php/python/shell  #不需要编译直接使用
  编译型 ： c/c++/java        #需要先编译，再执行
  
●java代码的发布
  #将Web项目War包部署到Tomcat服务器基本步骤（完整版）
  https://www.cnblogs.com/huangwentian/p/7542280.html
 
  & war包
    1.1 War包一般是在进行Web开发时，通常是一个web项目所有源码的集合，(html/css/java/c)
          当开发人员在自己的开发机器上调试所有代码并通过后，
          为了交给测试人员测试和未来进行产品发布，都需要将开发人员的源码打包成War进行发布。
          War包可以放在Tomcat下的webapps或者word目录下，随着tomcat服务器的启动，它可以自动被解压。
  		
●web项目上线的步骤： #参考上述持续集成
  1. 程序员，测试人员把web程序文件发布到github上；
  2. Jenkins服务器从github拉取web项目文件；
  3. web服务器从就近的Jenkins服务器拉取文件，更新自己的文件；
##################################################################################
部署Jenkin服务器
●准备3台虚拟机，并且能够连接外网  
●装包
	[root@zabbix_server ~]# yum -y install jenkins-2.121-1.1.noarch.rpm 
●起服务	
	[root@jenkins ~]# systemctl restart jenkins 
   [root@jenkins ~]# systemctl enable jenkins
   
●初始化Jenkins  #参考PPT devops/day5
   & 访问网页
     http://192.168.4.3:8080  #到指定文件查找密码，填写
   & 安装插件 
      全选取反，安装Git 和 Git parameter 即可
   & 修改管理员密码
##################################################################################   
使用Jenkins  
●模拟程序员  
	[root@room8pc16 day12]# git init /tmp/devops
	[root@room8pc16 day12]# cd /tmp/devops/
	[root@room8pc16 devops]# vim index.html
	<h1>web server 1.0</h1>
	[root@room8pc16 devops]# git add .   # 加到暂存区
	[root@room8pc16 devops]# git commit -m "web project 1.0"  # 加到版本库
	[root@room8pc16 devops]# git tag 1.0   # 打标记，1.0版本
	[root@room8pc16 devops]# vim index.html
	<h1>web server 1.0</h1>
	<h2 style="color: green">web server 2.0</h2>
	[root@room8pc16 devops]# git add .
	[root@room8pc16 devops]# git commit -m "web project 2.0"
	[root@room8pc16 devops]# git tag 2.0
	[root@room8pc16 devops]# git log   # 查看
	[root@room8pc16 devops]# git tag
	程序员将本地代码推送到gitlab服务器

  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
