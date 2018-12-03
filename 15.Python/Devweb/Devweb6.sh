运维开发实战
NSD DEVweb DAY06
1.入口映射
2.模板详解
3.模型详解
https://docs.djangoproject.com/zh-hans/2.0/  #django中文文档  最下面 '开始'
##############################################################################	
Django 博客应用
● 创建虚拟环境并且激活
	[root@room8pc16 mysite]# source /opt/djenv/bin/activate

● 创建项目
	(djenv) [root@room8pc16 day6]# django-admin startproject blog
	(djenv) [root@room8pc16 day6]# cd blog/

● 创建应用
	python manage.py startapp article
	
● 修改项目配置  blog/settings.py
	ALLOWED_HOSTS = '*'
	INSTALLED_APPS = [
		'django.contrib.admin',
		'django.contrib.auth',
		'django.contrib.contenttypes',
		'django.contrib.sessions',
		'django.contrib.messages',
		'django.contrib.staticfiles',
		'article',
	]
	MIDDLEWARE = [
		'django.middleware.security.SecurityMiddleware',
		'django.contrib.sessions.middleware.SessionMiddleware',
		'django.middleware.common.CommonMiddleware',
		# 'django.middleware.csrf.CsrfViewMiddleware',
		'django.contrib.auth.middleware.AuthenticationMiddleware',
		'django.contrib.messages.middleware.MessageMiddleware',
		'django.middleware.clickjacking.XFrameOptionsMiddleware',
	]
	LANGUAGE_CODE = 'zh-hans'
	TIME_ZONE = 'Asia/Shanghai'
	USE_TZ = False

● 创建模板  article/models.py

	from django.db import models

	class Article(models.Model):
		title = models.CharField(max_length=100)
		pub_date = models.DateTimeField()
		text = models.TextField()

		def __str__(self):
		    return self.title

● 生成数据库表,创建超级管理员
	(djenv) [root@room8pc16 blog]# python manage.py makemigrations
	(djenv) [root@room8pc16 blog]# python manage.py migrate
	(djenv) [root@room8pc16 blog]# python manage.py createsuperuser

● 查看数据库
	(djenv) [root@room8pc16 blog]# sqlite3 db.sqlite3
	sqlite> .tables
	sqlite> .schema article_article
	
● 配置项目 urls.py
from django.conf.urls import url,include  #添加 include
from django.contrib import admin

urlpatterns = [
    url(r'^admin/', admin.site.urls),
    url(r'article', include('article.urls'))   #包含 应用article的urls.py
]

● 配置 article/views.py
   from django.shortcuts import render,HttpResponse
	from .models import Article
	# Create your views here.
	def hello(request):
		articles = Article.objects.all()
		return HttpResponse('<h1>Hello</h1>')
##############################################################################
● URL正则采用的是match操作
	–  r'^hello':匹配以hello开头的任意URL,如:/helloabc
	–  r'^hello/$':匹配hello且后面无信息的URL,如:/hello, /hello/
	–  r'^$':匹配 / 即空URL,通常用来设定应用的根,即默认入口。
		如: http://IP:port或者http://IP:port/

	将urls.py中的网址分别做以下修改，再测试
	 url(r'hello',views.hello,name='hello'),
    url(r'^hello',views.hello,name='hello'),
    url(r'^hello/',views.hello,name='hello'),
    url(r'^hello$ ',views.hello,name='hello'),
    url(r'^hello/$',views.hello,name='hello'),
	
	#测试
	http://127.0.0.1/article/
	http://127.0.0.1/article/hello
	http://127.0.0.1/article/hello/
	http://127.0.0.1/article/ahello
	http://127.0.0.1/article/ahelloabc
	http://127.0.0.1/article/hello/abc

##############################################################################
● 多及规划
比如，你正在为一所学校编写程序。程序涉及学生管理、教师管理、课程管理等。
	http://server_ip/teacher/
	http://server_ip/teacher/add/1/
	http://server_ip/teacher/delete/1/
	http://server_ip/teacher/update/1/
	http://server_ip/teacher/query/1/

	http://server_ip/student/
	http://server_ip/student/add/1/
	http://server_ip/student/delete/1/
	http://server_ip/student/update/1/
	http://server_ip/student/query/1/

	http://server_ip/course/
	http://server_ip/course/add/1/
	http://server_ip/course/delete/1/
	http://server_ip/course/update/1/
	http://server_ip/course/query/1/

##############################################################################
● REST框架
http://www.runoob.com/w3cnote/restful-architecture.html
##############################################################################
● 博客首页显示全部文章，也能写新博客
(1)urls.py
	from django.conf.urls import url
	from . import views

	urlpatterns = [
		url(r'^$', views.index, name='index'),
		url(r'^hello/$', views.hello, name='hello'),
]
(2)views.py
	from django.shortcuts import render, HttpResponse
	from .models import Article

	def index(request):
		articles = Article.objects.order_by('-pub_date')
		return render(request, 'index.html', {'articles': articles})

	def hello(request):
		return HttpResponse('<h1>Hello World!</h1>')
		
