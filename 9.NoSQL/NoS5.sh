NoSQL数据库管理
NSD NoSQL DAY05

1.MongoDB副本集
  1.1创建副本集
  1.2测试副本集
2.MogoDB文档管理
  2.1插入文档  save(),insert()
  2.2查询文档 
##################################################################################
●副本集介绍     #Mongodb的高可用集群
  &也称为MongoDB复制
  &指在多个服务器上存储数据副本,并实现数据同步
  &提高数据可用性、安全性,方便数据故障恢复
●副本及工作过程
  &至少需要两个节点，其中一个是主节点，负责处理客户端请求；其余时从节点，负责复制主节点数据
  &常见结构：一主一从  一主多从
  &主节点记录所有操作oplog,从节点定期轮询主节点获
  取这些操作,然后对自己的数据副本执行这些操作,实现数据同步
●副本及实现方式
  +Master-Slave 主从复制
    &不支持故障自动切换
  +Replica Sets副本集
    &从1.6 版本开始支持,优于之前的replication
    &支持故障自动切换、自动修复成员节点,降低运维成本
   &Replica Sets副本集的结构类似高可用集群   ##################################################################################
配置Replica Sets
主192.168.4.51 
从192.168.4.52，192.168.4.53

●运行MongoDB服务   

●启用副本集，模式为Replica Sets,集群名称叫rs1
   vim /etc/mongodb/etc/mongodb.conf        
   replSet=rs1  //所有mongodb服务指定副本集名称     

●创建副本集 
  +定义集群成员列表   #在192.168.4.51上配置  
   ~]# mongo --host 192.168.4.51 --port 27051
    config = {    #配置错了，变量名"config"可以改
    _id:"rs1",
    members:[
    {_id:0,host:"192.168.4.51:27051"}, 
    {_id:1,host:"192.168.4.52:27052"},
    {_id:2,host:"192.168.4.53:27053"}
     ]
     }
  +创建集群
    rs.initiate(config)
     {
	"ok" : 1,
	"operationTime" : Timestamp(1538272141, 1),
        .. ..
     }
  +主从命令行
   rs1:SECONDARY>   #从库mongo命令行
                         #从库默认不允许执行数据管理操作
   rs1:PRIMARY>     #主库mongo命令行 
  +查看集群状态  
   rs.status()
   rs1:PRIMARY> rs.isMaster()
    {
	"hosts" : [
		"192.168.4.51:27051",
		"192.168.4.52:27052",
		"192.168.4.53:27053"
	],
	"setName" : "rs1",
	"setVersion" : 1,
	"ismaster" : true,
	"secondary" : false,
	"primary" : "192.168.4.51:27051",
	"me" : "192.168.4.51:27051",
         .. ..
         .. ..
         }
##################################################################################  
mongodb副本集信息
●查看初始化后的库
  rs1:PRIMARY> show dbs
  admin   0.000GB
  config  0.000GB
  local   0.000GB          #创建副本集后，存放本机的配置文件的库
●切换到local
  rs1:PRIMARY> use local
●查看local所有表
  rs1:PRIMARY> show tables
  me 
  oplog.rs              #所有操作的记录
  replset.election
  replset.minvalid
  startup_log           
  system.replset
  system.rollback.id
●主库50 查看本机配置信息  
  rs1:PRIMARY> db.me.find()
   { "_id" : ObjectId("5bb026a6e4215d7127d20742"), "host" : "redis51" }
   
##################################################################################  
测试mongo副本集(集群)
●测试数据同步
+主库50创建库以及表
  rs1:PRIMARY> use game
  rs1:PRIMARY> db.t1.save({id:0,name:"jiba"})
  rs1:PRIMARY> db.t1.save({id:1,name:"jj"})
+两台从库获取查看数据权限,并查看数据
  rs1:SECONDARY> db.getMongo().setSlaveOk()
  rs1:SECONDARY> use game
  rs1:SECONDARY> db.t1.find()      #查看到数据是与主库一样的
##################################################################################  
测试mongo副本集(集群)
●测试集群高可用
+停止当前主库  51
 [root@redis51 ~]#  mgstop   #定义了别名
