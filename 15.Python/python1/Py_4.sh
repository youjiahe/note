Python自动化运维 day04
1.shell相关模块
  1.1 shutil模块
2.字符串操作

##############################################################################
shell相关模块——shutil模块
● 复制和移动
   — copyfileobj()
	   	copyfileobj(fsrc,fdst[,length])  
	   	接收文件对象
		fsrc需要读权限，fdst需要写权限
   — copyfile()
	   	copyfile(src,dst)  
	   	只需要写入源文件及目标文件的路径即可
	   	src，dst都必须是文件
   — copy()
		copy(src,dst)    
		将文件src复制到文件或目录dst。src和dst应为字符串。
		允许dst值写目录名
   — copy2()
		与copy一样，但它会复制元数据
	— move()
		move(src,dst) 
		将 src 移动到 dst
		功能与mv命令一样
	— copytree()
	   copytree(src,dst)
  	    递归的复制src目录到dst目录 
  	— rmtree()
  		rmtree('path')
  		删除目录
		
	#!/usr/bin/env python3
	import shutil
	shutil.copyfileobj(open('/etc/passwd','rb'),open('/opt/test/passwd','wb'))
	shutil.copyfile('/etc/passwd','/opt/test/mima1.txt')
	shutil.copy('/etc/passwd','/opt/test/')
	shutil.copy2('/etc/shadow','/opt/test/')
	shutil.move('/tmp/mima2.txt','/opt/test')
	shutil.move('/tmp/tmo','/opt/test')
	shutil.copytree('/etc/yum.repos.d/','/opt/test/repo')
	shutil.rmtree('/opt/test/repo')
	
##############################################################################	
shell相关模块——shutil模块
● 权限操作
  — copymode()
     将权限位从src复制到dst。
     所有者，属组不受影响
  — copystat()
	 将权限位,最后访问时间,上次修改时间和标志从 src 复制到 dst。 
	 src  dst 都可以是目录
  — chown()
  	  更改给定路径的所有者用户和/或组
  	  
	shutil.copymode('/etc/shadow','/opt/test/1.txt')
	shutil.copystat('/etc/shadow','/opt/test/1.txt')	
	shutil.chown('/opt/test/1.txt',user='root',group='unbound')
##############################################################################
赋值方式
● 多元赋值
	>>> (x,y,z)=(1,2,3)
	>>> x
	1
	>>> y
	2
	>>> z
	3
	>>> x,y,z
	(1, 2, 3)
	>>> x,y,z=1,2,3
	
  & 多元赋值经典用法——交换变量
    ——传统写法，借助第三个变量
		>>> a=10
		>>> b=20
		>>> tmp=a
		>>> a=b
		>>> b=tmp
		>>> a
		20
		>>> b
		10
    ——多元赋值
		>>> a,b=b,a
		>>> a
		10
		>>> b
		20

##############################################################################
shell相关模块——语法风格

● 标识符——用户自定以的函数、变量
● 关键字——系统列表、函数
   & 判断是否为关键字
   
   #!/usr/bin/env python3
   import keyword
	print(keyword.iskeyword('if'))
	print(keyword.iskeyword('IF'))
	
	输出结果：
	True
	False

● 内建
   — python已经定义好的函数或者变量
##############################################################################
shell相关模块——模块结构及布局

	#!/usr/bin/env	python					#起始行
	“this	is	a	test	module”		   #模块文档字符串
	import	sys									#导入模块
	import	os	
	debug	=	True						   #全局变量声明
	class	FooClass(object):		      #类定义
	'Foo	class'	
					pass	
	def 	test():							#函数定义
	"test	funcDon"	
					foo	=	FooClass()	
	if	__name__	==	‘__main__’         #程序主体
	test()	
##############################################################################
● 案例1:创建文件   #有问题
	1.  编写一个程序,要求用户输入文件名
	2.  如果文件已存在,要求用户重新输入
	3.  提示用户输入数据,每行数据先写到列表中
	4.  将列表数据写入到用户输入的文件名中

	步骤1：先把和层序结构写出来
	步骤2：详细写函数的逻辑
	步骤3：写程序主体

	#os.path.exists()  用于判断某那个路径是否存在
	#!/usr/bin/env python3
	import os
	import shutil
	def get_path():
		while True:
		    file_path=input('新建文件路径：')
		    if not os.path.exists(file_path):
		        return file_path
		        break
		    else:
		        print('%s already exists!' % file_path)
		        exit()
	def get_context():
		context=[]
		text=''
		print('请输入文件内容:')
		while True:
		    text=(input('>'))
		    if text=='quit':
		        break
		    context.append(text)
		context = ['%s\n' % l for l in context]
		return context

	def write_file(files,t1):
		path=open(files,'w')
		path.writelines(t1)
		path.close()

	if __name__=='__main__':
		path=get_path()
		t=get_context()
		write_file(path,t)

