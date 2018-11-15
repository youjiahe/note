Python2自动化运维 day02
1.模块
2.包
3.编写全部备份，增量备份脚本
4.OOP基础
5.OOP进阶
   5.1组合和派生
   5.2特殊方法
晚上看看ppt、做下备份脚本
##############################################################################	
● 什么是模块
   — 模块就是python程序文件
● 模块文件
   — 模块的文件名就是模块的名字加上扩展名.py
● 名称空间
   — 默认在sys.path 列出的目录下
   — 存放模块的目录，自定义名称空间，通过全局变量 PYTHONPATH 定义
   
	[root@room9pc01 mymods]# mdkir /opt/mymods
	[root@room9pc01 mymods]# cp /root/git/python/python2/day3/randpass.py .
	[root@room9pc01 mymods]# ls
	[root@room9pc01 mymods]# export PYTHONPATH=/opt/mymods
	[root@room9pc01 mymods]# python3
	>>> import randpass
	>>> randpass.randpa()
	'ljWCUSCP'
	
● 导入模块
   — import 模块名
   — from 模块名 import 函数、方法
   ——zip导入  #了解，sys.path.append('zip路径')
##############################################################################
包——组合有联系的模块
● __init__.py
	— python2中 包目录下必须有一个__init__.py文件
	— 允许程序员把有联系的模块组合到一起
	[root@room9pc01 day3]# touch aaa/__init__.py
	[root@room9pc01 day3]# python
	>>> import aaa.hi
	>>> aaa.hi.hi
	'hello world'
● 绝对导入  import  #了解
● 相对导入  from .. import ..  #了解

##############################################################################
hashlib模块  ——内置模块
	— 专门提供hash算法，用来替换md5和sha模块
	— 单项加密：hash，哈希
	— 加密只能向一个方向进行，
		可以理解成相同的数据可以编码成固定长度的乱码，
		原数据相同，则编码也相同
		但是不能通过乱码回推原数据
● 内建函数
  m=hashlib.md5()
  m.update(data)
  m.hexdigest()
 
 &
	#!/usr/bin/env python3
	import hashlib
	with open('/etc/passwd','rb') as f:
		data=f.read()
	m=hashlib.md5(data)
	print(m.hexdigest())    #转化为16进制数
	
 & 上面方法不具有通用性。如果文件太大，就不合适了
 	#!/usr/bin/env python3
	import hashlib
	m=hashlib.md5()
	with open('/etc/passwd','rb') as f:
		while True:
		    data=f.read(4096)
		    if not data:
		        break
		    m.update(data)
	print(m.hexdigest())

##############################################################################
tarfile模块
•  tarfile模块允许创建、访问tar文件
•  同时支持gzip、bzip2格式

	#!/usr/bin/env python3
	#打tar包
	import os
	import tarfile
	tar=tarfile.open('/opt/test/systemd.tar.gz','w:gz')
	tar.add('/usr/lib/systemd/system')
	tar.close()
	#解压上面的tar包
	tar=tarfile.open('/opt/test/systemd.tar.gz','r:gz')
	os.mkdir('/opt/test/system')
	os.chdir('/opt/test/system')
	tar.extractall()
	tar.close()
##############################################################################
案例1:备份程序  #参考backup.py  晚上
	1.  需要支持完全和增量备份
	2.  周一执行完全备份
	3.  其他时间执行增量备份
	4.  备份文件需要打包为tar文件并使用gzip格式压缩

● 递归列出目录中所有内容
	>>> for path,folders,files in os.walk('/root/git/python/python2/day3/project'):
	...     for file in files:
	...         key = os.path.join(path,file)
	...         print(key)

##############################################################################
OOP基础
● 基本概念
   — 类(Class)：
      用来描述具有相同的属性和方法的对象的集合。
      它定义了该集合中每个对象所共有的属性和方法。对象是类的实例。
   — 实例化:
      创建一个类的实例,类的具体对象。
   — 方法：
      类中定义的函数。
   — 对象:
      通过类定义的数据结构实例。对象包括两个数据成员(类变量和实例变量)和方法

类是一个蓝图，实例时里面的对象           

