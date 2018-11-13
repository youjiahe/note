Python2自动化运维 day01
1.元组
2.字典
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
字典相关函数
dict.update({'key':'value'})
dict.get('name')
dict.keys()
dict.values()
dict.item()

























