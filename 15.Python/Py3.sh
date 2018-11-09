Python自动化运维 day03
1.for循环
   1.1 for循环结构
   1.2 range函数
   1.3 列表解析
2.文件对象
   2.1 文件打开关闭方法  open/close/with
   2.2 文件输入          read/readline/readlines
   2.3 文件输出          write/writelines
   2.4 操作文件          seek/tell
3.函数基础   def
4.模块基础
  4.1 定义模块
  4.2 使用模块
##############################################################################
●批量缩进
   选中---->TAB
   取消缩进 选中---->ctrl+TAB
●批量注释
   选中---->ctrl+/
##############################################################################
for 循环   
●语法：
for 变量列表 in 可迭代对象:
    for_suit
●可迭代对象:字符串  列表  元组   字典
●迭代/遍历：使用for循环查找可迭代对象的每一个元素
  — for循环会先从可迭代对象中取出每一个元素、依次和变量列表的变量绑定
  — for循环的次数与可迭代对象元素的个数相等
  — for变量列表需要真实存在的，尽量使用新的变量循环
  
●注意事项：
  — 如果使用for循环遍历一个空的可迭代对象，循环不会执行，对应的变量也可能不会创建
  — 数字不是可迭代对象； not iterrable ---->不可迭代
●例子 
	>>> for ch in 'abcd':
	...     print(ch)
	... 
	a
	b
	c
	d

	>>> for i in [1,2,3,4,5]:  #数字的迭代使用列表/元组
	...     print(int(i))
	... 
	1
	2
	3
	4
	5    
	>>> for i in 100:       #数字不可迭代
	...     print(i)
	... 
	Traceback (most recent call last):
	  File "<stdin>", line 1, in <module>
	TypeError: 'int' object is not iterable
##############################################################################
range函数
	range(start,end)和切片相同，不包含结束值
	返回以和可迭代的整数序列，通常和for循环搭配使用
##############################################################################
for循环  range函数
●案例1：
   打印数字1～20
	>>> for i in range(1,21):
	...     print(i,end=' ')
	... else:
	...     print('')
	... 
	1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 
	>>> 
##############################################################################
for循环  方法：列表.append 
#!/usr/bin/env python3
●案例2：斐波那契数列 ----- 最后一个数总是前两个书之和
	#初始化列表 fibs=[0,1]
	#fibs[0,1,1]
	#fibs[0,1,1,2]
	#fibs[0,1,1,2,3]
	#使用append方法进行添加   列表名.append(列表值)

	fibs=[0,1]
	for i in range(10):  #追加10个元素
		fibs.append(fibs[-2]+fibs[-1])
		
	print(fibs)

	结果：
	[0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89]

##############################################################################
for循环
●案例3： 99乘法表
&打印方法1：  print拼接
	#/usr/bin/env python3
	end=9
	for i in range(1,end+1):
		for j in range(1,i+1):
		    if i*j<10:
		        print(j, '×', i, '=', i * j, sep='', end='  ')
		     
		    else:
		        print(j,'×',i,'=',i*j,sep='',end=' ')
		print('')
		
&打印方法2：  用结构化字符串打印    '%d×%d=%d' % (j,i,i*j)
	#/usr/bin/env python3
	end=9
	for i in range(1,end+1):
		for j in range(1,i+1):
		    if i*j<10:
		        print('%d×%d=%d' % (j,i,i*j),end='  ')
	#            print(j, '×', i, '=', i * j, sep='', end='  ')
		    else:
		        print('%d×%d=%d' % (j,i,i*j),end=' ')
	#            print(j,'×',i,'=#',i*j,sep='',end=' ')
		print('')

	1×1=1  
	1×2=2  2×2=4  
	1×3=3  2×3=6  3×3=9  
	1×4=4  2×4=8  3×4=12 4×4=16 
	1×5=5  2×5=10 3×5=15 4×5=20 5×5=25 
	1×6=6  2×6=12 3×6=18 4×6=24 5×6=30 6×6=36 
	1×7=7  2×7=14 3×7=21 4×7=28 5×7=35 6×7=42 7×7=49 
	1×8=8  2×8=16 3×8=24 4×8=32 5×8=40 6×8=48 7×8=56 8×8=64 
	1×9=9  2×9=18 3×9=27 4×9=36 5×9=45 6×9=54 7×9=63 8×9=72 9×9=81