##############################################################################
字符串详解
● 序列类型操作符
   切片、重复打印‘*’ 、拼接、 in 、 not in

● 序列内建函数
 — list()    #列出序列所有元素
 — str()     #序列转字符串
 — tuple()   #与list一样
 — len()     #统计序列长度
 — max()     #返回最大值
 — enumerate()    #枚举对象，返回索引值以及索引值对应的值
 — reversed()     #接受一个序列作为参数,返回一个以逆序访问的迭代器
 — sorted()       #接受一个可迭代对象作为参数,返回一个有序的列表,按照ascii表排序   
 
	>>> list('allow')
	['a', 'l', 'l', 'o', 'w']      #字符串
	>>> list(['access','allow'])   #列表
	['access', 'allow']

	>>> str(True)                 #转字符串
	'True'
	>>> str(123456)
	'123456'
	>>> str([1,2,3,4])
	'[1, 2, 3, 4]'
	
	>>> len('hello')
	5	
	>>> max('hello')
	'o'

	>>> for i,j in enumerate('abc'):
	...     print('index:'+str(i),j)
	... 
	index:0 a
	index:1 b
	index:2 c
  
	>>> for i in reversed([1,2,3,4]):
	...     print(i)
	... 
	4
	3
	2
	1

	>>> sorted('china')
	['a', 'c', 'h', 'i', 'n']

