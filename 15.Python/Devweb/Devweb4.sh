运维开发实战
NSD DEVweb DAY04
Django 有很多资料
1. django介绍
   1.1 django 概述  MVC模式  MTV模式
2. 安装django
3. 管理应用
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
   	  
   (djenv) [root@room9pc01 mysite]# python manage.py startproject polls

●  激活应用——即将应用安装到项目中
		创建应用后，应用不会自动成为项目的一员。需要修改配置文件
	# vim mysite/settings.py
	INSTALLED_APPS = [
		... ...
		'polls',
	]

●   
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





















