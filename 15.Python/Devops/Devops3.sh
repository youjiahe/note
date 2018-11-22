运维开发实战
NSD DEVOPS DAY03
1. HTTP
2. urllib
3. paramiko
##################################################################################
urllib 总结
— from urllib import request
— html=request.urlopen('https://www.jd.com')  #访问网页
— req=request.Request(url,headers=header)  #模拟客户端，添加request对象
— req=request.Request(url)             #python正常访问url

— from urllib import request
— import webbrowser
— quote=request.quote('你好')
— url='https://www.baidu.com/s?wd=' + quote
— webbrowser.open_new_tab(url)

— from urllib import request,error

##################################################################################
paramiko总结：
>>> import paramiko
>>> ssh=paramiko.SSHClient()
>>> ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())  #自动回答 yes
>>> ssh.connect('192.168.4.2',username='root',password='123456')
>>> ssh.exec_command('useradd jia')
>>> ssh.close()
##################################################################################
HTTP  重要方法：
  1. GET：在地址栏输入网址访问，采用GET；  点击页面上的一个链接采用get。
         填写表单提交，也可以采用GET；
   2. POST：一般来说是在表单提交隐私数据时使用

状态码：
   200
   301  永久重定向
   302  临时重定向
   400 错误响应
   404  Not Found
   403  Forbidden
   501  Internet Error
   502  Bad-Gayway
	
请求行 消息包头  请求正文
请求方法  uri  协议/版本

	[root@room9pc01 ~]# telnet www.baidu.com 80
	Trying 14.215.177.39...
	Connected to www.baidu.com.
	Escape character is '^]'.
	GET / HTTP/1.1
	[回车]
##################################################################################
urllib模块

1.爬取网页 #request模块  #参考代码mget_files.py
网络爬虫是一个自动提取网页的程序，它为搜索引擎从万维网上下载网页，是搜索引擎的重要组成。

##################################################################################
模拟客户端
•  有些网页为了防止别人恶意采集其信息所以进行了一
些反爬虫的设置,而我们又想进行爬取
•  可以设置一些Headers信息(User-Agent),模拟
成浏览器去访问这些网站
#!/usr/bin/env python3
from urllib import request
from time import sleep
url='http://139.159.193.210'
#伪造头部信息
header={'User-Agent':'Mozilla/5.0 (X11; WIN10 x86_64) \
AppleWebKit/537.36 (KHTML, like Gecko) Chrome/60.0.3112.113 Safari/537.36'}
req=request.Request(url,headers=header)
#req=request.Request(url)
html=request.urlopen(req)

##################################################################################
urllib进阶
数据编码

●ASCII 
	>>> ord('a')  #查看ascii码
	97
	>>> bin(97)
	'0b1100001'
	
	1100001 =>a
	1100010 =>b
	1100011 =>c
	
●ISO8859-1/Latin-1  #西欧字符集
●GB2312/GBK/GB10030  #国标
●BIG5  #繁体字
●ISO --->国际标准化组织  Unicode 编码
●utf8 --->是变长的，对于欧美文字，用8位表示，汉字用24位表示
##################################################################################
数据编码
●python3.6字符集有两种类型 str 和 bytes	
	>>> a = '人'            -------> str 类型
	>>> a.encode('gbk') #转成bytes类型. 使用gbk类型  两个字节
	b'\xc8\xcb'          
	>>> a.encode()      #转成bytes类型. 使用utf8类型 三个字节
	b'\xe4\xba\xba'

	>>> bb=a.encode('gbk')  
	>>> bb
	b'\xc8\xcb'
	>>> bb.decode()    #报错，gbk不能直接通过utf8 进行编码
	>>> bb.decode('gbk')  #将bytes类型解码位str
	'人'
##################################################################################
异常处理

#!/usr/bin/env python3
from urllib import request,error

url1='http://139.159.193.210/abc'  #不存在abc
url2='http://139.159.193.210/zz'  #权限700

try:
    request.urlopen(url1)
except error.HTTPError as e:
    print('错误:',e)

try:
    request.urlopen(url2)
except error.HTTPError as e:
    print('err:',e)

# 运行结果：
# 错误: HTTP Error 404: Not Found
# err: HTTP Error 403: Forbidden

##################################################################################
paramiko
— 相当于使用ssh 实现sftp

●安装paramiko
  [root@room9pc01 ~]# pip3 install paramiko  
●创建3台虚拟机
●使用paramiko的
	>>> import paramiko
	>>> ssh=paramiko.SSHClient()
	>>> ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())  #自动回答 yes
	>>> ssh.connect('192.168.4.2',username='root',password='123456')
	>>> ssh.exec_command('useradd jia')
	>>> ssh.close()

●执行命令返回值有三项，分别是输入，输出，错误；主要看输出，错误
	>>> s=ssh.exec_command('id jia;id lili')
	>>> len(s)
	3
	>>> s[1].read()
	b'uid=1001(jia) gid=1001(jia) \xe7\xbb\x84=1001(jia)\n' #输出
	>>> s[2].read() 
	b'id: lili: no such user\n'  #错误
##################################################################################
1.复习urllib
2.复习paramiko


































