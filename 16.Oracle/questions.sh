1.ORA-09925: Unable to create audit trail file带来的sqlplus / as sysdba无法连接

SQL> show parameter pfile;

/picclife/app/oracle/product/11.2.0/dbhome_1/dbs/spfilehukou.ora

SQL> show parameter audit_file_dest

/picclife/app/oracle/admin/hukou/adump

[oracle@yang ~]$ cd /picclife/app/oracle/product/11.2.0/dbhome_1/dbs/

[oracle@yang dbs]$ vi inithukou.ora

*.audit_file_dest='$ORACLE_BASE/admin/huko/adump'        hukou=>改为huko

Oracle： sqlplus / as sysdba

SQL> create spfile from pfile;

SQL> startup nomount;

 

 ---以上修改参数文件audit_file_dest参数文件，重启库后，sqlplus / as sysdba报错

 [oracle@yang dbs]$ sqlplus / as sysdba

 ERROR:
 ORA-09925: Unable to create audit trail file
 Linux-x86_64 Error: 2: No such file or directory
 Additional information: 9925
 ORA-01075: you are currently logged on

 [oracle@yang dbs]$ vi inithukou.ora

 *.audit_file_dest='$ORACLE_BASE/admin/hukou/adump'

 [oracle@yang dbs]$ mv spfilehukou.ora spfilehukou.ora.bak

 --但是呢，你很尴尬的发现，因为现在数据库最少启动到了Nomount的阶段，你SQLPLUS登录一直提示你操作系统验证无法进入；

 很尴尬对吧，无法进入sql*plus就无法修改参数文件，就无法启动数据库；

  

  ----------

  解决方法：[oracle@yang ~]$ ps -ef|grep ora_smon_hukou             ora_进程名称：SMON,PMON,DBWR,LGWR,CKPT,  oracle_sid=hukou
  oracle    7438  7262  0 04:58 pts/0    00:00:00 grep *pmon*

  [oracle@yang ~]$ kill -s 9 7438

  会话包括实例都被干掉了；

  SQL> create spfile from pfile;

  SQL> shutdown immediate;

  SQL> startup

  SQL> show parameter pfile;

  /picclife/app/oracle/product/11.2.0/dbhome_1/dbs/spfilehukou.ora

   

    

     

     ---审计目录，干啥用的？

     SQL> show parameter audit_file_dest

     /picclife/app/oracle/admin/hukou/adump

     [root@yang adump]# cd /picclife/app/oracle/admin/hukou/adump/

     [root@yang adump]# ls

     [root@yang adump]# rm -f *

     [oracle@yang ~]$ sqlplus / as sysdba

     [root@yang adump]# ls
     hukou_ora_8423_20171102051747052914143795.aud

     [root@yang adump]# cat hukou_ora_8423_20171102051747052914143795.aud Audit file /picclife/app/oracle/admin/hukou/adump/hukou_ora_8423_20171102051747052914143795.aud Oracle Database 11g Enterprise Edition Release 11.2.0.4.0 - 64bit Production With the Partitioning, OLAP, Data Mining and Real Application Testing options ORACLE_HOME = /picclife/app/oracle/product/11.2.0/dbhome_1 System name:    Linux Node name:      yang Release:        2.6.32-100.26.2.el5 Version:        #1 SMP Tue Jan 18 20:11:49 EST 2011 Machine:        x86_64 Instance name: hukou Redo thread mounted by this instance: 1 Oracle process number: 19 Unix process pid: 8423, image: oracle@yang (TNS V1-V3)

     Thu Nov  2 05:17:47 2017 +08:00 LENGTH : '160' ACTION :[7] 'CONNECT' DATABASE USER:[1] '/' PRIVILEGE :[6] 'SYSDBA' CLIENT USER:[6] 'oracle' CLIENT TERMINAL:[5] 'pts/0' STATUS:[1] '0' DBID:[10] '3862096839'

     总结：使用sysdba身份登录，都会在审计文件目录中，自动生成一个审计文件，如果目录指向未知，则无法使用sysdba身份登录；

      

      偏外：告警日志：alert.log

      SQL> show parameter dump

      background_dump_dest    alert.log日志存放路径

      user_dump_dest                用户审计文件，例如： SQL>alter session set events 'immediate trace name controlf level 12';--sid_ora_xx.trc
####################################################################
