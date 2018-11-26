运维开发实战
NSD DEVOPS DAY06
1.ansible回顾
2.python-ansible 模块使用
3.自定义ansible模块
##################################################################################
使用ansible
●安装ansible
  [root@room9pc01 ~]# pip3 install ansible
●准备3台虚拟机: 配置IP地址和主机名
	192.168.1.11 ansible1
	192.168.1.12 ansible2
	192.168.1.13 ansible3
●配置名称解析
	[root@room8pc16 devops]# for i in {1..254}
	> do
	> echo -e "192.168.1.$i\tnode$i.tedu.cn\tnode$i" >> /etc/hosts
	> done
●基础配置
	[root@room8pc16 day14]# mkdir myansible
	[root@room8pc16 day14]# cd myansible
	[root@room8pc16 myansible]# vim ansible.cfg
	[defaults]
	inventory = hosts
	remote_user = root
	[root@room8pc16 myansible]# vim hosts
	[webservers]
	node3.tedu.cn
	node4.tedu.cn

	[dbservers]
	node5.tedu.cn
●收集主机密钥
	[root@room8pc16 myansible]# ssh-keyscan node{3..5}.tedu.cn >> ~/.ssh/known_hosts
●ad-hoc方式
	[root@room8pc16 myansible]# ansible all -m ping -k
●配置vim
	[root@room8pc16 myansible]# vim ~/.vimrc
	set ai     # 自动缩进
	set ts=4   # tab键是4个空格
	set et     # tab键转成空格
	autocmd FileType yaml setlocal sw=2 ts=2 et ai   # yml文件生效
●创建playbook，用于免密登陆、配置yum
	[root@room8pc16 myansible]# mkdir files
	[root@room8pc16 myansible]# vim files/server.repo
	[server]
	name=server
	baseurl=ftp://192.168.4.254/rhel7.4
	enabled=1
	gpgcheck=0
	
	[root@room8pc16 myansible]# vim sys_init.yml
	---
	- name: init system
	  hosts: all
	  tasks:
		- name: upload public key
		  authorized_key:
		    user: root
		    state: present
		    key: "{{ lookup('file', '/root/.ssh/id_rsa.pub') }}"
		- name: upload yum configure file
		  copy:
		    src: files/server.repo
		    dest: /etc/yum.repos.d/server.repo
	[root@room8pc16 myansible]# ansible-playbook --syntax-check sys_init.yml
	[root@room8pc16 myansible]# ansible-playbook sys_init.yml -k

##################################################################################	
●ansible 文档
	http://docs.ansible.com/  -> Ansible Documentation ->搜索python api
●使用python 运性ansible命令
  & 命名的元组：
	传统的元组是序列对象，通过下标访问；命名元组扩展了传统的元组，为每个元素添加了额
	外的名称，仍可以按传统的方式访问。
	>>> from collections import namedtuple
	>>> point = namedtuple('point', ['x', 'y', 'z'])
	>>> a = point(10, 20, 25)
	>>> a[0]
	10
	>>> a[1:]
	(20, 25)
	>>> a.x
	10
	>>> a.z
	25

  & ansible-cmdb
     — 作用：收集ansible 的 setup 模块信息，并且分析信息，导出web页面
	[root@room8pc16 day14]# pip3 install ansible-cmdb
	[root@room8pc16 day14]# mkdir /tmp/ansi_cmdb
	[root@room8pc16 myansible]# ansible all -m setup --tree /tmp/ansi_cmdb/out
	[root@room8pc16 myansible]# ansible-cmdb /tmp/ansi_cmdb/out/ > /tmp/ansi_cmdb/out.html
	[root@room8pc16 myansible]# firefox /tmp/ansi_cmdb/out.html
	
  & 问题的解决：
	1、mako
	[root@room8pc16 myansible]# pip3 install mako
	2、运行ansible-cmdb出错
	[root@room8pc16 myansible]# which ansible-cmdb
	[root@room8pc16 myansible]# vikm /usr/local/bin/ansible-cmdb
	将PY_BIN=$(which python) 修改为
	PY_BIN=$(which python3)
##################################################################################
编写ansible模块
●创建自定义模块路径
●设置环境变量，ANSIBLE_LIBRARY=./mymodule
●编写模块，用于实现本地文件拷贝
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	

