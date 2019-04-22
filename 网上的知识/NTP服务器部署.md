## NTP时间服务器搭建部署

#### 一．NTP介绍
```python
NTP（Network Time Protocol，网络时间协议）是用来使网络中的各个计算机时间同步的一种协议。它的用途是把计算机的时钟同步到世界协调时UTC，其精度在局域网内可达0.1ms，在互联网上绝大多数的地方其精度可以达到1-50ms。
NTP服务器就是利用NTP协议提供时间同步服务的
```
#### 二．NTP服务器安装
1. 查看本机系统版本
```bash
cat /etc/redhat-release 
```
2. 查看本机NTP软件包
```bash
rpm -qa ntp
```
#### 三．NTP服务器配置
1. 备份ntp服务器配置文件
```bash
cp /etc/ntp.conf /etc/ntp.conf.bak
ll /etc/ntp.conf*
```
2. 精简优化配置文件
```bash
egrep -v "^$|#" /etc/ntp.conf.bak >/etc/ntp.conf
```
3. 编辑配置文件

![ntp.conf](https://s1.51cto.com/images/blog/201803/21/1be243d95cbfe02fd9514fe2154c6a1c.png?x-oss-process=image/watermark,size_16,text_QDUxQ1RP5Y2a5a6i,color_FFFFFF,t_100,g_se,x_10,y_10,shadow_90,type_ZmFuZ3poZW5naGVpdGk=)
```bash
vim /etc/ntp.conf
driftfile /var/lib/ntp/drift
restrict default kod nomodify notrap nopeer noquery
restrict -6 default kod nomodify notrap nopeer noquery
restrict 127.0.0.1 
restrict -6 ::1

#允许内网其他机器同步时间
restrict 172.16.1.0 mask 255.255.255.0 nomodify notr 
#server 0.centos.pool.ntp.org iburst
#server 1.centos.pool.ntp.org iburst
#server 2.centos.pool.ntp.org iburst
#server 3.centos.pool.ntp.org iburst

#定义使用的上游 ntp服务器，将原来的注释
server ntp1.aliyun.com
server time1.aliyun.com

#允许上层时间服务器主动修改本机时间
restrict time1.aliyun.com nomodify notrap noquery
restrict ntp1.aliyun.com nomodify notrap noquery

#外部时间服务器不可用时，以本地时间作为时间服务
server 127.127.1.0 
fudge 127.127.1.0 stratum 10
includefile /etc/ntp/crypto/pw
keys /etc/ntp/keys
```
#### 四．启动NTP服务器
```bash
Centos6: /etc/init.d/ntpd start 
centos7: systemctl start ntpd
```
ntpq -p #显示节点列表

![ntpq -p 显示节点列表](https://s1.51cto.com/images/blog/201803/21/3906d7da259ec5365705dbb51467695c.png?x-oss-process=image/watermark,size_16,text_QDUxQ1RP5Y2a5a6i,color_FFFFFF,t_100,g_se,x_10,y_10,shadow_90,type_ZmFuZ3poZW5naGVpdGk=)

#### 五．客户端时间同步测试
```bash
ntpdate 10.0.0.111（ntp服务器）
```
