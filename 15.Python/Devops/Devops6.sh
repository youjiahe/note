运维开发实战
NSD DEVOPS DAY06
1.ansible回顾
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
●
##################################################################################	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	

