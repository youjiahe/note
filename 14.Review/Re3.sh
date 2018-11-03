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





























