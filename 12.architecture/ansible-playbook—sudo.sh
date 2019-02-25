需求：
centos7机器A、B
机器B上sudo需要输入密码才能切换至root用户
机器A上如何编写ansible-playbook,才能使用在机器B上使用root用户进行操作
ansible 版本：ansible 2.7.0
inventory目录：/etc/ansible/
############################################################################################
根据官网：
ansible_ssh_host
      将要连接的远程主机名.与你想要设定的主机的别名不同的话,可通过此变量设置.

ansible_ssh_port
      ssh端口号.如果不是默认的端口号,通过此变量设置.

ansible_ssh_user
      默认的 ssh 用户名

ansible_ssh_pass
      ssh 密码(这种方式并不安全,我们强烈建议使用 --ask-pass 或 SSH 密钥)

ansible_sudo_pass
      sudo 密码(这种方式并不安全,我们强烈建议使用 --ask-sudo-pass)

ansible_sudo_exe (new in version 1.8)
      sudo 命令路径(适用于1.8及以上版本)

ansible_connection
      与主机的连接类型.比如:local, ssh 或者 paramiko. Ansible 1.2 以前默认使用 paramiko.1.2 以后默认使用 'smart','smart' 方式会根据是否支持 ControlPersist, 来判断'ssh' 方式是否可行.

ansible_ssh_private_key_file
      ssh 使用的私钥文件.适用于有多个密钥,而你不想使用 SSH 代理的情况.

ansible_shell_type
      目标系统的shell类型.默认情况下,命令的执行使用 'sh' 语法,可设置为 'csh' 或 'fish'.

ansible_python_interpreter
      目标主机的 python 路径.适用于的情况: 系统中有多个 Python, 或者命令路径不是"/usr/bin/python",比如  \*BSD, 或者 /usr/bin/python
      不是 2.X 版本的 Python.我们不使用 "/usr/bin/env" 机制,因为这要求远程用户的路径设置正确,且要求 "python" 可执行程序名不可为 python以外的名字(实际有可能名为python26).

      与 ansible_python_interpreter 的工作方式相同,可设定如 ruby 或 perl 的路径....
############################################################################################
1、我们先使用ansible_sudo_pass试试看
编辑/etc/ansible/hosts
vim /etc/ansible/hosts
[test1]
192.168.1.1 ansible_sudo_pass='aa123'

写一个playbook
vim test.yml

- hosts: test1
  user: test
  tasks:
      - name: just test
        become: yes
        become_user: root
        become_method: sudo
        shell: mkdir -p /tmp/test

执行一下
ansible-playbook test.yml
登陆机器B：test1上，发现/tmp/test文件夹创建成功
############################################################################################
2、我们使用安全的方式试试看
既然官方文档强烈建议使用--ask-sudo-pass参数，我们试一下这种方法
在/etc/ansible/hosts里面把sudo密码注释掉
[test1]
192.168.1.1

执行刚才的test.yml,执行命令如下
ansible-playbook --ask-sudo-pass test.yml
会发现出现如下界面
SUDO password
输入sudo的密码，执行成功
小结
方法一：方便快捷
方法二：安全
