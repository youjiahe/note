Python2自动化运维 day02
##############################################################################	
● 松散、耦合
##############################################################################
函数基础
● 前向引用
•  函数不允许在函数未声明之前对其进行引用或者调用解
	def foo():	
		print('in	foo')	
		bar()	
	foo()	   #报错,因为bar没有定义
	--------------------------------------------------------------------	
	def	 foo():	
		print('in	foo')	
		bar()	
	
	def bar():	
		print('in	bar')	
	foo()			#正常执行,虽然bar的定义在foo定义后面	

● 内部函数
	— 函数内部嵌套的函数，只能在函数内部调用

● 函数赋值
	— 形参与实参数量要一致，类型要匹配
	— 也可以用形参名字赋值:
    #定义一个函数
	#!/usr/bin/env python3
	def set_info(name,age):
		print('%s years old is %d' % (name,age))

  & 关键字传参
	set_info(age=23,name='bo')
  & 列表传参
	alist=['bobo',25]
	#set_info(alist)   #报错，因为age没有给值
	set_info(*alist)   #成功，加一个'*'号

● 参数组
  & *元组参数赋值  
	#!/usr/bin/env python3
	def mytest(*args):  #*表示元组
		print(args)
	mytest('uuu','ooo')
	mytest(10)
	mytest(('yy','qq'))

	#运行结果：
	('uuu', 'ooo')
	(10,)
	(('yy', 'qq'),)

  & **字典参数赋值
	#!/usr/bin/env python3
	def mydict(**dit):   #**表示字典
		print(dit)
	mydict()
	mydict(name='bob',age=25)
	
	#运行结果：
	{}
	{'name': 'bob', 'age': 25}




