(3)article/templates/index.html

	<!DOCTYPE html>
	<html lang="en">
	<head>
		<meta charset="UTF-8">
		<title>My Blog</title>
	</head>
	<body>
	<div>
		<form action="" method="post">
		    <label>标题：</label><input type="text" name="title"><br>
		    <textarea name="content" cols="50" rows="10"></textarea><br>
		    <input type="submit" value="发 布">
		</form>
	</div>
	<hr>
	{% for article in articles %}
		<div>
		    <h3>{{ article.title }}</h3>
		    <h5>{{ article.pub_date }}</h5>
		    {{ article.text }}
		</div>
	{% endfor %}
	</body>
	</html>
##############################################################################
模板
● 配置模板
•  模板引擎通过TEMPLATES 设置来配置。 它是一个设
	置选项列表,与引擎一一对应。 默认的值为空。 由
	startproject 命令生成的settings.py 定义了一些有
	用的值
	TEMPLATES	=	[	
				{	
					'BACKEND':	'django.template.backends.django.DjangoTemplates',	
					'DIRS':	[],	
					'APP_DIRS':	True,	
					'OPTIONS':	{	
					#	...	some	opfons	here	...	
					},	
				},	]
				
				
   #BACKEND 是一个指向实现了Django模板后端API的模板引擎类的带点的Python路径
   #内置的后端有 :
	# –  django.template.backends.django.DjangoTemplates
	# –  django.template.backends.jinja2.Jinja2
	# DIRS 定义了一个目录列表,模板引擎按列表顺序搜索这些目录以查找模板源文件
	#APP_DIRS 告诉模板引擎是否应该进入每个已安装的应用中查找模板

● 使用模板
	# vim article/views.py  #应用目录下的views
	def home(request):
		return render(request,'home.html')
		
	# vim polls/views.py
	def results(request):
    questions = Questions.objects.order_by('pub_date')
    return render(request,'results.html',{'questions':questions})
● 渲染模板
	#一旦拥有一个Template对象,就可以通过给一个context来给它传递数据
	#在Django模板系统中处理复杂数据结构的关键是使用(.)字符
	
	# vim article/views.py  #应用目录下的views
	def hello(request):
		context = {
		    'num':1000,
		    'student': ['尤家和','路德维','两家先','赵明刚'],
		    'dict': {'email':'you@163.com','phone':'13676240551'},
		    'class': 'nsd1806',
		}
		return render(request,'hello.html',context)
	-----------------------------------------------------------------------------------------------
	<!DOCTYPE html>
	... ... 
	<hr>
	{{ class.11 }}
	<hr>
	{{ class.upper }}
	<hr>
	{{ dict.email }}
	<hr>
	{{ student.2 }}
	<hr>
	{{ num}}/{{ student }}/{{ dict }}/{{ class }}
	... ...
	</html>
##############################################################################	
模板语法
● 模板中可以使用的元素有:
	–  变量,使用 {{ variable }} 的格式
	–  标签/指令,使用 {% ... %}的格式
	–  字符串:{ } 之外的任何东西,都当做字符串处理

● 模板中的变量
	•  简单变量:{{cname}}
	•  对象变量:{{ student . cname}}
	•  列表对象:{{ student . 1 }}
	•  字典对象:{{ student . cname }}
	
● 循环结构
	{% for s in student %}
		<p>{{ forloop.revcounter0 }}.{{ s }}</p>  #forloop是 for里面的方法
	{% endfor %}

● 条件分支
	{% if num > 100 %}
		大
		{% elif num < 100 %}
		小
		{% else %}
		等于100
	{% endif %}

● 使用过滤器
	换行 {{ article.text |linebreaksbr}}
	只显示部分字	{{ article.text |linebreaksbr | truncatewords:10 }}
##############################################################################
模板继承
1.创建基本模板，再用block替代内容
	#  vim templates/base.html
	<!DOCTYPE html>
	<html lang="en">
	<head>
		<meta charset="UTF-8">
		<title>{% block title%}{% endblock %}</title>
		<link rel="stylesheet" href="static/css/bootstrap.min.css">
	</head>
	<body>
	<div>
		<div class="container">
		    <div class="header bg-warning">这是头部</div>
		    <div class="main">
		        {% block content%}

		        {% endblock %}
		    </div>
		    <div class="footer">
		        <a href="http://www.tmooc.cn" target="_blank">
		            达内云计算
		        </a>
		    </div>
		</div>
	</div>

	</body>
	</html>

2.创建页面

	#  vim templates/index.html
	{% extends 'base.html' %}     #继承模板
	{% block title %}My Blog{% endblock %}
	{% block content %}
		<div>
			<form action="" method="post">
				<label for="">标题 <input type="text" name="title" class="input-md"></label>
				<textarea name="content" id="content" cols="30" rows="10" placeholder="博客内容" ></textarea><br>
				<input type="submit" value="发布">
			</form>
		</div>
		<hr>
		{% for article in articles %}
			<h3>{{ article.title }}</h3><br>
			{{ article.pub_date }}<br>
			{{ article.text |linebreaksbr | truncatewords:10 }}
			<button class="btn btn-default">
				<a href="">展开</a>
			</button>
			<hr>
		{% endfor %}
	{% endblock %}
##############################################################################