##############################################################################
for循环
●列表解析
 & 结构
  [ 表达式  for 变量列表 in 可迭代对象 if 条件表达式 ]


●案例4：把1～20放到列表里面
	& 方法一:
	>>> for i in range(1,21):
	...     alist.append(i)
	... 
	>>> alist
	[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20]

	& 方法二：
	>>> [i for i in range(1,21)]
	[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20]

	& 打印偶数：
	>>> [ i for i in range(1,21) if i%2==0]
	[2, 4, 6, 8, 10, 12, 14, 16, 18, 20]

##############################################################################
文件对象
文件打开方法
●open()内键函数
  & 基本语法:
   file_object = open(file_name, access_mode='r', buffering=-1)	
   //access_mode:文件访问模式
    //文件访问模式：
    r  读      文件不存在报错  #默认
    w  写      文件不存在创建文件，存在则先清空再写入
    a  追加    文件不存在创建文件，像文件末尾写入内容
     +  读写模式
    b  二进制模式
  &例子
  —  打开和关闭文件
  >>> files=open('/root/git/sh/host.txt','r')
  >>> files.close()
  >>> files
  <_io.TextIOWrapper name='/root/git/sh/host.txt' mode='r' encoding='UTF-8'>
##############################################################################
文件对象
文件输入
●read()
 & read(size)
    — size代表字节数、默认读取全部文件内容,作为一个字符串返回
    — size默认-1
 & 注意事项;
    — 打开文件后会有一个指针，指针会根据用户操作移动，读写通常是针对指针后面的文件内容
    — 如果读取全部文件内容，指针会移动到文件的最后，这是再读取文件，指针后没有内容，返回空字符串
    
 & 例子：
  >>> files=open('/root/git/sh/host.txt')
  >>> files.read()
  '192.168.1.11\n192.168.1.12\n192.168.1.13\n192.168.1.14\n192.168.1.15\n192.168.1.16\n192.168.1.20\n'
  >>> files.read()
  ''                        #因为读取了一编、指针位置移动到最后面，内容为空，因此结果是空
  >>> files.close()


●readline()
 & readline(size)
    — size代表字节数、默认读取整行
    — size默认-1

●readlines()
 & readlines()
    — 读取所有行(剩余的),把它们作为一个列表返回
    — 指定数字，则读取一行
    
 &例子：  readline、readlines
  [root@room9pc01 ~]# cp /etc/passwd /opt/passwd
  [root@room9pc01 ~]# python3
  >>> passwd=open('/opt/passwd')
  >>> passwd.readline()                  #读1行
  'root:x:0:0:root:/root:/bin/bash\n'
  >>> passwd.readline(5)                 #读取5个字符
  'bin:x'
  >>> passwd.readlines()                 #剩余的所有行，与read有区别，read是整一篇文档内容
  [':1:1:bin:/bin:/sbin/nologin\n', ......
  ........ ..'.........................\n']        

##############################################################################
文件输出
write方法
●write()
  — 文件对象的访问模式需要支持写入
  — 默认情况下文件的写入不会立即生效，需要文件对象关闭后生效
  — 写入文件时,不会自动添加行结束标志,需要程序员手工输入
  
