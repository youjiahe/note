#!/bin/bash
if [ -z $1 ] || [ ! -f $1 ]; then
 echo "文件未指定或者不存在"  >&2
 exit 12
fi
while [ -z $pass ]
do
  read -p "虚拟机密码:" pass
done
while [ -z $bri ]
do
 read -p "真机IP[对应虚拟交换机]:" bri
done
cp ./lnmp_soft.tar.gz /var/ftp/share/
tar -xf /var/ftp/share/lnmp_soft.tar.gz -C /var/ftp/share/
systemctl restart vsftpd

if [ ! -d /var/ftp/share/lnmp_soft ]; then
echo "未部署lnmp_soft到ftp"
exit
fi 
pscp.pssh -h $1 $1 /root
rpm -qa | grep pssh
if [ $? -ne 0 ];then    
   echo "未安装pssh" 
   echo "准备安装pssh"
   sleep 1
   wget ftp://${bri}/share/lnmp_soft/pssh-2.3.1-5.el7.noarch.rpm 
   yum -y install pssh-2.3.1-5.el7.noarch.rpm 
fi
rpm -qa | grep expect 
if [ $? -ne 0 ];then 
   echo "未安装expect" 
   echo "准备安装expect"
   yum -y install expect
fi
ii=`ifconfig | head -1 | awk -F "[: ]" '{print $1}'`
ip=`ifconfig $ii | awk '/inet /{print $2}'`
for i in `cat $1`
do
    [ $ip == $i ] && continue
    p=${i##*.}
    expect << EOF
spawn ssh -o StrictHostKeyChecking=no $i
expect "#"  {send "sed -i \'/$i/d\' $1\n"}
expect "#"  {send "ssh-keygen -N \'\' -f \"/root/.ssh/id_rsa\"\n"}
expect "(y/n)" {send "y\n"}
expect "#"  {send "wget ftp://${bri}/share/lnmp_soft/pssh-2.3.1-5.el7.noarch.rpm\n"}
expect "#"  {send "yum -y install pssh-2.3.1-5.el7.noarch.rpm\n"}
expect "#"  {send "pscp.pssh -x \"-o StrictHostKeyChecking=no\" -A -h $1 /root/.ssh/id_rsa.pub /root/.ssh/id_rsa${p}.pub\n"}
expect "Password:" {send "${pass}\n"}
expect "#"  {send "pssh -A -h $1 \"cat /root/.ssh/id_rsa${p}.pub  >> /root/.ssh/authorized_keys\"\n"}
expect "Password:" {send "${pass}\n"}
expect "#"  {send "pssh -A -h $1 \"rm -rf /root/.ssh/id_rsa${p}.pub\"\n"}
expect "Password:" {send "${pass}\n"}
expect "#"  {send "exit\n"}
EOF
done
