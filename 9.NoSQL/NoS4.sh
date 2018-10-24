
1.部署MongoDB服务
  装包
  配置
  起服务
  查看服务信息
2.mongodb使用
  2.1库管理  
  2.2文档管理
3.数据类型
  字符串 数值 空 布尔值 数组 日期 代码 对象 内嵌 正则表达式
4.数据导出导入s
  4.1数据导出 mongoexport
  4.2数据导入 mongoimport
5.数据备份与恢复
  5.1数据备份 mongodump
  5.2数据恢复 mongorestore
##################################################################################
MongoDB介绍
●•介于关系数据库和非关系数据库之间的产品
  &也叫文档数据库
  &一款基于分布式文件存储的数据库,旨在为WEB应用提供可扩展的高性能数据存储解决方案
  &将数据存储为一个文档(类似于JSON对象),数据结构由键值(key=>value)对组成
  &支持丰富的查询表达,可以设置任何属性的索引
  &支持副本集,分片，集群
  &开源软件
  
●相关概念
 MongoDB                 RDBMS
  集合(collections)---------------表(tables)
  文档(document)--------------------行/记录(row)
  分片(shard)-------------------------分片(partition)

##################################################################################
部署MongoDB
●装包
 +解包
   tar -xvf mongodb-linux-x86_64-rhel70-3.6.3.tgz
 +部署mongodb脚本，各种程序
   mkdir /etc/mongodb
   cp mongodb-linux-x86_64-rhel70-3.6.3.tgz/bin /etc/mongodb/
   
●修改配置文件   
 +创建工作目录
  cd /etc/mongodb
   创建以下目录
  bin 
  etc
  etc/mongodb.conf
  log      
  data/db #数据库目录
  
  /etc/mongodb/bin/mongod  --help    #启动服务程序
  ls /etc/mongodb/bin  
  
 +修改配置文件
  vim /etc/mongodb/etc/mongodb.conf  #写配置文件，就不需要再启动的时候指定以下内容
  <--------------------------------------------------------------
  logpath=/etc/mongodb/log/mongodb.log #日志文件两路经
  logappend=true  #以追加的方式记录日志
  dbpath=/etc/mongodb/datab/db  #数据库目录
  fork=true       #以守护进程的方式运行
  -------------------------------------------------------------->

●起服务
  cd /etc/mongodb/bin
  ./mongod -f /etc/mongodb/etc/mongodb.conf

●查看服务信息
  netstat -unltp | grep :27017
  #默认只能从本地连接mongodb

●连接mongodb
  cd /etc/mongodb/bin
  ./mongo
  #显示版本号,状态,并且命令行变为>
  exit退出

●停服务
  ./mongod  -f /etc/mongodb/etc/mongodb.conf --shutdown
  
●命令太长，可以添加路径到PATH
  或者修改 /etc/bashrc
  ]# head -3 /etc/bashrc 
  # /etc/bashrc
  alias mgstart="/etc/mongodb/bin/mongod -f /etc/mongodb/etc/mongodb.conf"
  alias mgstop="/etc/mongodb/bin/mongod -f /etc/mongodb/etc/mongodb.conf --shutdown"
  
##################################################################################
修改配置文件
使用IP连接mongodb
●设置服务使用的IP，端口
 ]# vim /etc/mongodb/etc/mongodb.conf
  <--------------------------------------------------------------
  logpath=/etc/mongodb/log/mongodb.log 
  logappend=true  
  dbpath=/etc/mongodb/datab/db 
  fork=true       
  bind_ip=192.168.4.50    #添加
  port=27050              #添加
  -------------------------------------------------------------->
  
●查看服务状态(重启服务)
 ]# netstat -unltp | grep mongod
  tcp  0  0 192.168.4.50:27050  0.0.0.0:*    LISTEN     14947/mongod 
  
●50本地连接mongodb
  ]# bin/mongo --host 192.168.4.50 --port 27050
  MongoDB shell version v3.6.3
  connecting to: mongodb://192.168.4.50:27050/
  MongoDB server version: 3.6.3
  Welcome to the MongoDB shell.
  ..
  ..
  >

●远端主机连接mongodb服务
  mkdir /root/bin
  scp 192.168.4.50:/etc/mongodb/bin/mongo /root/bin
  mongo --host 192.168.4.50 --port 27050
##################################################################################
MongoDB基本使用
●集合管理
 +查看集合
    show collections   #查看当前库集合
    show tables        #查看当前库集合
 +创建集合
    db.集合名.save({字段1:值1,字段2:值2}) #创建集合
    db.t1.save({name:"bob",age:19})  #例子
    db.集合名.drop()  #删除集合
 
