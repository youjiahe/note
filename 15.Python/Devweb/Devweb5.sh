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
		>>> f1 = Questions.objects.filter(question_text__endswith='?')`
   





































	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
