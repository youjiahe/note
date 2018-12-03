运维开发实战
NSD DEVweb DAY04
Django 有很多资料
1. Django API
2. 视图和模板
3. 使用表单

https://docs.djangoproject.com/zh-hans/2.0/  #django中文文档  最下面 '开始'
##############################################################################	
Django API
● 启动python shell
	(djenv) [root@room9pc01 mysite]# python manage.py shell
● 导入数据库模型
	>>> from poll.models import Questions,Choice
● 使用模型管理器
	每一个模型默认都有一个叫做objects的管理器、通过他，可以对模型实现增删改查，返回
	Questions,Choice所有对象的查询集
	
	>>> Questions.objects.all()
	>>> Choice.objects.all()
##############################################################################
Django API
创建
● 创建Question对象
   & 方法1： #通过类的实例化创建 
   >>> q1 = Questions(question_text='你的期望岗位是什么？',pub_date='2018-12-1')
	>>> q.save()
   
   & 方法2： #通过管理器创建
   >>> Questions.objects.create(question_text='你掌握哪个章节的知识比较牢固？',pub_date='2018-11-5')
   
● 创建Choice对象
	& 方法1： #通过类的实例化创建 
	>>> c1=Choice(choice_text='运维开发工程师',vote='0',question=q1)
	>>> c1.save()

	& 方法2： #通过管理器创建
	>>> Choice.objects.create(choice_text='运维工程师',vote='0',question=q1)
	
	& 方法3： #通过问题创建选项
	>>> q1.choice_set.create(choice_text='系统运维工程师',vote='0')
##############################################################################	
Django API
改
● 修改内容
	>>> q3 = Questions(question_text='你心仪的公司是拿家？',pub_date='2018-12-1')
	>>> q3.save()
	>>> q3.question_text='你希望拿到哪家公司的offer？'
	>>> q3.save()
	
	>>> q1 = Questions.objects.get(id=1)
	>>> q1.question_text = '你希望毕业后薪资是多少?'
	>>> q1.save()

##############################################################################
Django API
查
● 查询内容
	>>> Questions.objects.all()  #查看所有
	>>> q1 = Questions.objects.get(id=1)
	>>> q2 = Questions.objects.get(question_text='你掌握哪个章节的知识比较牢固？')
	>>> q3 = Questions.objects.get(id__gt=3)  #报错，因为返回的查询集中的对象不只一个
##############################################################################	
Django API
●排序 返回查询集
	>>> qset1 = Questions.objects.order_by('pub_date')
	>>> qset1   #返回一个 查询集
	>>> q0 = qset1[0] 
	>>> q0      #返回第一个实例对象
	>>> q1 = qset1[len(qset1)-1] 
	>>> q1      #返回最后一个实例
##############################################################################
Django API
●filter 过滤 返回查询集
    #双下划线是属性，如字符串的属性有endswith，
	& 标准写法：
		>>> f0 = q3.question_text.endswith('?')
		>>> f0
	& django 中的写法： 
		>>> f1 = Questions.objects.filter(question_text__endswith='?')
   
##############################################################################
Django API
●重新导入，测试新添加的函数	
	#在models.py中添加 一个函数 
	# 判断时间是否为最近7天的
    def was_pub_curentlly(self,days=7):
        return self.pub_date > timezone.now() - timedelta(days=days)
        
	>>> from poll.models import Question, Choice
	>>> qset = Question.objects.all()
	>>> q1 = qset[0]
	>>> q1.was_pub_recently()
	>>> q1.pub_date
	>>> qset1 = Question.objects.filter(pub_date__month=10)
	>>> q2 = qset1[0]
	>>> q2.pub_date
	datetime.datetime(2018, 10, 30, 12, 0)
	>>> q2.was_pub_recently()
	False
##############################################################################
视图和模板
● 编辑index视图，返回所有的问题给模板
   # vim poll/views.py
   from django.shortcuts import render,HttpResponse
	from .models import Questions
	def index(request):
		questions = Questions.objects.order_by('pub_date')
		return render(request,'index.html',{'questions':questions})
		
● 编辑模板，显示问题  #页面结果与命令行的一样
	# vim poll/templates/index.html
	<!DOCTYPE html>
	<html lang="en">
	<head>
		<meta charset="UTF-8">
		<title>投票首页</title>
	</head>
	<body>
	<h1>这是投票首页</h1>
	{{ questions }}
	</body>
	</html>