●数据库管理
 +查看库,切换库
    show dbs #查看已有的所有库
    db       #显示当前所在的库
    use 库名  #切换库，并且创建库
 +删除库
    db.dropDatabase() //删除当前所在的库
          
● 数据库名称规范
– 不能是空字符串("")
– 不得含有' '(空格)、. 、$、/、\和\0 (空字符)
– 应全部小写
– 最多64字节

●文档管理
– db.集合名.find()
– db.集合名.count()
– db.集合名.insert({“name”:”jim”})  #与save一样
– db.集合名.find({条件})
– db.集合名.findOne()      #返回一条文档
– db.集合名.remove({})     #删除所有文档
– db.集合名.remove({条件})  #删除匹配的所有文档  
##################################################################################
●库例子
> db.t1.save({name:"you",class:"NSD1806"})
> show tables
t1
> show dbs
admin   0.000GB
config  0.000GB
local   0.000GB
test    0.000GB
> db
test  #不指定时默认
> db.dropDatabase() #删库
{ "dropped" : "test", "ok" : 1 } 

●文档基本管理例子
> use game
switched to db game
> db
game
> db.t1.save({name:"lucy",mail:"lucy@163.com",school:"dawai"})
WriteResult({ "nInserted" : 1 })
> db.t1.save({name:"gogo",mail:"gogo@163.com",school:"danei"})
WriteResult({ "nInserted" : 1 })
> db.t1.save({name:"gogo",mail:"gogo@163.com",addr:"guangzhou"})
WriteResult({ "nInserted" : 1 })
> db.t1.save({name:"ggg",mail:"ggg@qq.com",addr:"guangzhou"})
WriteResult({ "nInserted" : 1 })
> db.t1.findOne()
{
	"_id" : ObjectId("5baf1620ed42f5025392990e"),
	"name" : "lucy",
	"mail" : "lucy@163.com",
	"school" : "dawai"
}
> db.t1.find()
{ "_id" : ObjectId("5baf1620ed42f5025392990e"), "name" : "lucy", "mail" : "lucy@163.com", "school" : "dawai" }
{ "_id" : ObjectId("5baf162eed42f5025392990f"), "name" : "gogo", "mail" : "gogo@163.com", "school" : "danei" }
{ "_id" : ObjectId("5baf1638ed42f50253929910"), "name" : "gogo", "mail" : "gogo@163.com", "addr" : "guangzhou" }
{ "_id" : ObjectId("5baf1643ed42f50253929911"), "name" : "ggg", "mail" : "ggg@qq.com", "addr" : "guangzhou" }
> db.t1.find({name:"lucy"})

#################################################################################
MongoDB数据类型
字符类型 空  布尔值 数值类型 数组 代码 正则表达式 日期 对象 内嵌
##################################################################################
MongoDB数据类型
●字符串string
– UTF-8字符串都可以表示为字符串类型的数据
– {name:"张三"} 或 { school:"tarena"}
●布尔bool
– 布尔类型有两个值true和false,{x:true}
●空null
– 用于表示空值或者不存在的字段,{x:null}