●writelines()
  — 和readlines()一样,writelines()方法是针对列表的操作
  
   [root@room9pc01 ~]# cat python_test  
	#!/usr/bin/env python3
	test1
	test2
	test3
	test4
	test5
	test6
	[root@room9pc01 ~]# python3
	>>> test=open('python_test')
	>>> test.write('test10\n')
	7
	>>> test.writelines('test11\n')
	>>> data=['test12\n','test13']    #以列表的方式写入
	>>> test.writelines(data)
	>>> test.close()                  #与属性test.closed区别开来
	[root@room9pc01 ~]# cat python_test 
	#!/usr/bin/env python3
	test1
	test2
	test3
	test4
	test5
	test6
	test10
	test11
	test12
	test13
##############################################################################
操作文件
with子句
●with语句是用来简化代码的
  & 在将打开文件的操作放在with语句中,代码块结束后,
     文件将自动关闭
     
  & 例子：
	>>> with open('1.txt','w') as f:
	...     data=['line1\n','line2\n']
	...     f.writelines(data)
	... 
	>>> f.closed
	True
	>>> f=open('1.txt')
	>>> f.readlines()
	['line1\n', 'line2\n']
##############################################################################
操作文件
文件内移动
●seek()
  & seek(offset[,whence])
      — 移动文件指针到不同的位置
     — offset是相对于某个位置的偏移量,也就是代表需要移动偏移的字节数。
     — whence，0-开头，1-当前位置，2-文件的结尾
●tell()
 & tell()
      — 	返回当前文件指针的位置
      
      
  & 例子：
	>>> with open('1.txt','rb') as f:    #必须以二进制方式打开文件，seek才有效
	...     f.seek(-20,2)  #移动到文档最后，再往前20个字符
	...     f.read()       #读取文档最后20个字符
	...     f.seek(3)      #直接移动到指针位置3
	...     f.tell()
	11
	b'\nline3\nline4\nline5\n\n'
	3
    3
##############################################################################
●文件对象是可迭代的
	>>> f=open('1.txt')
	>>> for line in f:
	...     print(line)
	... 
	line1

	line2

	line3

	line4

	line5

	line6
##############################################################################
●案例7:模拟cp操作
	1.  创建cp.py文件
	2.  将/bin/ls“拷贝”到/root/目录下
	3.  不要修改原始文件
	
	#!/usr/bin/env python3
	src_obj = open('/bin/ls','rb')    #以二进制的方式打开文件，不会有编码问题
	dst_orj = open('/root/ls','wb')

	while True:
		data=src_obj.read(4096)   #只读取4k数据
		if not data:
		    break
		dst_obj.write(data)

	src_obj.close()
	dst_obj.close()
##############################################################################
函数基础
●python中的函数
  — 函数一般是实现某种功能的代码
  — 作用：1.减少代码额的重复使用；

●函数语法格式:
def 函数名:(参数列表)
    '文档字符串'
    fun_suit
    
●函数注意事项：
   & 函数名要求同变量名
   & 写在函数内的变量，在调用之后会被释放 
   
●return
 — 返回一个结果
 — 函数中如果没有return语句，默认在结尾添加"return None"

●例子：
1.hello world!
	----------------------------------------
	#!/usr/bin/env python3
	def hello():
		print('hello world!')
	hello()                      #调用函数
	print(hello)
	----------------------------------------

	输出结果：
	hello world!                 #调用函数结果
	<function hello at 0x7f71a4fcaea0>   #该函数在内存的位置

2.return
	#!/usr/bin/env python3
	def fun():
		res = 3+4
		return res     #在调用函数的地方返回一个结果
	print(fun())      #相当于print(7)
	print(fun()*2)    #相当于print(7*2)

    输出结果：
	7
	14

2.1 return None
	#!/usr/bin/env python3
	def fun():
		res=10000+5000
	print(fun())

	输出结果：
	None
##############################################################################
函数基础
函数中的参数
形参、实参
●函数中的参数
  参数是函数运行时必须要的值
  
●参数分为两种：形式参数(形参) 和 实际参数(实参)
  — 形参是定义函数是写在()中的参数
  — 实参是条用函数时写在()中的参数

