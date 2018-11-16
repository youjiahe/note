Python2自动化运维 day04
1.re模块
	1.1 正则表达式
	1.2 核心函数和方法
##############################################################################	
● re模块  正则匹配
   — re.match('regexp',data)    #匹配到返回查询结果，没有匹配到返回 None
   — re.search('regexp',data)   #在data整个字符串中扫描，匹配到返回结果
   — re.findall('regexp',data)  #返回一个匹配对象的列表
   — re.finditer('regexp',data) #与findall()功能相同,返回迭代器非列表;
	— *.group()
	— compile函数
	
	>>> re.match('f..','food')   
	<_sre.SRE_Match object; span=(0, 3), match='foo'>
	>>> m=re.match('f..','food')
	>>> m.group()
	'foo'
	>>> re.match('f..','seafood')   #没有结果
	>>> re.search('f..','seafood')  #有结果
	<_sre.SRE_Match object; span=(3, 6), match='foo'>

	>>> m=re.search('(\d\d)*','2018世界杯')
	>>> m.group()
	'2018'
	
	>>> re.findall('f..','seafood is food') #列表形式返回
	['foo', 'foo']
	>>> for m in re.finditer('f..','seafood is food'):
	...     print(m.group())
	... 
	foo
	foo