●字符类型例子
> db.user.insert({姓名:"尤家和",性别:"男",学校:"广州大学"})
WriteResult({ "nInserted" : 1 })
> db.user.find()
{ "_id" : ObjectId("5baf184ced42f50253929912"), "姓名" : "尤家和", "性别" : "man" }
{ "_id" : ObjectId("5baf1882ed42f50253929913"), "姓名" : "尤家和", "性别" : "男", "学校" : "广州大学" 
> db.user.findOne({学校:"广州大学"})
{
	"_id" : ObjectId("5baf1882ed42f50253929913"),
	"姓名" : "尤家和",
	"性别" : "男",
	"学校" : "广州大学"
}

##################################################################################
MongoDB数据类型
●数值
  &shell默认使用64位浮点型数值。{x:3.14}或{x:3}。
  &NumberInt(4字节整数){x:NumberInt(3)}
  &NumberLong(8字节整数){x:NumberLong(3)}

> db.stuinfo.save({name:"james",wage:200002140.8921542131232})
WriteResult({ "nInserted" : 1 })
> db.yzl.save({c1:NumberLong(88888888888)})
WriteResult({ "nInserted" : 1 })
> db.yzl.save({c1:NumberInt(66)})
WriteResult({ "nInserted" : 1 })
#################################################################################
MongoDB数据类型
●数组
  &数据列表或数据集可以表示为数组
  – {x: ["a","b", "c"]}
  
> db.yz.save({name:"wade",like:["basketball","make love","girl"]})
WriteResult({ "nInserted" : 1 })
##################################################################################
MongoDB数据类型
●代码
  &查询和文档中可以包括任何JavaScript代码
  – {x: function(){/* 代码 */}}  
●代码例子
> db.hello.save({lang:"php",function(){/* <?php echo \"hello world\"; ?> */}})

##################################################################################
MongoDB数据类型
●日期
  &日期被存储为自新纪元以来经过的毫秒数,不含时区
  – {x:new Date( )}
●日期例子  
> db.t1.save({name:"tony",birthday:new Date()})
WriteResult({ "nInserted" : 1 })
> db.t1.find()
{ "_id" : ObjectId("5baf1e8aed42f5025392991f"), "name" : "tony", "birthday" : ISODate("2018-09-29T06:41:14.139Z") }  
##################################################################################
MongoDB数据类型
●对象 
  &对象id是一个12字节的字符串,是文档的唯一标识 #类似于主键+auto_increment
  – {x: ObjectId() }
●对象例子
> db.teacher.save({teach_num:ObjectId(),name:"niuben"})
WriteResult({ "nInserted" : 1 })
> db.teacher.find()
{ "_id" : ObjectId("5baf2131ed42f50253929921"), "teach_num" : ObjectId("5baf2131ed42f50253929920"), "name" : "niuben" }
##################################################################################
MongoDB数据类型
●正则表达式
  &查询时,使用正则表达式作为限定条件
  – {x:/正则表达式/}
  
> db.t2.save({zhengze:/^a.*$/})
WriteResult({ "nInserted" : 1 })
##################################################################################
MongoDB数据类型
●内嵌  #类似与redis的hash表
  &文档可以嵌套其他文档,被嵌套的文档作为值来处理

> db.t2.save(
... {book:{作者:"丁大神",书名:"运维之道",出版社:"电子工业出版社"}}
... )
WriteResult({ "nInserted" : 1 })
> db.t2.find()
{ "_id" : ObjectId("5baf23a1ed42f50253929922"), "book" : { "作者" : "丁大神", "书名" : "运维之道", "出版社" : "电子工业出版社" } }
> db.t2.findOne()
{
	"_id" : ObjectId("5baf23a1ed42f50253929922"),
	"book" : {
		"作者" : "丁大神",
		"书名" : "运维之道",
		"出版社" : "电子工业出版社"
	}
}
##################################################################################
数据导出
●CSV格式 #必须指定字段名
• 语法格式1-------------
]# mongoexport [--host IP地址 --port 端口 ] \
-d 库名 -c 集合名 -f 字段名1,字段名2 \
--type=csv > 目录名/文件名.csv
• 语法格式2
]# mongoexport --host IP地址 --port 端口 \
-库名 -c 集合名 -q '{条件}' -f 字段名1,字段名2 \
--type=csv > 目录名/文件名.csv

●csv例子：
 bin]# ./mongoexport --host 192.168.4.50 --port 27050 -d gamedb -c user -f 姓名,性别,班级 --type=csv > /opt/user.csv
2018-09-29T15:46:17.443+0800	connected to: 192.168.4.50:27050
2018-09-29T15:46:17.445+0800	exported 3 records
 bin]# cat /opt/user.csv
姓名,性别,班级
尤家和,男,
量与天,true,
邱秋波,,NSD1806

##################################################################################
数据导出
●json格式
• 语法格式3--------------------json格式的
]# mongoexport [ --host IP地址 --port 端口 ] \
-d 库名 -c 集合名 [ -q ‘{ 条件 }’ –f 字段1,字段2 ] \
--type=json > 目录名/文件名.json

●json例子：
 bin]# ./mongoexport --host 192.168.4.50 --port 27050 -d gamedb -c user --type=json > /opt/user.json
 
 bin]# ./mongoexport --host 192.168.4.50 --port 27050 -d gamedb -c  user \
 -q '{"姓名":"尤家和"}' --type=json > /user2.json  #有条件导出
