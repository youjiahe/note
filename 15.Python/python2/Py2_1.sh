Python2自动化运维 day01
1.元组
2.字典
3.案例
4.集合
5.时间函数
6.异常处理  #try  else  finally
7.文件系统 相关模块 #os模块方法
8.pickle模块
##############################################################################	
● 元组是容器、不可变、顺序访问
	>>> a=(10,)       #单元素元组，必须有个逗号
	>>> type(a)
	<class 'tuple'>
	>>> a=(10)        #单元素元组后没有逗号
	>>> type(a)
	<class 'int'>

	>>> atuple=(1,2,3,[4,5,6])  #元组不可变，元组里面的列表可变
	>>> atuple[-1].append(7)
	>>> atuple
	(1, 2, 3, [4, 5, 6, 7])

	>>> a=(100)
	>>> type(a)
	<class 'int'>
	>>> len(a)       #执行错误，因为a不是元组，是数字

● 字典是容器、不可变、映射类型
  & 创建字典

	>>> dict((['name','you'],['age',32]))  #工厂方法
	{'name': 'you', 'age': 32}
	>>> dict(['ab'])
	{'a': 'b'}
	>>> dict(['ab','cd'])
	{'a': 'b', 'c': 'd'}
	>>> dict((['ab','cd'],['ef','gh']))
	{'ab': 'cd', 'ef': 'gh'}
	>>> dict((['name','you'],['age',25]))
	{'name': 'you', 'age': 25}

  & 访问字典
	#!/usr/bin/env python3
	adict={'name':'bob','age':25}
	print('%(name)s,%(age)s' % adict)
	print(adict['name'])
	print(adict['age'])
	print('name' in adict)
	print('age' in adict)
	for i in adict:
	#    print('key:%s, value:%s' % (i,adict[i]) )
		print('key:{}, value:{}'.format(i,adict[i]))

   #运行结果:
	bob,25
	bob
	25
	True
	True
	key:name, value:bob
	key:age, value:25

 & 更新字典
	通过键更新字典
	–  如果字典中有该键,则更新相关值
	–  如果字典中没有该键,则向字典中添加新值

	adict={'name':'bob','age':25}
	adict['age']=26
	print(adict)

 & 删除字典
	•  通过del可以删除字典中的元素或整个字典
	•  使用内部方法clear()可以清空字典
	•  使用pop()方法可以“弹出”字典中的元素

##############################################################################
● 字典相关函数
dict.update({'key':'value'})
dict.get('name')
dict.keys()
dict.values()
dict.items()

● 例子:
	>>> adict={'name':'youjiahe','age':25,'email':'youjiahe@163,com'}

	>>> adict.items()
	dict_items([('name', 'youjiahe'), ('age', 25), ('email', 'youjiahe@163,com')])

	>>> adict.keys()
	dict_keys(['name', 'age', 'email'])

	>>> adict.values()
	dict_values(['youjiahe', 25, 'youjiahe@163,com'])

	>>> adict.get('email')
	'youjiahe@163,com'

	>>> adict.get('name')
	'youjiahe'

	>>> adict.update({'email':'you@126.com'})
	>>> print(adict)
	{'name': 'youjiahe', 'age': 25, 'email': 'you@126.com'}

##############################################################################
● 案例1:模拟用户登陆信息系统  #请看github   pyhon2/day1
	1.  支持新用户注册,新用户名和密码注册到字典中
	2.  支持老用户登陆,用户名和密码正确提示登陆成功
	3.  主程序通过循环询问进行何种操作,根据用户的选
	择,执行注册或是登陆操作
##############################################################################
● 案例2:编写unix2dos的程序   #
	1.  Windows文本文件的行结束标志是\r\n
	2.  类unix文本文件的行结束标志是\n
	3.  编写程序,将unix文本文件格式转换为windows文
	本文件的格式

	#!/usr/bin/env python3
	from sys import argv
	def unix2dos(fname,end='\r\n'):
		dst_fname=fname + '.txt'
		with open(fname) as src:
		    with open(dst_fname,'w') as dst:
		        for line in src:
		            dst.write(line.rstrip()+end)

	if __name__=="__main__":
		unix2dos(argv[1])
	
	[root@room9pc01 day1]# python3 python2_1_anli2.py python2_1_anli1.py 
    #做完之后验证，必须加 'rb'
	>>> with open('python2_1_anli1.py.txt','rb') as src:
	...     src.readline()
	... 
	b'#!/usr/bin/env python3\r\n'   #看到有\r\n
##############################################################################
● 案例3:编写类进度条程序 
	1.  在屏幕上打印20个#号
	2.  符号@从20个#号穿过
	3.  当@符号到达尾部,再从头开始

	#\r是回车不换行   \n是换行
	#!/usr/bin/env python3
	import time
	n = 0
	while True:
		print('{}{}\r'.format('#'*n,'@'+'#'*(19-n)),end='') 
		time.sleep(0.2)
		n +=1
		if n==20:
		    n=0
##############################################################################
● 集合

