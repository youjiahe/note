alter user scott account unlock;
alter user scott identified by Nfdw1234;
conn scott;
create table emp(
  empno number(4) not null,
  ename varchar2(10) not null,
  job varchar2(9) not null,
  mgr number(4) not null,
  hiredate date,
  sal number(7,2) not null,
  com number(7,2) not null,
  deptno number(2) not null
);
alter table emp add constraint PK_EMP primary key(empno);
alter table emp add constraint FK_EMP_EMP foreign key(mgr) references emp(empno);
select dbms_metadata.get_ddl('SCOTT',EMP) from dual;
create table dept(
  deptno number(2) not null primary key,
  dname varchar2(14) not null,
  loc varchar2(13)
);
alter table emp add constraint FK_EMP_DEPT foreign key(deptno) references dept(deptno); 


