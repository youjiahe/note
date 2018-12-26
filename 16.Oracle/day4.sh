oracle
 1.同义词
 2.序列
 3.视图
 4.索引
 5.表空间

###############同义词########################
  create user xiaojiejie identified by Nfdw1234 account unlock;
  grant connect,resource to xiaojiejie;
  grant create synonym to xiaojiejie;   #授权创建同义词
  create synonym myemp for scott.emp;   #创建同义词
  conn scott;
  grant all on emp to xiaojiejie;
  conn xiaojiejie;
  select * from myemp;  

###############序列########################
  create sequence myseq
     minvalue 1
     start with 1
     nomaxvalue
     nocycle
     increment by 1
     cache 30;

 SQL> select myseq.nextval from dual;

      NEXTVAL
      ----------
      	 1
###############视图########################
  conn scott;
  create view emp1 as select rownum R,ename en, job j ,sal s,comm c from (select * from emp e order by sal desc) where rownum<=5;
