Python2自动化运维 day02
1.模块
2.包
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























































