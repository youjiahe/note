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
#############################################################################
● 修改首页文件
{% load staticfiles %}
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>首页</title>
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <link rel="stylesheet" href="{%  static 'css/bootstrap.min.css' %}">
    <style>
        .banner{
            background-image: url("{%  static 'imgs/banner.png' %}");
            background-size: 100% ;
            height: 190px;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="banner">
        头部
    </div>
    <hr>
    <div class="main h3">
        <div class="row">
            <div class="col-md-3 text-center">
                <a href="">
                    <img src="{% static 'imgs/linux.jpg'%}" width="150px" alt="imgs/linux.jpg">
                    <br>
                    主机信息
                </a>

            </div>
            <div class="col-md-3 text-center ">
                <a href="">
                    <img src="{% static 'imgs/linux.jpg' %}"  width="150px" alt="imgs/linux.jpg">

                <br>
                添加主机
                </a>
            </div>
            <div class="col-md-3 text-center">
                <a href="">
                    <img src="{% static 'imgs/linux.jpg'%}" width="150px" alt="imgs/linux.jpg">
                    <br>
                    添加模块
                </a>

            </div>
            <div class="col-md-3 text-center ">
                <a href="">
                    <img src="{% static 'imgs/linux.jpg' %}"  width="150px" alt="imgs/linux.jpg">
                <br>
                执行任务
                </a>
            </div>
        </div>
    </div>
    <hr>
    <div class="footer h4 text-center">
        <a href="http://www.tmocc.cn">达内云计算</a>达内云计算学院.达内时代科技集团
    </div>
</div>
<script src="{% static 'js/jquery.min.js' %}"></script>
<script src="{% static 'js/bootstrap.min.js' %}"></script>
</body>
</html>
#############################################################################
● 创建模板页面文件  base.html
{% load staticfiles %}
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>{% block title %}{% endblock %}</title>
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <link rel="stylesheet" href="{%  static 'css/bootstrap.min.css' %}">
    <style>
        .banner{
            background-image: url("{%  static 'imgs/banner.png' %}");
            background-size: 100% ;
            height: 190px;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="banner">头部</div>
    <hr>
    <div class="main h3">{% block content %}{% endblock %}</div>
    <hr>
    <div class="footer h4 text-center">
        <a href="http://www.tmocc.cn">达内云计算</a><br>
        <label class="text-info h5">客服电话：400-111-8989 邮箱：admin@tedu.cn</label>
    </div>
</div>
<script src="{% static 'js/jquery.min.js' %}"></script>
<script src="{% static 'js/bootstrap.min.js' %}"></script>
</body>
</html>
#############################################################################
● 再次修改首页文件，继承模板 base.html
{% extends 'base.html' %}
{% load staticfiles %}
{% block title %}首页_mod{% endblock %}
{% block content %}
     <div class="row">
            <div class="col-md-3 text-center">
                <a href="">
                    <img src="{% static 'imgs/linux.jpg'%}" width="150px" alt="imgs/linux.jpg">
                    <br>
                    主机信息
                </a>

            </div>
            <div class="col-md-3 text-center ">
                <a href="">
                    <img src="{% static 'imgs/linux.jpg' %}"  width="150px" alt="imgs/linux.jpg">

                <br>
                添加主机
                </a>
            </div>
            <div class="col-md-3 text-center">
                <a href="">
                    <img src="{% static 'imgs/linux.jpg'%}" width="150px" alt="imgs/linux.jpg">
                    <br>
                    添加模块
                </a>

            </div>
            <div class="col-md-3 text-center ">
                <a href="">
                    <img src="{% static 'imgs/linux.jpg' %}"  width="150px" alt="imgs/linux.jpg">
                <br>
                执行任务
                </a>
            </div>
        </div>
{% endblock  %}
#############################################################################
● 配置ansible
	1、创建三台虚拟机
	2、配置三台虚拟的IP地址、yum、免密登陆
	3、在manage.py同级的目录下创建ansible的工作目录

	# mkdir ansicfg
	# vim ansicfg/ansible.cfg
	[defaults]
	inventory = dhosts.py
	remote_user = root

#############################################################################
● 创建动态主机清单脚本
# touch ansicfg/dhosts.py
# chmod +x ansicfg/dhosts.py
dhosts.py执行后，要求的输出格式如下：
{
    "webservers": {
        "hosts": ["192.168.4.1", "192.168.4.2"]
    },
    "dbservers": {
        "hosts": ["192.168.4.3"]
    }
}
# vim ansicfg/dhosts.py
#!/opt/djenv/bin/python

import json
from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy import Column, Integer, String, ForeignKey
from sqlalchemy.orm import sessionmaker

engine = create_engine(
    'sqlite:////var/ftp/nsd2018/nsd1806/python/ansible_project/myansible/db.sqlite3',
    encoding='utf8',
)
Session = sessionmaker(bind=engine)
Base = declarative_base()

class HostGroup(Base):
    __tablename__ = 'webansi_hostgroup'
    id = Column(Integer, primary_key=True)
    groupname = Column(String(50), unique=True)

    def __str__(self):
        return self.groupname

class Host(Base):
    __tablename__ = 'webansi_host'
    id = Column(Integer, primary_key=True)
    hostname = Column(String(50), unique=True)
    ipaddr = Column(String(15))
    group_id = Column(Integer, ForeignKey('webansi_hostgroup.id'))

    def __str__(self):
        return "<%s: %s>" % (self.hostname, self.ipaddr)

if __name__ == '__main__':
    result = {}
    session = Session()
    qset = session.query(Host.ipaddr, HostGroup.groupname)\
        .join(HostGroup, HostGroup.id==Host.group_id)
    for ip, group in qset:
        if group not in result:
            result[group] = {}   # {'dbservers': {}}
            result[group]['hosts'] = []  # {'dbservers': {'hosts': []}}
        result[group]['hosts'].append(ip)

    print(json.dumps(result))

#############################################################################
● 制作webansi应用的首页
1、编写url
	# webansi/urls.py
	urlpatterns = [
		url(r'^$', views.home, name='polls_index'),
	]
2、编写视图函数
	# websnsi/views.py
	from django.shortcuts import render

	def home(request):
		return render(request, 'home.html')
		
3、编写模板
	(1)安装ansible-cmdb
		# pip install ansible-cmdb
	(2)收集被管理的服务器信息
		# cd ansicfg/
		# ansible all -m ping   # 测试动态主机清单文件和连通性
		# ansible all -m setup --tree out/
	(3)生成home.html
		# ansible-cmdb out/ > /var/ftp/nsd2018/nsd1806/python/ansible_project/myansible/webansi/templates/home.html
	(4)修改index.html，将“主机信息”的超链接指向home.html
		<a href="{% url 'polls_index' %}">

#############################################################################
● 实现“添加主机” 页面
1、编写URL
    url(r'^addhosts/$', views.addhosts, name='addhosts'),
2、编写views视图函数
def addhosts(request):
    return render(request, 'addhosts.html')
3、修改index.html的超链接，指向添加主机
<a href="{% url 'addhosts' %}">
4、编写addhosts.html模板
{% extends 'base.html' %}
{% load staticfiles %}
{% block title %}添加主机(组){% endblock %}
{% block content %}
    <form action="" method="post" class="form-inline">
        <div class="form-group">
            <label>主机名：</label>
            <input class="form-control" type="text" name="host">
        </div>
        <div class="form-group">
            <label>ip地址：</label>
            <input class="form-control" type="text" name="ip">
        </div>
        <div class="form-group">
            <label>主机组：</label>
            <input class="form-control" type="text" name="group">
        </div>
        <div class="form-group">
            <input class="btn btn-primary" type="submit" value="提 交">
        </div>
    </form>
{% endblock %}
5、修改addhosts函数，取出主机信息，发给模板
def addhosts(request):
    groups = HostGroup.objects.all()
    return render(request, 'addhosts.html', {'groups': groups})
6、修改addhosts.html模板，显示主机和组。在form表单下面增加一个表格
<table class="table table-bordered table-striped table-hover">
    <tr class="info">
        <th>主机组</th>
        <th>主机</th>
    </tr>
    {% for group in groups %}
        <tr>
            <td>{{ group.groupname }}</td>
            <td>
                <ul class="list-unstyled">
                    {% for host in group.host_set.all %}
                        <li>{{ host.hostname }}: {{ host.ipaddr }}</li>
                    {% endfor %}
                </ul>
            </td>
        </tr>
    {% endfor %}
</table>
7、修改addhosts函数，支持创建主机和主机组
def addhosts(request):
    if request.method == 'POST':
        groupname = request.POST.get('group')
        host = request.POST.get('host')
        ip = request.POST.get('ip')
        if groupname.strip():
            # 取出主机组模型或创建主机组，返回值是(组实例，True/False)
            group = HostGroup.objects.get_or_create(groupname=groupname)[0]
            if host.strip() and ip.strip():
                group.host_set.get_or_create(hostname=host, ipaddr=ip)

    groups = HostGroup.objects.all()
    return render(request, 'addhosts.html', {'groups': groups})
8、修改addhosts.html模板，在form表单中加入以下内容
{% csrf_token %}
否则在提交表单时，将会出现CSRF错误。这一项是防止跨站攻击的。
#############################################################################
● 创建“添加模块”页
1、编写URL
    url(r'^addmodules/$', views.addmodules, name='addmodules'),
2、编写视图函数
def addmodules(request):
    return render(request, 'addmodules.html')
3、编写addmodules.html模板
{% extends 'base.html' %}
{% load staticfiles %}
{% block title %}添加模块{% endblock %}
{% block content %}
    <form action="" method="post" class="form-inline" style="margin-bottom: 10px">
        {% csrf_token %}
        <div class="form-group">
            <label>模块：</label>
            <input class="form-control" type="text" name="module">
        </div>
        <div class="form-group">
            <label>参数：</label>
            <input class="form-control" type="text" name="arg">
        </div>
        <div class="form-group">
            <input class="btn btn-primary" type="submit" value="提 交">
        </div>
    </form>
{% endblock %}
4、修改index.html的超链接
<a href="{% url 'addmodules' %}">
5、修改addmodules函数，取出模块信息，发给模板
def addmodules(request):
    mods = AnsiModule.objects.all()
    return render(request, 'addmodules.html', {'mods': mods})
6、修改addmodules.html模板文件，在form表单下加入表格
<table class="table table-bordered table-striped table-hover">
    <tr class="info">
        <th>模块</th>
        <th>参数</th>
    </tr>
    {% for mod in mods %}
        <tr>
            <td>{{ mod.module_name }}</td>
            <td>
                <ul class="list-unstyled">
                    {% for arg in mod.modulearg_set.all %}
                        <li>{{ arg.arg_text }}</li>
                    {% endfor %}
                </ul>
            </td>
        </tr>
    {% endfor %}
</table>
7、修改addmodules函数，支持添加模块
def addmodules(request):
    if request.method == 'POST':
        mod = request.POST.get('module')
        arg = request.POST.get('arg')
        if mod.strip():
            ansi_mod = AnsiModule.objects.get_or_create(module_name=mod)[0]
            if arg.strip():
                ansi_mod.modulearg_set.get_or_create(arg_text=arg)

    mods = AnsiModule.objects.all()
    return render(request, 'addmodules.html', {'mods': mods})
#############################################################################
● 编写执行任务页面
1、URL
    url(r'^tasks/$', views.tasks, name='tasks'),
2、修改index.html的超链接
<a href="{% url 'tasks' %}">
3、编写tasks视图函数
def tasks(request):
    groups = HostGroup.objects.all()
    mods = AnsiModule.objects.all()
    context = {'groups': groups, 'mods': mods}
    return render(request, 'tasks.html', context)
4、编写tasks.html模板
{% extends 'base.html' %}
{% block title %}执行任务{% endblock %}





