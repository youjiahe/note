
李欣老师的项目搭建文档 
http://118.144.89.240/mysql.txt

项目架构：
               +-------------+      +-----------+       +--------------------------+
               | keepalived  |      |  +-----+  |       | +--------+    +--------+ |   
               |-------------|      |  |mycat|  |  ==>  | |mysql(M)|<==>|mysql(M)| |      
               |  +-------+  |      |  +-----+  |       | +--------+    +--------+ |   
               |  |haproxy|=>| ==>  |           |       |  MHA或其他多主高可用方案 |
               |  +-------+  |      |  +-----+  |       |-~-~-~-~-~-~~~~-~-~-~-~-~-|      
client --> vip |    |高|     |      |  |mycat|  |  ==>  | +--------+    +--------+ |
               |    |可|     |      |  +-----+  |       | |mysql(S)| 从 |mysql(S)| |
               |    |用|     |      |           |       | +--------+ 库 +--------+ | 
               |  +-------+  |      |  +-----+  |       | +--------+ 集 +--------+ |    
               |  |haproxy|=>| ==>  |  |mycat|  |  ==>  | |mysql(S)| 群 |mysql(S)| |  
               |  +-------+  |      |  +-----+  |       | +--------+    +--------+ |  
               +-------------+      +-----------+       +--------------------------+
##################################################################################
mycat 读写分离
●部署mycat
&装包
  yum -y install java-1.8.0-openjdk java-1.8.0-openjdk-headless
&mycat服务软件解包
  ~]# tar -xf Mycat-server-1.4-beta-20150604171601-linux.tar.gz
  ~]# mv mycat/ /usr/local/
  ~]# ls /usr/local/
  bin  catlet  conf  lib  logs  version.txt

  目录结构说明
  – bin         #mycat命令,如 启动 停止 等
  – catlet      #扩展功能
  – conf        #配置文件
  – lib         #mycat使用的jar
  – log         #mycat启动日志和运行日志
  – wrapper.log #mycat服务启动日志
  – mycat.log   #记录SQL脚本执行后的报错内容
&重要配置文件
   &server.xml    #设置连接mycat的账号信息
   &schema.xml    #配置mycat的真实库表
   &rule.xml      #mycat的分片规则

&配置schema.xml
---------------------------schema.xml--------------------------------
[root@ecs-maxscale1 ~]# cat /usr/local/mycat/conf/schema.xml
<?xml version="1.0"?>
<!DOCTYPE mycat:schema SYSTEM "schema.dtd">
<mycat:schema xmlns:mycat="http://io.mycat/">

        <schema name="v_mysql" checkSQLschema="false" sqlMaxLimit="100" dataNode="dn1">
        </schema>
        <dataNode name="dn1" dataHost="cluster1" database="mysql" />
        <dataHost name="cluster1" maxCon="1000" minCon="10" balance="3"
                          writeType="0" dbType="mysql" dbDriver="native" switchType="1"  slaveThreshold="100">
                <heartbeat>select user()</heartbeat>
                <!-- can have multi write hosts -->
                <writeHost host="msha" url="192.168.1.50:3306" user="read" password="123456">
                        <!-- can have multi read hosts -->
                <readHost host="mysql1" url="192.168.1.31:3306" user="read" password="123456" />
                <!--<readHost host="mysql2" url="192.168.1.32:3306" user="read" password="123456" />-->
                <readHost host="mysql3" url="192.168.1.33:3306" user="read" password="123456" />
                <readHost host="mysql4" url="192.168.1.34:3306" user="read" password="123456" />
                <readHost host="mysql5" url="192.168.1.35:3306" user="read" password="123456" />
              </writeHost>
        </dataHost>
</mycat:schema>
--------------------------end----------------------------------------

&配置server.xml
---------------------------server.xml--------------------------------
[root@ecs-maxscale1 ~]# cat -n /usr/local/mycat/conf/server.xml | sed -n '82p;95,99p'
    82			<property name="schemas">v_mysql</property>
    95		<user name="read">
    96			<property name="password">123456</property>
    97			<property name="schemas">v_mysql</property>
    98			<property name="readOnly">true</property>
    99		</user>
--------------------------end----------------------------------------

&部署readhost切换脚本  #不读

[root@ecs-maxscale1 ~]# cat /usr/bin/m_s_check.sh
#!/bin/bash
t=0
while :
do
 while [ $t -eq 0 ]
  do
     for i in {1..3}
          do
            ssh mysql$i "ifconfig eth0:1" | grep 192.168.  &>/dev/null
            if [ $? -eq 0 ]; then 
                mn=$i
                 grep mysql$mn /usr/local/mycat/conf/schema.xml | grep '<!--'  &>/dev/null
                     if [ $? -ne 0 ];then 
                                sed -ri "/mysql${mn}/s,(\s*)(<r.*\sh.*\su.*\su.*\sp.*\s.*>$),\1<\!--\2-->," /usr/local/mycat/conf/schema.xml
                                /usr/local/mycat/bin/mycat restart &>/dev/null  
                                t=1
                                break
                     fi
            fi 
          done
         t=1
  done
 
      for j in {1..5}
           do
                [ $j -eq $mn ] && continue
                nmap -n -sT -p 3306 mysql$j  | grep open &>/dev/null
                s_stat=$?    
            if [ $s_stat -eq 0 ]; then
                 grep mysql$j /usr/local/mycat/conf/schema.xml | grep '<!--'  &>/dev/null   
             
                 if [ $? -eq 0 ];then  
                    sed -ri "/mysql${j}/s,(\s*)(<!--)(<r.*\sh.*\su.*\su.*\sp.*\s.*>)(-->$),\1\3," /usr/local/mycat/conf/schema.xml
                    t=0
                    /usr/local/mycat/bin/mycat restart &>/dev/null  
                 fi
            fi
           done
  sleep 1
  ssh mysql$mn "ifconfig eth0:1" | grep 192.168.  &>/dev/null  
  [ $? -ne 0 ] && t=0

done


