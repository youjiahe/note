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
•  URL正则采用的是match操作
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
多及规划
##############################################################################
REST框架
http://www.runoob.com/w3cnote/restful-architecture.html
##############################################################################




