● 使用模板与的常用语法
	<body>
	<h1>这是投票首页</h1>
	<hr>
	{% for question in questions %}
		{% if question.was_pub_recently %}
		    <p><a href="/poll/{{ question.id }}">{{ question.question_text }}</a> {{ question.pub_date }}</p>
		{% endif %}
	{% endfor %}
	<hr>
	{% for question in questions %}
		{% if question.was_pub_recently %}
		    <p>{{ question.question_text }} {{ question.pub_date }}</p>
		{% endif %}
	{% endfor %}
	<hr>
	{% for question in questions %}
		<p>{{ question.question_text }} {{ question.pub_date }}</p>
	{% endfor %}
	<hr>
	<p>{{ questions }}</p>
##############################################################################
● 规划详情页
(1)编辑urls.py
	urlpatterns = [
		url(r'^$', views.index, name='index'),
		url(r'^(?P<question_id>\d+)/$', views.detail, name='detail'),
]
	//使用\d+匹配问题编号，然后把这个编号保存到一个名为question_id的变量中，交给
	views.detail函数，作为它的参数
	
(2)创建函数
	def detail(request, question_id):
		question = Question.objects.get(id=question_id)
		return render(request, 'detail.html', {'question': question})
		
(3)修改index.html视图
	将
	{% for question in questions %}
		<p><a href="/poll/{{ question.id }}/" target="_blank">{{ question.question_text }}</a> {{ question.pub_date }}</p>
	{% endfor %}
	近一步修改为
	{% for question in questions %}
		<p><a href="{% url 'detail' question_id=question.id %}" target="_blank">{{ question.question_text }}</a> {{ question.pub_date }}</p>
	{% endfor %}

(4)创建视图
	# vim templates/detail.html
	<!DOCTYPE html>
	<html lang="en">
	<head>
		<meta charset="UTF-8">
		<title>投票详情页</title>
	</head>
	<body>
	<h1>{{ question.question_text }}</h1>
	<ul>
		{% for choice in question.choice_set.all %}
		    <li>{{ choice.choice_text }}</li>
		{% endfor %}
	</ul>
	</body>
	</html>

##############################################################################
● 规划结果页
(1)编辑urls.py
	urlpatterns = [
		url(r'^$', views.index, name='index'),
		url(r'^(?P<question_id>\d+)/$', views.detail, name='detail'),
		url(r'^(?P<question_id>\d+)/result/$', views.result, name='result'),
	]
(2)编写视图函数
	def result(request, question_id):
		question = Question.objects.get(id=question_id)
		return render(request, 'result.html', {'question': question})
(3)创建模板文件
	# vim poll/templates/result.html
	<!DOCTYPE html>
	<html lang="en">
	<head>
		<meta charset="UTF-8">
		<title>投票结果页</title>
	</head>
	<body>
	<h1>{{ question.question_text }}</h1>
	<table border="1px">
		<tr>
		    <td>选项</td>
		    <td>票数</td>
		</tr>
		{% for choice in question.choice_set.all %}
		    <tr>
		        <td>{{ choice.choice_text }}</td>
		        <td>{{ choice.vote }}</td>
		    </tr>
		{% endfor %}

	</table>
	</body>
	</html>

##############################################################################
● 为投票详情编写表单
1、修改详情页
	<body>
	<h1>{{ question.question_text }}</h1>
	<form action="/poll/{{ question.id }}/vote/" method="post">
		{% for choice in question.choice_set.all %}
		    <div>
		        <label>
		            <input type="radio" name="choice_id" value="{{ choice.id }}"> {{ choice.choice_text }}
		        </label>
		    </div>
		{% endfor %}
		<input type="submit" value="提 交">
	</form>
	</body>

2、为表单的action编写url
	from django.conf.urls import url
	from . import views

	urlpatterns = [
		url(r'^$', views.index, name='index'),
		url(r'^(?P<question_id>\d+)/$', views.detail, name='detail'),
		url(r'^(?P<question_id>\d+)/result/$', views.result, name='result'),
		url(r'^(?P<question_id>\d+)/vote/$', views.vote, name='vote'),
	]
3、表单的action可以改为以下样式
	<form action="{% url 'vote' question_id=question.id %}" method="post">
	
4、编写投票函数
	from django.shortcuts import render, redirect

	def vote(request, question_id):
		question = Question.objects.get(id=question_id)  # 获取问题
		choice_id = request.POST.get('choice_id')     # 获取选项的ID
		choice = question.choice_set.get(id=choice_id)  # 取获选项实例
		choice.vote += 1   # 将选项票数加1
		choice.save()
		# redirect是重定向，相当于是打开新的网址
		# 'result'是URL的名字，在urls.py中定义的
		return redirect('result', question_id=question_id)




























	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
