Python2自动化运维 day02
1.嵌套函数
2.函数赋值
3.参数组
4.元组参数赋值 *
5.字典参数赋值 **
6.匿名函数
7.filter（）、map（）
----------------------------------------以下函数高级应用--------------非必须
8.全局变量、局部变量
9.偏函数、tkinter.Tk()
10.递归函数
11.递归排序
12.生成器
13.闭包
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

##############################################################################
● 案例1:简单的加减法数学游戏   #看day2_anli1.py脚本
	1.  随机生成两个100以内的数字
	2.  随机选择加法或是减法
	3.  总是使用大的数字减去小的数字
	4.  如果用户答错三次,程序给出正确答案

##############################################################################
● 匿名函数
lambda
lambda	[arg1[,	arg2,	...	argN]]:	expression	
	
>>>	a	=	lambda	x,	y:		x	+	y	
>>>	print(a(3,	4))	
7	
下面有例子
##############################################################################
● filter()函数
	— 调用一个布尔函数func来迭代遍历每个序列中的元素;
		返回一个使func返回值为true的元素的序列
● map()函数

	#!/usr/bin/env python3
	from random import randint
	def func1(x):
		return x%2
	if __name__ == '__main__':
		nums=[randint(1,100) for i in range(10)]
		print(nums)
		print(list(filter(func1,nums)))
		print(list(filter(lambda x:x%2,nums)))  #使用匿名函数，与使用函数是一样的结果
	   print(list(map(func2,nums)))
    	print(list(map(lambda x:x*2+1,nums)))
 	
    #运行结果：
	[45, 2, 97, 7, 70, 49, 36, 66, 91, 34]
	[45, 97, 7, 49, 91]
	[45, 97, 7, 49, 91]
	[91, 5, 195, 15, 141, 99, 73, 133, 183, 69]
	[91, 5, 195, 15, 141, 99, 73, 133, 183, 69]
##############################################################################
全局变量
局部变量
● 任何时候,总有一个到三个活动的作用域(内建、全局和局部)
	#!/usr/bin/env python3
	x=10
	def foo():
		print(x)
	def bar():
		y=100
		print(y)
	def foobar():
		x=999        # 局部变量将会遮盖住全局的x
		print(x)
	def modify():
		global x     # 声明需要使用的 x 是全局变量
		x = 'hello'  # 将全局变量x重新赋值
	# print(y)   # 错误，y是bar的局部变量，只能在bar函数中使用
	print(x)
	foo()
	bar()
	foobar()
	print(x)
	modify()
	print(x)
	
	#运行结果：
	10
	10
	100
	999
	10
	hello
##############################################################################
● 偏函数  #partial
  — 相当于改造现有函数，将现有函数的一部分参数固定下来
	#!/usr/bin/env python3
	from   functools import partial
	def add(a,b,c,d,e):
		return a+b+c+d+e
	newadd=partial(add,10,20,30,40)
	print(add(10,20,30,40,50))
	print(newadd(99))
	print(newadd(12))

	#运行结果：
	150
	199
	112	
##############################################################################
● tkinter模块、偏函数  #脚本请看  tkinter_test.py

	如果没有tkinter，需要重新编译python
	https://www.python.org/
	# yum install -y tcl-devel tk-devel sqlite-devel
	# tar xzf Python-3.6.1.tar.xz
	# cd Python
	# ./configure --prefix=/usr/local/
	# make
	# make install
	安装完成后，如果pycharm中无法导入，可以重启pycharm

##############################################################################
● 递归函数
def func(num):
    if num==1:
        return 1
    return num*func(num-1)
            #4*func(3)
            #4*3*func(2)
            # 4*3*2*func(1)
                # 4*3*2*1
if __name__ == '__main__':
    print(func(6))

##############################################################################
● 递归快速排序  参考 qsort.py
##############################################################################
● 生成器
	•  从句法上讲,生成器是一个带yield语句的函数
	•  一个函数或者子程序只返回一次,但一个生成器能暂
		停执行并返回一个中间的结果
	•  yield 语句返回一个值给调用者并暂停执行
	•  当生成器的next()方法被调用的时候,它会准确地从离开地方继续

	#!/usr/bin/env python3
	def mygen():
		a= 10 + 20
		yield a
		yield 'hello world'
		b='ni'+' '+'hao'
		yield b
	mg=mygen()
	print(mg.__next__())
	print(mg.__next__())
	print(mg.__next__())
	newmg=mygen()
	for i in newmg:
		print(i)
#####################################################
#########################
● 闭包    #参考脚本 tkinter_test.py
   — 难点、不是重点，需要用到的时候，再看  
   — 做成内部函数，隐藏起来 
import tkinter
def hello(word):
    def say_hi():
        lb.config(text=word)
    return say_hi         #没有加()

##############################################################################
装饰器  参考set_coloar.py





