##############################################################################
OOP基础 例子
— 创建类
— 构造器方法
	#!/usr/bin/env python3
	class BearToy:        
		def __init__(self,name,size,color):
		    #实例初始化，自动调用
		    self.name = name  #绑定属性到self，整个类中都可以用
		    self.size = size
		    self.color= color
		def sing(self):
		    print('I am %s,my color is %s' % (self.name,self.color))
	if __name__ == '__main__':
		big=BearToy('bearbig','Big','Black')   #将会调用__init__方法
		second=BearToy('bear2','Middle','Brown')
		print(big.size)
		print(big.color)
		big.sing()
		second.sing()
		
    #运行结果
	Big
	Black
	I am bearbig,my color is Black
	I am bear2,my color is Brown
##############################################################################
OOP进阶
组合和派生
特殊方法
##############################################################################
组合
● 单独的两个类相互有联系

class Vendor:
    def __init__(self,em,ph):   #加了这个厂商类
        self.email=em
        self.phone=ph
class BearToy:
    def __init__(self,name,size,color,em,ph):
        self.name = name  
        self.size = size
        self.color= color
        self.vendor=Vendor(em,ph)  #vendor这个属性，在Vendor类中定义
    def sing(self):
        print('I am %s,my color is %s' % (self.name,self.color))
if __name__ == '__main__':
    big=BearToy('bearbig','Big','Black','cloud@tedu.com','4009876543') 
    print(big.vendor.email)
    print(big.vendor.email)
##############################################################################
创建子类——继承父类的所有属性
 & 例子1：
	#!/usr/bin/env python3
	#python允许多重继承,即一个类可以是多个父类的子类,子类可以拥有所有父类的属性
	class A:
		def foo(self):
		    print('你好！')
	class B:
		def bar(self):
		    print('How are you!')
	class C(A,B):
		pass

	if __name__ == '__main__':
		c=C()      #子类的实例继承了父类的属性
		c.foo()    #先从子类查找方法 foo() ，再到父类查找
		c.bar()    #如果foo()后面还有方法，则 从左往右，到本类，父类查找

 & 例子2：
	#!/usr/bin/env python3
	class BearToy:
		def __init__(self,name,size,color):
		    #实例初始化，自动调用
		    self.name = name  #绑定属性到self，整个类中都可以用
		    self.size = size
		    self.color= color
		def sing(self):
		    print('I am %s,my color is %s' % (self.name,self.color))
		    
	class NewBearToy(BearToy):
		def __init__(self,name,size,color,date):
		    #BearToy.__init__(self,name,size,color)
		    # self.name = name
		    # self.size = size
		    # self.color= color

		    # 子类调用父类的__init__ 用super<Tab>;也可以用上面的繁琐方法
		    super(NewBearToy, self).__init__(name,size,color)
		    self.date=date

		def run(self):
		    print('I can run!')
		    
	if __name__ == '__main__':
		big=NewBearToy('bearSmall','Small','Pink','2018-11-05')   #将会调用__init__方法
		big.sing() #子类继承父类的 sing 方法，需要实例
		big.run()  #可以使用子类中的 run方法，需要实例
		print(big.date)
##############################################################################
特殊方法
__init__方法
__str__方法
__call__方法

#！/usr/bin/env python3
class book:
    def __init__(self,title,author):
        self.title=title
        self.author=author
    def __str__(self):
        return'《%s》' % self.title

    def __call__(self):
        print('《%s》的作者是%s' %  (self.title,self.author))

if __name__ == '__main__':
    b=book('Python核心编程','wesly')
    print(b)  #调用__str__()
    b()       #调用__call__()
 #运行结果：
《Python核心编程》
《Python核心编程》的作者是wesly 


& 报错1
	TypeError: __str__ returned non-string (type NoneType)
	#print('《%s》' % self.title)  #会报以上错,
	  需要改成return'《%s》' % self.title
& 报错2
	TypeError: 'book' object is not callable
	#    def __call__(self):
        print('《%s》的作者是%s' %  (self.title,self.author))

##############################################################################
特殊方法
类方法
静态方法















