a=set('a')
b=set('b')
c=set(['abc','123',123,True])
a.add('b')            #只能添加一个元素
a.update(['c','d'])   #添加多个元素
b.update(['c','d'])  

a & b   #ab 的 交集
a | b   #ab 的 并集
a - b   #ab 的差补，即a中，与b不一样的元素集合

a.intersection(b)   #a & b
a.union(b)          #a | b
a.difference(b)     #a - b 

##############################################################################
● 案例4：对比两个文件不一样的行：

#writelines也支持集合写入
#!/usr/bin/env python3
with open('test/1.txt') as s1:
    aset=set(s1)
with open('test/2.txt') as s2:
    bset=set(s2)
with open('test/1_2_diff.txt','w+') as s3:
    s3.writelines(aset-bset)     #writelines也支持集合写入
    cset=set(s3)

print('{:*^30}'.format('aset'))
print(aset)
print('{:*^30}'.format('bset'))
print(bset)
print('{:*^30}'.format('cset'))
with open('test/1_2_diff.txt') as s4:
    cset=set(s4)
print(cset)

#运行结果：
****************************aset****************************
{'I love linux!\n', 'I love Python!\n', 'I Love GuangZhou!\n', 'hello world!\n'}
****************************bset****************************
{'I love linux!\n', 'I Love GuangZhou!\n', 'I Love Python!\n', 'Hello world!\n'}
****************************cset****************************
{'I love Python!\n', 'hello world!\n'}

##############################################################################
时间函数
● time
>>>import time
>>>time.time()      #返回当前时间戳        掌握
>>>time.ctime()     #默认返回当前时间
>>>time.ctime(0)   #计算机起始时间  'Thu Jan  1 08:00:00 1970'
>>>time.asctime()   #默认返回当前时间    
>>>time.sleep(0.3)  #睡0.3秒               掌握
>>>time.localtime() #当前时间的九元组  
>>>time.strftime('%Y-%m-%d %H:%M:%S')    #返回指定格式的时间  掌握
>>>time.strftime('%A')  #星期，单词全拼，如Tuesday  掌握
>>>time.strftime('%a')  #星期，单词缩写，如Tue      掌握
>>> time.strftime('%R')
'16:49'
>>> time.strftime('%T')
'16:49:16'
>>> time.strftime('%F')
'2018-11-13'

https://yiyibook.cn  -> python 352 文档  -> 库参考   #有一堆python模块的用法
##############################################################################
时间函数
● datetime   #掌握
>>> from datetime  import datetime,timedelta
>>> t=datetime.now()
>>> t.year
>>> t.day
>>> t.month
>>> t.second
>>> t.hour
>>> t.minute
>>> datetime.ctime(t)          #'Tue Nov 13 16:52:07 2018'
>>> t + timedelta(days=100)    # 相对当前100天后的时间
>>> t - timedelta(days=100)    # 相对当前100天前的时间
>>> datetime.now()
##############################################################################
● 异常处理

#!/usr/bin/env python3
# 异常处理，把有可能发生异常的语句放到try中执行，发生异常跳转到异常处理
# 把不生生异常才执行的语句放到else中；
# 不管是否异常与否，都执行的放到finally中
try:
    num = int(input('number:'))
    result = 100/num
except (ValueError,ZeroDivisionError):
    print('Input invalid!')
except (KeyboardInterrupt,EOFError):
    print('bye-bye')
else:
    print(result)
finally:
    print(r'Done')

##############################################################################
● 自定义异常
	1.  编写第一个函数,函数接收姓名和年龄,如果年龄
		不在1到150之间,产生ValueError异常
	2.  编写第二个函数,函数接收姓名和年龄,如果年龄
		不在1到150之间,产生断言异常

#raise   assert 两种自定义异常的方法
#!/usr/bin/env python3
def set_age(name,age):
    if not 0 <age < 150:
        raise ValueError('age out of range')
    print(name,age)
def set_age2(name,age):
    assert 0<age<150, 'age out of range'  #断言 范围  异常输出
    print(name,age)
    pass
if __name__=='__main__':
	set_age('bob',233)
	set_age2('bob',233)

##############################################################################
os模块
● os模块方法

	函数           作用
	symlink()   #创建符号链接
	listdir()   #列出指定目录的文件
	getcwd()    #返回当前工作目录    #相当于pwd
	mkdir()     #创建目录
	chmod()     #改变权限模式
	getatime()  #返回最近访问时间
	chdir()     #改变工作目录
	remove()    #删除文件
● os模块方法 path
	os.path.isfile()
	os.path.isdir()
	os.path.exists()
	os.path.islink()
	os.path.split()
	os.path.join()
	
##############################################################################
pickle模块方法
•  分别调用dump()和load()可以存储、写入
   — 存储的是什么数据类型，拿出来就是什么类型

import pickle as p
with open('1.txt','wb') as f:
	p.dump({'name':'bob','age':25},f)

with open('1.txt','rb') as f1:
	p.load(f1)
































