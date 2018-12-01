运维开发实战
NSD DEVweb DAY04
Django 有很多资料
1. django介绍
   1.1 django 概述  MVC模式  MTV模式
2. 安装django
3. 管理应用
4. 编辑应用

https://docs.djangoproject.com/zh-hans/2.0/  #django中文文档  最下面 '开始'
##############################################################################	
django介绍
● Django概述
Django简介
	•  Django是一个开放源代码的Web应用框架,由Python写成
● 框架介绍
•  Django 框架的核心组件有:
	–  用于创建模型的对象关系映射(ORM)
	–  为最终用户设计的完美管理界面
	–  一流的 URL 设计
	–  设计者友好的模板语言
	–  缓存系统
● MVC模式(其他语言常用模式)
	把数据存取逻辑、业务逻辑和表现逻辑组合在一起的
	概念被称为软件架构的 Model-View-Controller
	(MVC)模式
● MTV模式  （很重要的Django框架）
	•  Django的MTV模式本质上和MVC是一样的,也是为
		了各组件间保持松耦合关系,只是定义上有些许不同
		–  M 代表模型(Model):负责业务对象和数据库的关
			系映射(ORM)
		–  T 代表模板 (Template):负责如何把页面展示给用户
			(html)
		–  V 代表视图(View):负责业务逻辑,并在适当时候-----------------理解为函数
			调用Model和Template
	•  除了以上三层之外,还需要一个URL分发器,它的作
	用是将一个个URL的页面请求分发给不同的View处理,
	View再调用相应的Model和Template

● MTV响应模式(手机有照片)
	•  Web服务器(中间件)收到一个http请求
	•  Django在URLconf里查找对应的视图(View)函数来
	    处理http请求
	•  视图函数调用相应的数据模型来存取数据、调用相应
	   的模板向用户展示页面
	•  视图函数处理结束后返回一个http的响应给Web服务器
	•  Web服务器将响应发送给客户端
##############################################################################
安装django
● python虚拟环境
	实现在同一个主系统内,
	同时安装django1.11.6和django2.0.5
● 配置虚拟环境并激活
	[root@room9pc01 ~]# python3 -m venv /opt/python/djenv
	[root@room9pc01 ~]# source /opt/python/djenv/bin/activate
● 在虚拟环境中安装Django，装django
	(djenv) [root@room9pc01 ~]# pip3 install django==1.11.6 
	#在djenv python虚拟环境下安装django
	
	验证版本：
	(djenv) [root@room9pc01 ~]# python
	Python 3.6.4 (default, Nov 14 2018, 16:43:45)
	>>>	import	django	
	>>>	django.__version__	
	'1.11.6'	
	
● 创建项目
   — 一个项目就是django实例的各种设置集合
   
	(djenv) [root@room9pc01 day4]# django-admin startproject mysite
	(djenv) [root@room9pc01 day4]# ls mysite/mysite/
	__init__.py  settings.py  urls.py  wsgi.py   
	//setting.py  配置文件
	//urls.py     设置Ip对应的函数
	//wsgi.py     发布动态页面

● 运行项目
   — django 为了方便程序员可以看到页面效果，内建了一个简单的web服务器
      只用于开发环境测试，如果时生产环境，需要把django项目部署在apache或nginx中
   
   (djenv) [root@room9pc01 day4]# python mysite/manage.py runserver
   
● 访问
	[root@room9pc01 day4]# firefox 127.0.0.1:8000
	
● 配置django变量	，转换数据库居为 Mysql
	  步骤1：创建库
		  mysql -uroot -ptedu.cn
		  create database dj1806 default charset utf8;
		  
	  步骤2：配置django变量	
	  # vim mysite/settings.py
		ALLOWED_HOSTS = '*'       # 允许全部的客户端访问
		MIDDLEWARE = [            # 关闭跨站攻击的安全配置
			... ...
			# 'django.middleware.csrf.CsrfViewMiddleware',
			... ...
		]
		DATABASES = {             # 配置django使用的数据库是mysql
			'default': {
				'ENGINE': 'django.db.backends.mysql',
				'NAME': 'dj1806',
				'USER': 'root',
				'PASSWORD': '123456',
				'HOST': '127.0.0.1',
				'PORT': '3306',
			}
		}
		LANGUAGE_CODE = 'zh-hans'       # 使用中文
		TIME_ZONE = 'Asia/Shanghai'     # 时区
		USE_TZ = False                  # 配置django使用本地时区
		