##################################################################################
数据导入
●导入json文件
语法格式1
]# mongoimport --host IP地址 --port 端口 \
-d 库名 –c 集合名 \      #库可以不存在
--type=json 目录名/文件名.json
##################################################################################
●导入csv文件
语法格式2
]# mongoimport --host IP地址 --port 端口 \
-d 库名 -c 集合名 \
--type=csv [--headerline] [--drop] 目录名/文件名.csv
●说明
1. 导入数据时,若库和集合不存在,则先创建库和集合后再导入数据;
2. 若库和集合已存在,则以追加的方式导入数据到集合里;
3. 使用--drop选项可以删除原数据后导入新数据,--headerline 忽略标题
4.-f 与 --headerline 不能够同时用

##################################################################################
●csv导入例子
&导出文件
~]# mongoexport --host 192.168.4.50 --port 27050 \
   -d gamedb -c user -f 姓名 --type=csv > user_2.csv
&查看文件
~]# cat user.csv
姓名
尤家和
量与天
邱秋波

杨日波
吴正庚
-----------------------------------------------------------------------------------------------
&导入文件，并把字段名改称“name”
~]# mongoimport --host 192.168.4.50 --port 27050 -d gamedb -c user -f name \
   --type=csv user.csv

&查看值    #看到追加导入
> db.user.find()
{ "_id" : ObjectId("5baf1882ed42f50253929913"), "姓名" : "尤家和", "性别" : "男", "学校" : "广州大学" }
{ "_id" : ObjectId("5baf1920ed42f50253929915"), "姓名" : "量与天", "性别" : true, "学校" : null }
{ "_id" : ObjectId("5baf2bd2ed42f50253929924"), "姓名" : "邱秋波", "班级" : "NSD1806" }
{ "_id" : ObjectId("5baf34e7c49c46709826a5a5"), "x" : [ "basket", "make love" ] }
{ "_id" : ObjectId("5baf350fc49c46709826a5a6"), "姓名" : "杨日波", "性别" : "男" }
{ "_id" : ObjectId("5baf3516c49c46709826a5a7"), "姓名" : "吴正庚", "性别" : "男" }
{ "_id" : ObjectId("5baf3564c49c46709826a5a8"), "book" : { "姓名" : "丁明一", "出版社" : "电子工业出版社", "价格" : 80 } }
{ "_id" : ObjectId("5baf35c965222a18a51dd1ab"), "name" : "姓名" }
{ "_id" : ObjectId("5baf35c965222a18a51dd1ac"), "name" : "尤家和" }
{ "_id" : ObjectId("5baf35c965222a18a51dd1ad"), "name" : "量与天" }
{ "_id" : ObjectId("5baf35c965222a18a51dd1ae"), "name" : "邱秋波" }
{ "_id" : ObjectId("5baf35c965222a18a51dd1af"), "name" : "杨日波" }
{ "_id" : ObjectId("5baf35c965222a18a51dd1b0"), "name" : "吴正庚" }
-----------------------------------------------------------------------------------------------
&忽略标题导入
~]# mongoimport --host 192.168.4.50 --port 27050 -d gamedb -c user  \
   --headerline   --type=csv  user.csv

&查看值    #看到追加导入，并且标题没有导入
> db.user.find()
{ "_id" : ObjectId("5baf1882ed42f50253929913"), "姓名" : "尤家和", "性别" : "男", "学校" : "广州大学" }
{ "_id" : ObjectId("5baf1920ed42f50253929915"), "姓名" : "量与天", "性别" : true, "学校" : null }
{ "_id" : ObjectId("5baf2bd2ed42f50253929924"), "姓名" : "邱秋波", "班级" : "NSD1806" }
{ "_id" : ObjectId("5baf34e7c49c46709826a5a5"), "x" : [ "basket", "make love" ] }
{ "_id" : ObjectId("5baf350fc49c46709826a5a6"), "姓名" : "杨日波", "性别" : "男" }
{ "_id" : ObjectId("5baf3516c49c46709826a5a7"), "姓名" : "吴正庚", "性别" : "男" }
{ "_id" : ObjectId("5baf3564c49c46709826a5a8"), "book" : { "姓名" : "丁明一", "出版社" : "电子工业出版社", "价格" : 80 } }
{ "_id" : ObjectId("5baf35c965222a18a51dd1ab"), "name" : "姓名" }
{ "_id" : ObjectId("5baf35c965222a18a51dd1ac"), "name" : "尤家和" }
{ "_id" : ObjectId("5baf35c965222a18a51dd1ad"), "name" : "量与天" }
{ "_id" : ObjectId("5baf35c965222a18a51dd1ae"), "name" : "邱秋波" }
{ "_id" : ObjectId("5baf35c965222a18a51dd1af"), "name" : "杨日波" }
{ "_id" : ObjectId("5baf35c965222a18a51dd1b0"), "name" : "吴正庚" }
{ "_id" : ObjectId("5baf3b3265222a18a51dd1bf"), "姓名" : "尤家和" }
{ "_id" : ObjectId("5baf3b3265222a18a51dd1c0"), "姓名" : "量与天" }
{ "_id" : ObjectId("5baf3b3265222a18a51dd1c1"), "姓名" : "邱秋波" }
{ "_id" : ObjectId("5baf3b3265222a18a51dd1c2"), "姓名" : "杨日波" }
{ "_id" : ObjectId("5baf3b3265222a18a51dd1c3"), "姓名" : "吴正庚" }
-----------------------------------------------------------------------------------------------
&忽略标题导入,并且把表原来的内容删除，追加导入
~]# mongoimport --host 192.168.4.50 --port 27050 -d gamedb -c user \
    --headerline --drop  --type=csv  user.csv
