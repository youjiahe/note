大型架构及配置技术
NSD ARCHITECTURE DAY01

1.ansible基础
2.ad-hoc
3.批量配置管理
4.运维开发工程师必备技能
git
python,shell
jenkins
ansible
KVM,openstack,docker
##################################################################################
● 什么是ansible  #python开发的，自动化运维
 & ansible是2013年推出的一款IT自动化和DevOps软
   件,2015年被RedHat收购。是基于Python研发,
   糅合很多老运维工具的优点,实现了批量操作系统配
   置,批量程序部署,批量运行命令等功能
 & ansible可以实现:
   – 自动化部署APP
   – 自动化管理配置项
   – 自动化持续交付
   – 自动化(AWS)云服务管理

● 为什么选择ansible
 & 选择一款配置管理软件,无外乎从以下几点来权衡利弊
   – 活跃度(社区)
   – 学习成本
   – 使用成本
   – 编码语言
   – 性能
   – 使用是否广泛

 & ansible优点
   – 只需要SSH和Python即可使用
   – 无客户端
   – ansible功能强大,模块丰富
   – 上手容易,门槛低
   – 基于Python开发,做二次开发更容易
   – 使用公司比较多,社区活跃

● ansible特性
 & 模块化设计,调用特定的模块完成特定任务
 & 基于Python诧言实现
  – paramiko
  – PyYAML (半结构化诧言)
  – Jinja2
 & 其模块支持JSON等标准输出格式,可以采用任何编
    程语言重写
 & 部署简单
 & 支持自定义模块
 & 支持playbook
 & 易于使用
 & 支持多层部署
 & 支持异构IT环境
##################################################################################
ansible工作流程
再补充

##################################################################################
软件依赖关系(续1)
 & 对亍被托管主机
   – ansible默认通过SSH协议管理机器
   – 被管理主机要开吭ssh服务,允许ansible主机登彔
   – 在托管节点上也需要安装Python2.5戒以上的版本
   – 如果托管节点上开吭了SElinux,需要安装libselinux-
   python
##################################################################################
安装ansible
• ansible可以基亍源码运行
• 源码安装
– pip,需要配置扩展软件包源extras
– git
   yum install epel-release
   yum install git python2-pip
– pip安装依赖模块
   pip install paramiko PyYAML Jinja2 httplib2 six

安装ansible(续1)
• ansible源码下载
– git clone git://github.com/ansible/ansible.git
– yum install python-setuptools python-devel
– python setup.py build
– python setup.py install
• pip方式安装
– pip install ansible


安装ansible(续2)  #实验用这个
• yum扩展源安装简单,自劢解决依赖关系(推荐)
– http://mirror.centos.org/.../.../extras/
– yum install ansible
• 安装完成以后验证
– ansible --version
##################################################################################
案例1:环境准备
1. 启动6台虚拟机
2. 禁用selinux和firewalld
3. 编辑/etc/hosts
4. 配置yum扩展源并在管理节点安装ansible
##################################################################################
主机定义与分组
• 安装ansible乊后可以做一些简单的任务
• ansible配置文件查找顺序
    – 首先检测ANSIBLE_CONFIG变量定义的配置文件
    – 其次检查当前目彔下的 ./ansible.cfg 文件
    – 再次检查当前用户家目彔下 ~/ansible.cfg 文件
    – 最后检查/etc/ansible/ansible.cfg文件
• /etc/ansible/ansible.cfg是ansible的默认配置文件路径

主机定义与分组(续1)
• ansible.cfg 配置文件
   – inventory定义托管主机地址配置文件
    – 先编辑/etc/ansible/hosts文件,写入远程主机的地址。
• 格式
– # 表示注释
   [组名称]
   主机名称戒ip地址,登彔用户名,密码、端口等信息
   //web1,root,1,22
• 测试
– ansible [组名称] --list-hosts
##################################################################################
配置ansible
● 定义托管主机地址配置文件
  [root@ansible ~]# sed -n "/^inven/p" /etc/ansible/ansible.cfg
   inventory      = /etc/ansible/hosts   #取消注释
● 自定义分组  #编辑/etc/ansible/hosts 
   [root@ansible ~]# tail /etc/ansible/hosts 
   [web]
   web1
   web2
   
   [db]
   db1
   db2
   
   [cach]
   cache
   
● 查看分组  
  [root@ansible ~]# ansible web --list-hosts
    hosts (2):
      web1
      web2
  [root@ansible ~]# ansible cach --list-hosts
    hosts (1):
      cache
  [root@ansible ~]# ansible db --list-hosts
    hosts (2):
      db1
      db2
##################################################################################
● 测试ansible主机
[root@ansible ~]# sed -n '61p' /etc/ansible/ansible.cfg  #取消注释
host_key_checking = False
[root@ansible ~]# ansible web -m ping
web2 | SUCCESS => {
    "changed": false, 
    "ping": "pong"
}
web1 | SUCCESS => {
    "changed": false, 
    "ping": "pong"
}


































