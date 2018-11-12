Python自动化运维 day04
1.shell相关模块
  1.1 shutil模块
  1.2 
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
● 案例1:创建文件
	1.  编写一个程序,要求用户输入文件名
	2.  如果文件已存在,要求用户重新输入
	3.  提示用户输入数据,每行数据先写到列表中
	4.  将列表数据写入到用户输入的文件名中

步骤1：先把和层序结构写出来

#!/usr/bin/env python3
def get_name()
    #获取文件路径
























	
	
	
	
	
	
	
	
	
	
	