●例子: 
  &斐波那契数列函数  #传参，传一个
	#!/usr/bin/env python3	
	def fib(num):
		fibs=[0,1]
		for i in range(num-2):  #追加10个元素
		    fibs.append(fibs[-2]+fibs[-1])
		print(fibs)
	fib(4)
	fib(15)
	
  & 拷贝文件		
	#!/usr/bin/env python3
	def copy(src,dst):
		src_obj = open(src,'rb')   #以二进制的方式打开文件，不会有编码问题
		dst_obj = open(dst,'wb')
		while True:
		    data=src_obj.read(4096)   #只读取4k数据
		    if not data:
		        break
		    dst_obj.write(data)

		src_obj.close()
		dst_obj.close()

	copy('/bin/ls','/opt/ls1')
	copy('/bin/ls','/opt/ls2')
##############################################################################
函数中的参数  sys.argv  sys模块argv列表
●位置参数
  — 与shell脚本类似,程序名以及参数都以位置参数的方式
     传递给python程序
  — 使用sys模块的argv列表接收
	
●例子：
  & 把位置变量打印出来，以列表的方式
  -----------------------------------------------
	#!/usr/bin/env python3
	import sys
	print(sys.argv)
  ------------------------------------------------
	[root@room9pc01 python3]# python3 sys_argv.py you jia he
	['sys_argv.py', 'you', 'jia', 'he']

  & 拷贝文件
  ----------------------------------------------------------------
	#!/usr/bin/env python3
	import  sys
	def copy():
		src_obj = open(sys.argv[1],'rb')   #以二进制的方式打开文件，不会有编码问题
		dst_obj = open(sys.argv[2],'wb')

		while True:
		    data=src_obj.read(4096)   #只读取4k数据
		    if not data:
		        break
		    dst_obj.write(data)

		src_obj.close()
		dst_obj.close()
	copy()
   ----------------------------------------------------------------
	[root@room9pc01 python3]# python3 fun_argv_copy.py /etc/passwd /python/passwd
	[root@room9pc01 python3]# ls /python/passwd 
	/python/passwd
	[root@room9pc01 python3]# ll /python/passwd 
	-rw-r--r-- 1 root root 2180 11月  9 17:32 /python/passwd
##############################################################################
函数基础
函数中的参数
●默认参数
  默认参数就是声明了默认值的参数
●例子：
  & 打印*号，默认打印30个
	#!/usr/bin/env python3
	def pstar(num=30):
		print('*'*num)
	pstar()
	pstar(5)
   
	输出结果:
	******************************
	*****
##############################################################################
模块基础
定义模块
●模块基本概念
  — 模块是从逻辑上组织python代码的形式
●创建模块注意事项
  — 模块名称以 .py结尾
  — 模块名称不要与系统中存在的重名
  — 模块文件名字去掉后面的(.py)即为模块名

●导入模块(import)
  import  模块名
  from 模块名  import 属性
  
●例子：
   & 制作斐波那契数列模块
   
   [root@room9pc01 python3]# cp mod_fibs.py /usr/local/lib/python3.6/
   --------------------------------------------------------------
	#!/usr/bin/env python3
	import mod_fibs                #导入整个mod_fibs模块
	import mod_fibs as f           #导入整个mod_fibs模块，取别名
	from mod_fibs import fib       #导入模块mod_fibs的fib属性

	mod_fibs.fib()
	f.fib(5)
	fib(10)
    ------------------------------------------------------------
    输出结果：
	[0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89]
	[0, 1, 1, 2, 3]
	[0, 1, 1, 2, 3, 5, 8, 13, 21, 34]

	[root@room9pc01 python3]# cat mod_fibs.py   #mod_fibs模块内容
	#!/usr/bin/env python3
	def fib(num=12):
		fibs=[0,1]
		for i in range(num-2):  #追加10个元素
		    fibs.append(fibs[-2]+fibs[-1])
		print(fibs)





