##############################################################################
案例2:检查标识符
	1.  程序接受用户输入
	2.  判断用户输入的标识符是否合法
	3.  用户输入的标识符不能使用关键字
	4.  有不合法字符,需要指明第几个字符不合法
	
	#!/usr/bin/env python3
	from string import digits,ascii_letters
	def var_j(st=''):
		var_ok_str=digits+ascii_letters+'_'
		first_ok=ascii_letters+'_'
		locat=[]
		c=0
		for i,j in enumerate(st):
		    index=i+1
		    if j not in var_ok_str:
		        print('第%d个字符非法' % index)
		        c += 1
		    elif i==0 and j not in first_ok:
		        print('\033[31m首字符不正确！\033[0m')
		        break
		else:
		    if c==0:
		        print('\033[32m变量合法\033[0m')


	if __name__=='__main__':
		data = input('输入一个变量名')
		var_j(data)
		
	#运行程序：	
	输入一个变量名you(*1suho&^
	第4个字符非法
	第5个字符非法
	第11个字符非法
	第12个字符非法
##############################################################################
传参方式
格式化操作符
● 字符串可以使用格式化符号来表示特定含义
	%s   优先用str()函数进行字符串转换   
	%d   转成有符号十进制数                
	%f   转成浮点数         
	
● 格式化字符串
   模板 % 参数 或  模板  %  (参数1，参数2，......)
   模板就是一个包含格式符的字符串
   格式符：%s,%d,%f
   运行格式化字符串时，将参数按顺序传入格式符
   注意：参数与格式符数量要一致	           
        
	>>> '%d/%d/%d %d:%d' % (2018,11,12,15,35)
	'2018/11/12 15:35'

	>>> '%f'  % 9.0890
	'9.089000'
	>>> '%f'  % 9
	'9.000000'
	
	>>> 'hello %s' % 'world'
	'hello world'

##############################################################################
传参方式
● format 函数
  & 传参
	>>> 'n {},y {}'.format('you',25)                #‘{}’ 传参
	>>> 'n {na},y {age}'.format(na='you',age=25)    # 数名传参
	>>> 'n {0[0]},y {0[1]}'.format(['you',24])      #列表传参
  & 对齐方式
	– 语法格式 {:[填充字符][对齐方式 <^>][宽度]}
	
	>>> '{:-^20}'.format('hello')    
	'-------hello--------'
	>>> '{:-<20}'.format('hello')
	'hello---------------'
	>>> '{:->20}'.format('hello')
	'---------------hello'
##############################################################################
案例4:格式化输出
	1.  提示用户输入(多行)数据
	2.  假定屏幕的宽度为50,用户输入的多行数据如下显示(文本内容居中):	
	
	#!/usr/bin/env python3
	from day4_anli1 import get_context    #从案例1导入模块
	def creen(st):
		print('+{}+'.format('*'*50))
		for i in st:
		    print('+{:^50}+'.format(i))
		print('+{}+'.format('*'*50))

	if __name__=='__main__':
		t=get_context()
		creen(t)
		
	#运行程序：
	请输入文件内容:
	>hello world!
	>great work!
	>find my way
	>quit
	+**************************************************+
	+                   hello world!                   +
	+                   great work!                    +
	+                   find my way                    +
	+**************************************************+	
	
##############################################################################
字符串操作 方法函数
& r      #打印原始字符串,加上‘r’，不执行任何的特殊字符，如‘\n \r \t’
	>>> print(winpatch)
	C:\windows
	ewfile	
	>>> winpatch=r'C:\windows\newfile'  
	>>> print(winpatch)
	C:\windows\newfile
	
& title() #首字母大写	
	>>> mystr='hello world'
	>>> print(mystr.title())
	Hello World
	
& center() #居中  宽度 填充字符
	>>> print(mystr.center(50,'*'))  #居中  宽度  填充字符
	*******************hello world********************

& count()
	>>> strg='this is a test string.'
	>>> print(strg.count('is'))
	2
	>>> print(strg.count('is',4,-1))
	1

& endswith() #判断结束字符串
	>>> strg='this is a test string'
	>>> print(strg.endswith('ing'))
	True
	>>> print(strg.endswith('g'))
	True
	>>> print(strg.endswith('is',0,4))
	True
	>>> print(strg.endswith('is',0,5))
	False

& upper()   #小写--->大写
& lower()   #大写--->小写
& isupper() #字符串是否全为大写
& islower() #字符串是否全为小写
& isdigit() #字符串是否为数字
& isalpha() #字符串是否为字母
	>>> mystr='123456'
	>>> print(mystr.isdigit())
	True
	>>> mystr='abc'
	>>> print(mystr.isalpha())
	True
	>>> print(mystr.islower())
	True
	>>> mystr='ABC'
	>>> print(mystr.isupper())
	True

& split()  #分隔字符串	
	>>> print(mystr.split(' '))
	['this', 'is', 'a', 'test', 'string']
	>>> print(mystr.split(' ',2))   #以‘ ’为分割符，最多分隔2次
	['this', 'is', 'a test string']

& strip()  #去除字符串两端的空格
	>>> mystr='  hello   '
	>>> print(mystr.strip())
	hello
& join()
	>>> list=list('hello')
	>>> list
	['h', 'e', 'l', 'l', 'o']
	>>> str=''
	>>> print(str.join(list))
	hello

##############################################################################	
列表操作 方法函数		
& append()  #向列表末尾追加一个元素
   >>> alist=[1,2,3]
	>>> alist.append(4)
	>>> alist.append([5,6])  #追加整个元素
	>>> print(alist)
	[1, 2, 3, 4, [5, 6]]

& pop()     #删除列表末尾的元素

& extend()  #使用序列扩展列表，向列表末尾，追加序列中的元素
 	>>> alist=[1,2,3]
	>>> alist.extend([4,5,6])  #追加列表序列里面的元素
	>>> print(alist)
	[1, 2, 3, 4, 5, 6]
	
& insert(index,obj)  #在index位置插入对象obj
	>>> alist=[1,2,3]
	>>> alist.insert(0,0)   #在索引 0 前插入 0
	>>> alist.insert(-1,4)  #索引值为-1时，会在最后一个元素前插入；若想在末尾插入，则用append
	>>> print(alist)
	[0, 1, 2, 4, 3]

& sort()     #列表元素从小到大排序
	>>> alist=[87,1,2,3,68]
	>>> alist.sort()
	>>> print(alist)
	[1, 2, 3, 68, 87]
	
& reverse()  #把列表元素反转输出
	>>> alist=[87,1,2,3,68]
	>>> alist.reverse()
	>>> print(alist)
	[68, 3, 2, 1, 87]
	
& index()    #返回元素对应的索引值
	>>> print(alist)
	[68, 3, 2, 1, 87]
	>>> print(alist.index(2))
	2
	

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
