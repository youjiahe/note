#!/usr/bin/env python3
from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy import Column,Integer,String,Enum,ColumnDefault,Date,ForeignKey
from sqlalchemy.orm import sessionmaker   #连接数据库，建立session会话
import json
engine = create_engine(
    "sqlite:////root/git/python/devweb/day7/myansible/db.sqlite3",
    encoding="utf8",
)

Base = declarative_base()  #创建基类
Session = sessionmaker(bind=engine)

class HostGroup(Base):
    __tablename__='webansi_hostgroup'
    id=Column(Integer,primary_key=True)
    groupname=Column(String(50),unique=True)

    def __str__(self):
        return self.groupname

class Host(Base):
    __tablename__='webansi_host'
    id=Column(Integer,primary_key=True)
    hostname=Column(String(50),unique=True)
    ipaddr=Column(String(15))
    group_id=Column(Integer,ForeignKey('webansi_hostgroup.id',ondelete=True))

    def __str__(self):
        return '<%s : %s>'  % (self.hostname,self.ipaddr)

class AnsibleModule(Base):
    __tablename__='webansi_ansimodule'
    id = Column(Integer,primary_key=True)
    module_name=Column(String(30),unique=True)

    def __str__(self):
        return self.module_name

if __name__ == '__main__':
    session=Session()
    qset = session.query(Host.ipaddr,HostGroup.groupname)\
        .join(HostGroup,Host.group_id==HostGroup.id)
    dict = {}
    for ip,group in qset:
        if group not in dict:
            dict[group]={}  #{'dbserver':{}}
            dict[group]['hosts']=[] # #{'dbserver':{'hosts':[]}}
        dict[group]['hosts'].append(ip)

    print(json.dumps(dict))


