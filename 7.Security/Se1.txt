Security day1
Linux基本防护

1.用户账户安全
  1.1 设置账号有效期
  1.2 账号的锁定解锁
  1.3 强值定期修改密码
  1.4 /etc/issue
2.文件系统安全
  2.1 程序和服务控制
  2.2 锁定/解锁保护文件
3.用户切换与提权
  3.1 su切换用户身份  
  3.2 sudo提升执行权限
4.ssh访问控制
  4.1 ssh基本防护
        4.1.1 ssh防护概述
        4.1.2 sshd基本安全配置
        4.1.3 sshd黑/白名单配置
  4.2 sshd验证方式控制 
5.SElinux安全防护
################################################################################
●账户有效期设置
  chage -l #查看账户有效期
  chage -E 2019-08-15 zhangsan #设置帐号有效期
  #cat /etc/login.defs
  密码最长有效期，密码最短有效期，密码最短长度，密码过期前几天提示警告信息，UID最小值，UID最大值
################################################################################
●锁定密码
  passwd -l zhangsan #锁定用户
  passwd -S zhangsan #查看用户锁定状态
  passwd -u zhangsan #解锁
################################################################################
●内核信息
  /etc/issue
################################################################################
mount -o remount,rw,noexec /dev/vda1 /boot  #/boot下的所有执行程序都不能执行
mount |grep boot  #查看/boot的挂载属性
/dev/vda1 on /boot type xfs (rw,relatime,seclabel,attr2,inode64,noquota)
################################################################################
●文件目录时间
  atime #文件访问时间
  mtime #文件更改时间，默认显示的时间
  ctime #属性更改时间
  ll --time=ctime xyz.txt
  [root@proxy ~]# cat /etc/fstab
  /dev/vda1   /boot    xfs   defaults,noexec   0  0
  /dev/vda3   /home    xfs   defaults,noatime  0  0
################################################################################
●attr 属性
  chattr +i  文件名                    //锁定文件（无法修改、删除等）
  chattr -i  文件名                    //解锁文件
  chattr +a  文件名                    //锁定后文件仅可追加
  chattr -a  文件名                    //解锁文件
  lsattr 文件名                         //查看文件特殊属性
################################################################################
●sudo #企业用得很多
  对比：
  su - 用户 
  su - 用户 -c "命令"
  sudo不需要管理员密码，可有管理员权限
●修改/etc/sudoers配置
  //vim      #有颜色，没有语法检测
  //visudo   #没有颜色，带语法检查
  root    ALL=(ALL)       ALL
  softadm ALL=(ALL)       /usr/bin/systemctl  
  useradm ALL=(ALL)        /usr/sbin/user*,/usr/bin/passwd,!/usr/bin/passwd root,!/    usr/sbin/user* * root,!/usr/sbin/user* root,/usr/bin/echo

●修改配置文件有模版
  # Cmnd_Alias SOFTWARE = /bin/rpm, /usr/bin/up2date, /usr/bin/yum
  # Cmnd_Alias STORAGE = /sbin/fdisk, /sbin/sfdisk, /sbin/parted, /sbin/partprobe, /
    bin/mount, /bin/umount

●sudo -l
  sudo -l  #登陆sudo权限
  sudo systemctl stop crond

●wheel.
  把用户加到wheel组后，就有root的权限
  sudo useradd kobe

●visudo   添加日志设置
  Defaults logfile="/var/log/sudo"
●查看
 [root@proxy ~]# tailf /var/log/sudo 
 Aug 29 11:40:38 : xroot : TTY=pts/0 ; PWD=/home/xroot ; USER=root ;
    COMMAND=/sbin/useradd -s /sbin/nologin wade

#################################################################################
提高SSH的安全性
●禁止root远程登陆
  vim /etc/ssh/sshd_config
  Protocol 2                                          //SSH协议,1版本有漏洞
  PermitRootLogin no                                  //禁止root用户登录
  PermitEmptyPasswords no                              //禁止密码为空
  UseDNS  no                                          //不解析客户机地址
  LoginGraceTime  1m                                  //登录限时
  MaxAuthTries  3                                      //每连接最多认证次数
.. ..
  AllowUsers zhangsan tom useradm@192.168.4.0/24      //定义账户白名单
  DebyUsers                                           //定义黑名单
  PasswordAuthentication no                           //关闭密码登陆
##################################################################################
Xshell
传递公钥到服务器
authorized_keys
##################################################################################
SElinux
ls -Z /var/www/html/
写策略：
    什么程序，能读取有什么标签的文件
      httpd,httpd_sys_content_t
策略：
1.安全(仅限制网络程序的访问)
  nginx,ftp,samba,http
  其他默认全部拒绝
2.非常安全
  只允许默认的几个程序


SELINUX=permissive
SELINUXTYPE=targeted

更改
安全上下文

chcon -t 标签 文件





































