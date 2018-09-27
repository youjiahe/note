+++++++++++++++++++++++++++++++++++++++++++++++++++
&把/etc/passwd文件的内容存储到teadb库下的usertab表里，并做如下配置：
&6 在name字段下方添加s_year字段 存放出生年份 默认值是1990               
&7 在name字段下方添加字段名sex 字段值只能是gril 或boy 默认值是 boy
&8 在sex字段下方添加 age字段  存放年龄 不允许输入负数。默认值 是 21
&9 把uid字段值是10到50之间的用户的性别修改为 girl
&10 统计性别是girl的用户有多少个。8个
mysql> select count(*) from usertab where sex="girl";

&12 查看性别是girl用户里 uid号 最大的用户名 叫什么。
  select name from usertab where uid=(select max(uid) from usertab where sex="girl");
+------+
| name |
+------+
| gdm  |
+------+

&13 添加一条新记录只给name、uid 字段赋值 值为rtestd  1000
   添加一条新记录只给name、uid 字段赋值 值为rtest2d   2000
   mysql> insert into usertab(name,uid) values("rtestd","1000");
   mysql> insert into usertab(name,uid) values("rtest2d","2000");

&14 显示uid 是四位数的用户的用户名和uid值。
  select name,uid from usertab where uid between 1000 and 9999;
&15 显示名字是以字母r 开头 且是以字母d结尾的用户名和uid。 
   select name,uid from usertab where name like "r%d";
   select name,uid from usertab where name regexp "^r.*d$";
&16  查看是否有 名字以字母a开头 并且是 以字母c结尾的用户。 
   select name from usertab where name like "a%c";
&8  把gid  在100到500间用户的家目录修改为/root
   update usertab set home="/root" where gid between 100 and 500;
&9  把用户是  root 、 bin 、  sync 用户的shell 修改为  /sbin/nologin
   update usertab set shell="/sbin/nologin" where name in ("root","bin","sync");
&10   查看  gid 小于10的用户 都使用那些shell
  select distinct shell from usertab where gid<10;
&12   删除  名字以字母d开头的用户。
   delete from usertab where name regexp "^d";
&13   查询  gid 最大的前5个用户 使用的 shell
    select shell from usertab order by gid desc limit 5;
&14   查看那些用户没有家目录
   select * from usertab where home is null ;
&15  把gid号最小的前5个用户信息保存到/mybak/min5.txt文件里。 
    使用useradd 命令添加登录系统的用户 名为lucy 
  mkdir /mybak
  chown mysql /mybak
  vim /etc/my.cnf
  [mysql]
   secure_file_priv=/mybak
    mysql>select * from usertab order by gid asc limit 5 into outfile "/mybak/min5.txt";
&16  把lucy用户的信息 添加到user1表里
    create table user1 select * from usertab where name="lucy";
&17  删除表中的 comment 字段 
    alter table usertab drop comment;
&18  设置表中所有字段值不允许为空      
     alter table usertab modify gid int(5)  not null;
    alter table usertab modify gid int(5)  not null;
     alter table usertab modify home char(60)  not null;
&19  删除root 用户家目录字段的值
    update usertab set home="" where name="root";
&20  显示 gid 大于500的用户的用户名 家目录和使用的shell
     select name,home,shell from usertab where gid>500;
&21  删除uid大于100的用户记录
     delete from usertab where uid>100;
&22  显示uid号在10到30区间的用户有多少个。
     mysql> select count(*) from usertab where uid between 10 and 30;
+----------+
| count(*) |
+----------+
|        5 |
+----------+

&23  显示uid号是100以内的用户使用shell的类型。
     select distinct shell from usertab where uid<100;
&24  显示uid号最小的前10个用户的信息。
    select * from usertab uid order by uid  asc limit 10;
&25  显示表中第10条到第15条记录
      alter table usertab add id int(5) primary key auto_increment first;
     select * from usertab where id between 10 and 15;
&26  显示uid号小于50且名字里有字母a  用户的详细信息
     select * from usertab where uid<50 and name like "%a%";
     或者select * from usertab where uid<50 and name regexp "[a]";
&27  只显示用户 root   bin   daemon  3个用户的详细信息。
   select * from usertab where name in ("root","bin","daemon");
&28  显示除root用户之外所有用户的详细信息。
     select * from usertab where name not in ("root");
&29  统计username 字段有多少条记录
    select count(*) from usertab where name is not null;
&30  显示名字里含字母c  用户的详细信息
     select * from usertab where name like "%c%";
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
&31  在sex字段下方添加名为pay的字段，用来存储工资，默认值    是5000.00
    alter table usertab add pay float(7,2) default 5000 after sex ;
&32  把所有女孩的工资修改为10000
   update usertab set pay=10000 where sex="girl";
&33  把root用户的工资修改为30000
   update usertab set pay=30000 where name="root";
    给adm用户涨500元工资
    update usertab set pay=pay+500 where name="adm";
&34  查看所有用户的名字和工资
     select name,pay from usertab;
&35  查看工资字段的平均值
   select avg(pay) from usertab;
&36  查看工资字段值小于平均工资的用户 是谁。
    select name,pay  from usertab where  pay<(select avg(pay) from usertab);
      查看女生里谁的uid号最大
   select name,sex,uid from usertab where uid=(select max(uid) from usertab where sex="girl");
38  查看bin用户的uid gid 字段的值 及 这2个字段相加的和 
    mysql> select uid,gid,uid+gid as ugid from usertab where name="bin";
+-----+-----+------+
| uid | gid | ugid |
+-----+-----+------+
|   1 |   1 |    2 |
+-----+-----+------+
 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++





