+到原从库52查看状态  52 
 rs1:SECONDARY> rs.status()
 syncingTo" : "192.168.4.53:27053",    #52同步新主库53的数据
 .. ..
 "members" : [
		{
			"_id" : 0,
			"name" : "192.168.4.51:27051",
			"health" : 0,      #源主库51状态宕机
			 .. ..
 "} 
  	"ismaster" : true,
	"secondary" : false,
	"primary" : "192.168.4.53:27053",  
+查看新主库53的状态  53
  rs1:PRIMARY> rs.isMaster()  
  .. ..   
  "ismaster" : true
  "secondary" : false,
  "primary" : "192.168.4.53:27053",
  "me" : "192.168.4.53:27053",
  .. ..
##################################################################################  
测试mongo副本集(集群)
●恢复宕机51
 [root@redis51 ~]# mgstart
 [root@redis51 ~]# mongo --host 192.168.4.51 --port 27051
 rs1:SECONDARY> rs.status()      
  {
    .. ..
   "syncingTo" : "192.168.4.53:27053",   #自动成为新主库53的从库
##################################################################################  
MogoDB文档管理
●插入文档  
 +save()
   &格式  
    > db.集合名.save({ key:“值”,key:”值”})
   &集合不存在时创建集合,然后在插入记录
  &_id字段值已存在时,修改文档字段值
  &_id字段值不存在时,插入文档
  
 +insert()
   &格式
    > db.集合名.insert({key:"值",key:"值"})
   &集合不存在时创建集合,然后再插入记录
  &_id字段值已存在时,放弃插入
  &_id字段值不存在时,插入文档
 
 +insertMany()    #插入多条文档
  > db.集合名.insertMany(
  [
  {name:"xiaojiu",age:19} ,
  {name:"laoshi",email:"yaya@tedu.cn"}
  ]
  )  
  > db.t1.insertMany([{_id:123,name:"nnnbbb"},{_id:124,name:"nnbb",company:"dawai"}])
   
###################################################################################
MogoDB文档管理
●查询文档
  +find()
    &格式   
     > db.集合名.find()                     #显示集合所有
     > db.集合名.find({条件},{定义显示的字段}) #0不显示，1显示
    &显示所有行(默认输出20行,输入it可显示后续行)
    &例子  
    > db.usertab.find({user:"root"})  #根据条件查找
    > db.usertab.find({user:"root"},{_id:0,uid:1})  #0不显示，1显示
    { "uid" : 0 }                     #不显示字段"_id"，显示字段"uid"
    
  +findOne()
    &格式 
    > db.集合名.findOne()
    &例子    
    > db.usertab.findOne({user:"nobody"},{_id:0})  #查找nobody信息,且不显示字段"_id"
      {
	"user" : "nobody",
	"pass" : "x",
	"uid" : 99,
	"gid" : 99,
	"comment" : "Nobody",
	"homedir" : "/",
	"shell" : "/sbin/nologin"
     }
###################################################################################
●查询文档-------行操作
  +limit(行数)    #显示前几行  
    > db.usertab.find().limit(6)  #显示前6行
    
  +count()       #统计行数
    > db.usertab.find({shell:"/sbin/nologin"}).count()
       37
  +skip(行号)    #跳过前几行
  
  +sort({字段名:1|-1}) #1，升序；-1，降序
###################################################################################                              
匹配条件
●简单条件
  > db.集合名.find({key:"值"})
  > db.集合名.find({key:"值",keyname:"值"})

●范围匹配
  – $in 在...里      $in:[{}]
  – $nin 不在...里   $nin:[{}]
  – $or 或  
  &逻辑或
   > db.user.find({$or: [{name:"root"},{uid:1} ]})   
  &查找到uid是0，4，19，25其中一个的
   > db.usertab.find({uid:{$in:[0,4,19,25]}})  
  &查找到shell不是/sbin/nologin的
   > db.usertab.find({shell:{$nin:["/sbin/nologin"]}})   
  &多个条件，或者匹配
   > db.usertab.find({$or:[{user:"maxsacel"},{uid:{$in:[0,991]}}]})
  
●正则匹配
   > db.user.find({name: /^a/ },{_id:0,user:1})
  &查找用户名有且只有3个字符的  #要用扩展正则
   > db.usertab.find({user:/^.{3}$/},{_id:0,user:1})
   > db.usertab.find({user:/^.{3,8}$/},{_id:0,user:1})
  
●数值比较
  $lt $lte $gt $gte $ne  
  &逻辑与
  > db.usertab.find({user:"root",uid:9})  
 &uid大于等于1000
  > db.usertab.find({uid:{$gte:1000}},{_id:0,user:1,uid:1})
  
●匹配null
  &匹配列没有值，或者没有该列
  > db.user.save({name:null,uid:null})
  > db.user.find({name:null})
###################################################################################  
表的内容修改 update()
●update()
 &语法格式
  > db.集合名.update({条件},{修改的字段})       
  > db.user.update({条件},{$set:{修改的字段}}) //默认只更新与条件匹配的第1行
  > db.user.update({条件},{$set:{修改的字段}} ,false,true)
                                                        #与条件匹配所有记录的列的值都修改  
 &默认只修改与条件匹配第一条记录的值，并删除其他字段   
  > db.usertab.find({uid:{$lte:4}},{_id:0})
  > db.usertab.update({uid:{$lte:4}},{pass:"AAA"})
  WriteResult({ "nMatched" : 1, "nUpserted" : 0, "nModified" : 1 })
  > db.usertab.find({pass:"AAA"},{_id:0})
  { "pass" : "AAA" }   #可以看到其他字段没有了
###################################################################################  
表的内容修改 update()
●$set/$unset  
 &加上$set就可以实现修改全部 
  > db.usertab.update({uid:{$lte:4}},{$set:{pass:"AAAAA"}},false,true)
    { "user" : "bin", "pass" : "AAAAA", "uid" : 1 }
    { "user" : "daemon", "pass" : "AAAAA", "uid" : 2 }
    { "user" : "adm", "pass" : "AAAAA", "uid" : 3 }
    { "user" : "lp", "pass" : "AAAAA", "uid" : 4 }
    
 &加上$unset就删除与条件匹配文档的字段
 > db.usertab.update({pass:/A/},{$unset:{pass:"AAAA"}},false,true)
 WriteResult({ "nMatched" : 4, "nUpserted" : 0, "nModified" : 4 }) 
###################################################################################
表的内容修改 update()
●$inc
 > db.usertab.find({uid:{$gte:1000}},{_id:0,user:1,uid:1})
   { "user" : "nfsnobody", "uid" : 65534 }
   { "user" : "lisi", "uid" : 1000 }
   { "user" : "zabbix", "uid" : 1001 }
   { "user" : "lucy", "uid" : 1002 }
 > db.usertab.update({uid:{$gte:1000}},{$inc:{uid:3}},false,true)
   WriteResult({ "nMatched" : 4, "nUpserted" : 0, "nModified" : 4 })
 > db.usertab.find({uid:{$gte:1000}},{_id:0,user:1,uid:1})  #字段值自加3
   { "user" : "nfsnobody", "uid" : 65537 }
   { "user" : "lisi", "uid" : 1003 }
   { "user" : "zabbix", "uid" : 1004 }
   { "user" : "lucy", "uid" : 1005 }
 > db.user.update({name:“bin”},{$inc:{uid:-1}})  #字段值自减1
###################################################################################
表的内容修改 update()
数组操作
●$push/$addToSet

 & $push 向数组中添加新元素
   > db.usertab.save({user:"uuu",like:["a","b"]})
   > db.usertab.update({user:"uuu"},{$push:{like:"c"}})
   > db.usertab.find({user:"uuu"},{_id:0})
   { "user" : "uuu", "like" : [ "a", "b", "c" ] }
   
 & $addToSet 避免重复添加
   > db.usertab.update({user:"uuu"},{$addToSet:{like:"c"}})
   WriteResult({ "nMatched" : 1, "nUpserted" : 0, "nModified" : 0 })
    #修改了0行，避免了重复添加
   
●$pop/$pull
 & $pop 从数组头部删除一个元素
   > db.usertab.update({user:"uuu"},{$pop:{like:-1}})  #删除尾部数据
   > db.usertab.find({user:"uuu"},{_id:0})
     { "user" : "uuu", "like" : [ "b","c" ] }
   > db.usertab.update({user:"uuu"},{$pop:{like:1}})
   > db.usertab.find({user:"uuu"},{_id:0})
     { "user" : "uuu", "like" : [ "b" ] }

 & $pull 删除数组指定元素
   > db.usertab.update({user:"uuu"},{$pull:{like:"b"}})
###################################################################################
表的内容修改 update()
●$drop/$remove
 & $drop 删除集合的同时删除索引
 & $remove() 删除文档时不删除索引
  > db.集合名.remove({})        #删除所有文档
  > db.集合名.remove({条件})     #删除与条件匹配的文档
  > db.user.remove({uid:{$lte:10}})
  > db.user.remove({})

