● 创建相关数据库表	
   & 创建相关表	
	  (djenv) [root@room9pc01 mysite]# python manage.py migrate

● 创建管理员帐号
	MariaDB [dj1806]> select * from auth_user;
	Empty set (0.00 sec)
	
	(djenv) [root@room9pc01 mysite]# python manage.py createsuperuser
	
	MariaDB [dj1806]> select * from auth_user \G;
	*************************** 1. row ***************************
		      id: 1
		password: pbkdf2_sha256
	  last_login: NULL
	is_superuser: 1
		username: admin
	  first_name: 
	   last_name: 
		   email: admin@tedu.cn
		is_staff: 1
	   is_active: 1
	 date_joined: 2018-11-30 11:18:49

● 进入管理界面
   (djenv) [root@room9pc01 mysite]# python manage.py runserver 0:80
   [root@room9pc01 mysite]# firefox 127.0.0.1/admin
##############################################################################
安装django异常处理
●  如果启动时报错，是因为没有sqilte数据库的支持，两种解决方法：
	(1)重新编译python3
	# yum -y install sqlite-devel
	# ./configure --prefix=/usr/local
	# make && make install

	(2)使用mysql数据库  --- 参考上述步骤【】

● 修改配置参数
	如果报以下错误：
		Did you install mysqlclient or MySQL-python?
	解决办法如下：
		(djenv) [root@room8pc16 mysite]# pip3 install pymysql
		# vim mysite/__init__.py
		import pymysql
		pymysql.install_as_MySQLdb()
	再次运行开发环境
		(djenv) [root@room8pc16 mysite]# python manage.py runserver 0:80	

##############################################################################
管理应用
●  创建应用
   — 一个项目有很多的功能，可以将这些功能编写成一个个的应用。每个应用都是可重用的
   	  如果其他项目也需要有完全一样的功能，只要加载这个应用即可。
   	  
   (djenv) [root@room9pc01 mysite]# python manage.py startapp poll

●  激活应用——即将应用安装到项目中
		创建应用后，应用不会自动成为项目的一员。需要修改配置文件
	# vim mysite/settings.py
	INSTALLED_APPS = [
		... ...
		'poll',
	]
##############################################################################
练习
	1、新建虚拟环境
	2、在虚拟环境中安装django和pymysql
	3、激活虚拟环境
	4、创建一个项目mysite
	5、如果使用的是mysql数据库，需要在mysql中再创建一个新的数据库
	6、编辑项目配置文件
	7、创建数据库
	8、创建管理员用户
	9、启动开发环境
	10、访问django和后台管理界面
	11、创建应用，并将应用加入到项目中


  598  python3 -m venv /opt/pro1
  599  source /opt/pro1/bin/activate
  600  pip3 install pymysql django
  601  ls
  602  cd git/python/devweb/day4/
  603  ls
  604  django-admin startproject pro1
  605  ls
  606  cd ls
  607  cd pro1/
  608  ls
  609  vim pro1/__init__.py 
  610  mysql -uroot -p123456
  611  vim pro1/settings.py 
  612  python manage.py migrate
  613  vim pro1/__init__.py 
  614  python manage.py migrate
  615  vim pro1/settings.py 
  616  python manage.py migrate
  617  python manage.py createsuperuser
  618  python manage.py runserver 0:80
  619  history 
##############################################################################
● 编辑应用
   & 创建投票应用
   1.投票应用需要在数据库中创建两张表
      问题表： 问题编号、内容
      选项表：选项编号、选项内容、问题编号、所的票数
   2.URL设计
      http://127.0.0.1/poll           ->列出所有问题
      http://127.0.0.1/poll/1         ->列出1号问题详细信息
      http://127.0.0.1/poll/1/result  ->显示1号问题的投票结果
   3.模板设计
   		首页(列出所有问题的页面)：index.html
   		问题详情页： default.html
   		投票结果页： result.html
##############################################################################   		
● 编辑应用 
   4.配置 URLConf 
      将 以 http://127.0.0.1/poll/ 开头的网址都交给poll应用处理 
   # vim mysite/urls.py
   	from django.conf.urls import url,include
	from django.contrib import admin

	urlpatterns = [
	    url(r'^admin/', admin.site.urls),
	    url(r'^poll/',include('poll.urls') )
	]
   
   5. 配置poll/urls 处理请求
   # vim poll/urls.py
   from django.conf.urls import url
	from . import views
	urlpatterns=[
	]
