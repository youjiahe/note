运维开发实战
NSD DEVOPS DAY04
1.邮件与Json
2.request
3.zabbix编程
##################################################################################
●SMTP概述
python 有smtplib实现发送邮件
●SMTP对象
●设置邮件
●sendmail方法
##################################################################################
●发邮件
from email.mime.text import MIMEText
from email.header import Header
import smtplib
message = MIMEText('我的玛雅，好男！','plain','utf8')
message['From']=Header("youjiahe@163.com","utf8")  #发件人
message['To']=Header("674679819@qq.com",'utf8')    #收件人
subject='测试pytohn smtplib'
message['Subject']=Header(subject,"utf8")
sendor="youjiahe@163.com"
receivers=["674679819@qq.com","root@localhost"]
smtp=smtplib.SMTP('localhost')  #定义邮件服务器为本地，创建SMTP对象
smtp.sendmail(sendor,receivers,message.as_string())

smtp.connect(server,port=25)
smtp.login(username,password)
##################################################################################
●天气预报  Json应用
城市代码
广州:101280101

#!/usr/bin/env python3
from urllib import request
import json

citycode='101280101'  #广州城市代码
url_sk='http://www.weather.com.cn/data/sk/%s.html' % citycode
url_zs='http://www.weather.com.cn/data/zs/%s.html' % citycode
url_info='http://www.weather.com.cn/data/cityinfo/%s.html' % citycode

html=request.urlopen(url_sk)
result=html.read()
w = json.loads(result)
for keys in w['weatherinfo']:
    print('%s : %s' % (keys,w['weatherinfo'].get(keys)) )
##################################################################################
request模块应用
>>> m=requests.get('https://www.baidu.com/s?wd=*，jpg')
>>> with open('1.img','wb') as fobj:
...     fobj.write(m.content)          #m的内容
[root@room9pc01 nsd2018]# eog 1.img

>>> m=requests.get('http://139.159.193.210')
>>> q=m.text
>>> m
>>> q              #显示页面内容

>>> r = requests.get('http://www.weather.com.cn/data/sk/101280101.html')
>>> r.json()     #将返回的json格式数据转成python数据类型，有乱码
>>> r.encoding   #当前编码类型
'ISO-8859-1'  
>>> r.encoding="utf8"  #更改编码类型
>>> r.encoding    
'utf8' 
>>> r.json()     #再次转换，没有乱码了

##################################################################################
自定义钉钉机器人

百度搜索 ----> 钉钉开放平台 机器人  #有相关教程
https://www.jianshu.com/p/a3c62eb71ae3  #python100例，钉钉机器人脚本
##################################################################################
zabbix编程
百度搜索---->  zabbix中文手册
● 部署zabbix
● zabbix api概述
  api： 应用程序编程接口
  zabbix api:允许通过编程使用zabbix
  
● API结构
  大多数API至少包含四种方法：get，create，update，delete

##################################################################################
通过查看zabbix手册  查看zabbix版本信息，添加主机，删除主机

##################################################################################
配置zabbix通过钉钉机器人报警
张老师python百例：
121-配置zabbix通过钉钉机器人报警
##################################################################################


