&查看值 #看到只剩下导入的数据
> db.user.find()
{ "_id" : ObjectId("5baf3bd365222a18a51dd1cf"), "姓名" : "尤家和" }
{ "_id" : ObjectId("5baf3bd365222a18a51dd1d0"), "姓名" : "量与天" }
{ "_id" : ObjectId("5baf3bd365222a18a51dd1d1"), "姓名" : "邱秋波" }
{ "_id" : ObjectId("5baf3bd365222a18a51dd1d2"), "姓名" : "杨日波" }
{ "_id" : ObjectId("5baf3bd365222a18a51dd1d3"), "姓名" : "吴正庚" }

##################################################################################
常见错误
-f 与 --headerline 不能够同时用

~]# mongoimport --host 192.168.4.50 --port 27050 -d gamedb -c user -f name   --type=csv --fields 姓名 --headerline user.csv
2018-09-29T16:25:09.668+0800	error validating settings: incompatible options: --fields and --headerline  
##################################################################################
案例：
把/etc/passwd 文件导入mongodb

  ~]# cp /etc/passwd /root/passwd.csv
  ~]# sed -i '1i user,pass,uid,gid,comment,homedir,shell' /root/passwd.csv
  ~]# sed -in 's/:/,/g' /root/passwd.csv
  ~]# mongoimport  --host 192.168.4.50 --port 27050 \
     -d bbs -c usertab --headerline --type=csv /root/passwd.csv
  ~]# wc -l /root/passwd.csv
    46 /root/passwd.csv
  > db.usertab.count()
     45
##################################################################################
数据备份
●备份数据所有库到当前目录下的dump目录下
]# mongodump [ --host ip地址 --port 端口 ] 
//备份admin 以及其他自定义库

●备份时指定备份的库和备份目录
]# mongodump [ --host ip地址 --port 端口 ] -d 数据库名 -c 集合名 -o 目录

●备份所有库
~]# mongodump --host 192.168.4.50 --port 27050 -o /mbak/
~]# ls /mbak/
admin  bbs  gamedb  test  userdb
~]# bsondump /mbak/bbs/usertab.bson

●备份单独一个库
~]# mongodump --host 192.168.4.50 --port 27050 -d bbs -c usertab -o /mbak/
~]# cd /mbak/bbs
bbs]# ls
usertab.bson  usertab.metadata.json
##################################################################################
数据恢复
●语法格式
]# mongorestore --host IP地址 --port 端口 -d 数据库名 [ -c 集合名 ]  备份目录名

●例子
]# mongodump --host 192.168.4.51 --port 27051 -d linux_user -c usertab -o /opt/
2018-09-29T21:05:26.150+0800	writing linux_user.usertab to 
2018-09-29T21:05:26.153+0800	done dumping linux_user.usertab (43 documents)

]# mongorestore --host 192.168.4.51 --port 27051 -d host -c user /opt/
admin/      game/       linux_user/ rh/         

]# mongorestore --host 192.168.4.51 --port 27051 -d host -c user /opt/linux_user/usertab.bson 
2018-09-29T21:06:31.750+0800	checking for collection data in /opt/linux_user/usertab.bson
2018-09-29T21:06:31.751+0800	reading metadata for host.user from /opt/linux_user/usertab.metadata.json
2018-09-29T21:06:31.879+0800	restoring host.user from /opt/linux_user/usertab.bson
2018-09-29T21:06:31.942+0800	no indexes to restore
2018-09-29T21:06:31.942+0800	finished restoring host.user (43 documents)
2018-09-29T21:06:31.942+0800	done
























