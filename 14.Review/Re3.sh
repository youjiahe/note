第一阶段复习
##################################################################################
管道
●tr
[root@youjiahe ~]# cat a.txt | tr 'a-z' 'A-Z'
ABCDEFG
HIJKLM
OOO
[root@youjiahe ~]# cat a.txt | tr 'A-Z' 'a-z'
abcdefg
hijklm
ooo
[root@youjiahe ~]# cat a.txt 
abcDefg
hijklm
ooo

[root@youjiahe ~]# echo 123awt125 | tr -cd [0-9]
123125

●重定向
[root@youjiahe ~]# cat <<EOF > /opt/1.txt
[development]
name=centos
baseurl=ftp://192.168.1.242/centos7
enable=1
gpgcheck=0
EOF

[root@youjiahe ~]# cat /opt/1.txt 
[development]
name=centos
baseurl=ftp://192.168.1.242/centos7
enable=1
gpgcheck=0

##################################################################################
管理用户和组
脚本：创建用户，用户名为user1 密码123456 首次登陆强之修改密码；执行脚本默认创建5个用户，也可以通过位置参数指定创建多少个用户

nn=0

if  [ -z $1 ]; then
    num=5
elif [[ ! $1 =~ ^[0-9]+$ ]]; then                
#正则匹配
    echo "Input invaild,must be number" >&2
    exit 2
fi

num=$1

while [ $c -lt $num ] &>/dev/null 
  do
        id user$n &>/dev/null
        if [ $? -ne 0 ]; then
            nn=$n
            useradd user$nn  &>/dev/null
            echo 123456 | passwd --stdin user$nn &>/dev/null
            chage -d 0 user$nn
            let c++
            echo -en "create user${nn}\t"
            echo -e "\e[32m[done]\e[0m"
        else
            let n++
        fi
  done
##################################################################################
权限
chmod 755 1.txt

SUID:以所有者身份执行命令
SGID
Sticky bit

