##############################################################################
● 编辑应用
  6. 创建首页文件
 	(1)在poll/urls.py中创建url和函数的声明
	  # vim poll/urls.py
	   from django.conf.urls import url
		from . import views
		urlpatterns=[
		   #将url为 http://127.0.0.1/poll 的请求都转发到 index 函数处理， 这个url叫 index
			url('^$', views.index, name='index')
		]  
   (2)修改 poll/view.py 创建简单首页 测试视图  
	  from django.shortcuts import render, HttpResponse
	  def index(request):
   		   return HttpResponse('<h1>poll首页</h1>')
   
   (3)访问http://127.0.0.1/poll  #
   (djenv) [root@room9pc01 mysite]# python manage.py runserver 0:80
	[root@room9pc01 mysite]#  firefox http://127.0.0.1/poll
	
   (4)创建模板，用户访问主页的时候，用index.html响应 
		(djenv) [root@room8pc16 mysite]# mkdir poll/templates
		# vim poll/templates/index.html
		<!DOCTYPE html>
		<html lang="en">
		<head>
			<meta charset="UTF-8">
			<title>投标首页</title>
		</head>
		<body>
		这是投票首页
		</body>
		</html>
	(5)修改index函数，将index.html网页返回给用户
	# vim poll/views.py
	def index(request):
		return render(request, 'index.html')
##############################################################################
● 编辑应用
  7.创建模型 (数据库)
   (1) 编写模型代码
   #vim  poll/models.py
   from django.db import models
	from . import views
	# Create your models here.
	class Questions(models.Model):
		question_text=models.CharField(max_length=200)
		pub_date = models.DateTimeField()

		def __str__(self):
		    return '<问题： %s>' % self.question_text

	class Choice(models.Model):
		choice_text = models.CharField(max_length=200)
		vote = models.IntegerField()
		question = models.ForeignKey(Questions,on_delete=models.CASCADE)

		def __str__(self):
		    return '<%s: %s>' % (self.question,self.choice_text)
		    
    (2)生成数据表
       & 生成修改数据库的脚本文件  
       (djenv) [root@room8pc16 mysite]# python manage.py makemigrations
       & 生成数据表
       (djenv) [root@room8pc16 mysite]# python manage.py migrate
			MariaDB [dj1806]> show tables;   # 查看到新出现了两张表
##############################################################################	
● 编辑应用
	8.	分析数据库
		(1)数据表
		MariaDB [dj1806]> show tables;
			poll_question      poll_choice
			通过第7步生成的表名： 应用名_类名
		(2)poll_question的字段
			MariaDB [dj1806]> desc poll_question;
			id: int            # -> django自动生成的主键
			question_text: varchar(200)   # 类属性
			pub_date: datetime            # 类属性
		(3)poll_choice的字段
			MariaDB [dj1806]> desc poll_choice;
			id: int  # ->django自动生成的主键
			choice_text: varchar(200)     # 类属性
			vote: int      # 类属性
			q_id: int      # django根据主外键约束，自动生成的外键字段
			
    9. 修改数据库字段
      # vim poll/models.py
       class Choice(models.Model):
			... ...
			question = models.ForeignKey(Question, on_delete=models.CASCADE)
				def __str__(self):
				return "<%s: %s>" % (self.question, self.choice_text)

		(djenv) [root@room8pc16 mysite]# python manage.py makemigrations
		(djenv) [root@room8pc16 mysite]# python manage.py migrate
		MariaDB [dj1806]> desc polls_choice;
		原来的q_id变成了question_id
##############################################################################
● 编辑应用
  10. 注册表格
  将模型注册到管理后台
	# vim poll/admin.py
	from django.contrib import admin
	from .models import Question, Choice

	admin.site.register(Question)
	admin.site.register(Choice)
##############################################################################
● 编辑应用
  11 定制后台管理
  # vim poll/admin.py 
  from django.contrib import admin
  from .models import Question, Choice

  # admin.site.register(Question)
  class QuestionAdmin(admin,ModelAdmin):
      # 后台显示那些字段
      list_display=['question_text','pub_date']
      # 根据日期过滤问题
      list_filter=['pub_date']
      # 显示时间轴、点选时间、查看某年、某月、某日的问题
      date_hierarchy='pub_date'
      # 添加搜索框， 根据问题内容进行搜索
      search_fields=['question_text']
      # 根据发布时间进行降序排序，没有‘-’号，默认时升序
      ordering = ['-pub-date']
  admin.site.register(QuestionAdmin,Question)
  admin.site.register(Choice)
      
##############################################################################















