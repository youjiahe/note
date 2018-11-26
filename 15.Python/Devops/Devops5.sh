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
  3. CI服务器运行构建过程并生成软件包(war包)            |
  4. CI服务器进行单元和集成测试,存储测试结果             |
   5. 向开发团队发送构建通知 -------------------------------------+
                                                                                
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
●模拟程序员 上传代码
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
	
●程序员将本地代码推送到gitlab服务器
	[root@room8pc16 ~]# cd /tmp/devops/
	[root@room8pc16 devops]# git remote rename origin old-origin
	[root@room8pc16 devops]# git remote add origin http://192.168.4.1/nsd1806/devops.git
	[root@room8pc16 devops]# git push -u origin --all
	[root@room8pc16 devops]# git push -u origin --tags

●gitlab中重要的概念
	群组group：可以为一个团队创建一个群组
	项目project：一个团队可以开发多个项目
	成员member：为团队成员创建的账号

●gitlab设置
	创建名为nsd1806的group，再从组中创建名为devops的项目
	创建用户，将用户加入到项目，为其指定角色为主程序员
##################################################################################  
使用Jenkins  
● 配置Jenkins访问Gitlab
   & 实现以下目标
     — Jenkins 访问 gitlab 将代码下载
     — 下载代码时，可以选择版本(tag)
     — 下载的代码默认存在 /var/lib/jenkins/workspace目录下的项目有目录下
         ，需要在它下面创建子目录
     — 下载的代码需要打tar包 保存到web服务器网站目录下 以供下载
     — 计算tar包的Md5值，保存到文件中，以便下载时校验
     — 将软件最新版本写到Live_version
     — 将前一个版本写到last_version文件中
  
&步骤：
	 1.安装 git 和 httpd
	  [root@jenkins devops]# yum -y install httpd
	  [root@jenkins devops]# yum -y install git
	 2.启动httpd
	 3.创建目录
	  [root@jenkins devops]# mkdir -pv /var/www/html/deploy/packages
	  # 目录/var/www/html/deploy 用于保存live_version 和 last_version文件
	  # 目录/var/www/html/deploy/packages 用于保存tar包和md5值文件
	  
	 4.修改新建目录属者属组
	 [root@jenkins devops]# chown -R jenkins.jenkins /var/www/html/deploy/
	 
	 5.在Jenkins中创建一个“自由风格”的软件项目 
	 6.勾选参数化构建过程--------[parameter type ] 选 [Branch or tag]
	 7.源码管理选 [Git] -------> 填写Repository URL(必须加.git结尾)
	   ------->Branch Specifier 写git parameter名称
	 8.保存 ----->进到 工程 构建
	 9.配置------>构建 ----->选择执行shell ---->为了实现上述目标，添加以下脚本
	deploy_dir=/var/www/html/deploy/packages
	cp -r web_pro${mytag} $deploy_dir
	rm -rf $deploy_dir/web_pro${mytag}/.git
	cd $deploy_dir
	tar -czf web_pro${mytag}.tar.gz web_pro${mytag}
	rm -rf web_pro${mytag}
	md5sum web_pro${mytag}.tar.gz | awk '{print $1}' > web_pro${mytag}.tar.gz.md5
	[ -f live_version ] && cat live_version > last_version 
	echo $mytag > live_version
	
   10.构建
################################################################################## 
在应用服务器上编写python工具，实现软件自动部署
	1.检查是否有新版本
	2.如果有新版本下载新版本
	3.校验下载的程序包是否损坏
	4.如果没有损坏、部署
	5.更新本地live_version

需要从jenkins运行构建过程

#!/usr/bin/env python3
import os
import requests
import hashlib
import tarfile
def check_version(ver_url,fname):
    #如果版本文件不存在，则表示需要更新
    if not os.path.isfile(fname):
        return True

    #如果线上版本与web服务器版本(本地)不一致，则需要更新
    f=requests.get(ver_url)
    with open(fname) as fobj:
        local_ver=fobj.read()
    if f.text!=local_ver:
        return True
    return False

def download(url,fname):  #从jenkins服务器下载软件包，版本信息
    r = requests.get(url)
    with open(fname,'wb') as fobj:
        fobj.write(r.content)

def check_md5(url,fname):
    m=hashlib.md5()
    with open(fname,'rb') as fobj:
        while True:
            data=fobj.read(1024)
            if not data:
                break
            m.update(data)
    file_md5=m.hexdigest()

    r = requests.get(url)
    if r.text.strip()==file_md5:
        return True   #文件未损坏，返回True
    return False      #文件损坏，返回False

def deploy(deploy_dir,link,app_fname):
    os.chdir(deploy_dir)
    tar = tarfile.open(app_fname,'r:gz')
    tar.extractall()
    tar.close()

    if os.path.islink(link):
        os.unlink(link)

    src=app_fname.split('/')[-1].replace('.tar.gz','')
    src=os.path.join(deploy_dir,src)
    dst=link
    os.symlink(src,dst)

if __name__ == '__main__':
    deploy_dir = '/var/www/deploy'
    download_dir='/var/www/download'
    link = '/var/www/html/nsd1806'

    ver_url='http://192.168.4.3/deploy/live_version'
    fname='%s/live_version' % deploy_dir
    new_version = check_version(ver_url,fname)
    if not new_version:
        print('没有新版本更新!')
        exit(1)

    r = requests.get(ver_url)
    app_url='http://192.168.4.3/deploy/packages/web_pro%s.tar.gz' % r.text.strip()
    app_fname=app_url.split('/')[-1]
    app_fname=os.path.join(download_dir,app_fname)
    download(app_url,app_fname)

    md5_url='http://192.168.4.3/deploy/packages/web_pro%s.tar.gz.md5' % r.text.strip()
    md5 = check_md5(md5_url,app_fname)
    if not md5:
        print('文件有损坏')
        exit(2)

    deploy(deploy_dir,link,app_fname)

    #更新本地version文件
    download(ver_url,fname)
    print('新版本部署完成')

  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
