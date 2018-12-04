运维开发实战
NSD Porject day1

项目： 通过web批量管理服务器
	1.管理远程服务器，通过ansible
	2.远程服务器写到数据库中
	3.ansible使用动态主机清单
	4.在web页面中可以查看所有的远程服务器状态
	5.通过web创建主机和主机组
	6.通过web添加使用ansible模块
	7.通过web指定在哪些主机/主机组上执行命令
##############################################################################	
环境准备
● 激活python 虚拟环境
	[root@room9pc01 day7]# source /opt/python/djenv/bin/activate
	(djenv) [root@room9pc01 day7]# cd /root/git/python/devweb/
	(djenv) [root@room9pc01 day7]# mkdir day7
	(djenv) [root@room9pc01 day7]# cd day7
● 安装必要的包	
	(djenv) [root@room9pc01 day7]# pip3 install ansible sqlalchemy pymysql \
	wordcloud matplotlib
● 创建应用
	(djenv) [root@room9pc01 day7]# django-admin startproject myansible
	(djenv) [root@room9pc01 day7]# cd myansible
	(djenv) [root@room9pc01 myansible]# python manage.py startapp webansi
##############################################################################
● 修改配置  settings.py
	ALLOWED_HOSTS = '*'

	# Application definition

	INSTALLED_APPS = [
	... ...
		  'webansi',
	]

	MIDDLEWARE = [
	... ...
		  #'django.middleware.csrf.CsrfViewMiddleware',
	... ...
	]

	LANGUAGE_CODE = 'zh-hans'

	TIME_ZONE = 'Asia/Shanghai'

	USE_TZ = False
#############################################################################
● 规划url
	http://server/ #显示所有任务的超链接
	http://server/webansi/ #显示远程服务器的主机信息
	http://server/webansi/addhosts/   #显示/添加主机(组)
	http://server/webansi/addmodules/ #显示/添加模块、参数
	http://server/webansi/tasks/    #执行任务
#############################################################################
● 授权 
	# vim myansible/urls.py  
	#授权 以http://server/webansi/开头的网址交给webansi应用处理
	from django.conf.urls import url,include
	from django.contrib import admin

	urlpatterns = [
		  url(r'^admin/', admin.site.urls),
		  url(r'^webansi/', include('webansi'))
	]

#############################################################################
● 创建模型
	from django.db import models
	from . import views
	# Create your models here.
	class HostGroup(models.Model):
		  groupname = models.CharField(max_length=50,unique=True)

		  def __str__(self):
		      return '<组别：%s>' % self.groupname

	class Host(models.Model):
		  hostname=models.CharField(max_length=50,unique=True)
		  ipaddr=models.CharField(max_length=15,unique=True)
		  group = models.ForeignKey(HostGroup,on_delete=models.CASCADE)

		  def __str__(self):
		      return '<%s--%s>' % (self.hostname,self.group)

	class AnsiModule(models.Model):
		  module_name = models.CharField(max_length=30,unique=True)
		  
		  def __str__(self):
		      return self.module_name
		  
	class ModArg(models.Model):
		  arg_text = models.CharField(max_length=300)
		  mod = models.ForeignKey(AnsiModule,on_delete=models.CASCADE)
		  
		  def __str__(self):
		      return '<%s--%s>' % (self.arg_text,self.mod)

● 生成数据表
& 创建 webansi/urls.py
	from django.conf.urls import url
	urlpatterns=[
		  
	]
	
& 生成数据表脚本，并生成表
	(djenv) [root@room9pc01 myansible]# python manage.py makemigrations
	(djenv) [root@room9pc01 myansible]# python manage.py migrate

& 查看数据库
	(djenv) [root@room9pc01 myansible]# sqlite3 db.sqlite3          
	sqlite> .schema webansi_host   #查看建表指令
	sqlite> .schema webansi_hostgroup

● 创建管理员
	(djenv) [root@room9pc01 myansible]# python  manage.py createsuperuser

#############################################################################
● 创建首页
	& 编写url  # myansible/urls.py
	from django.conf.urls import url,include
	from django.contrib import admin
	from . import views
	urlpatterns = [
		  url(r'^$',views.index,name='index'),
		  url(r'^admin/', admin.site.urls),
		  url(r'^webansi/', include('webansi.urls')),
	]
	& 创建views.py  # myansible/views.py
	from django.shortcuts import render

	def index(request):
		  return render(request,'index.html')
● 编写首页文件
	# vim myansible/webansi
	<!DOCTYPE html>
	<html lang="en">
	<head>
		  <meta charset="UTF-8">
		  <title>首页</title>
	</head>
	<body>
	这是首页
	</body>
	</html>
	
● 引入bootstrap
  拷贝老师的static文件夹
● 













