云计算部署与管理
CLOUD DAY06

1.自定义镜像与仓库
  1.1 自定义镜像
      1.1.1 docker commit
      1.1.2 Dockerfile
  1.2 自定义镜像仓库
      1.2.1 registry基本概念
      1.2.2 自定义私有仓库
2.持久化存储
  2.1 存储卷
  2.2 共享存储 
3.Docker网络架构
################################################################   
自定义镜像与仓库
●自定义镜像 (打包镜像)
  语法： docker commit IDs name:label
• 使用镜像启动容器,在该容器基础上修改
• 另存为一个新镜像

#先给下载下来的centos镜像配置yun源，装包，再创建一个新的镜像
[root@f8455660c6d4 /]# echo "[centos7]
name=centos7
baseurl=ftp://192.168.1.254/centos7
enable=1
gpgcheck=0" > /etc/yum.repos.d/centos.repo            
[root@f8455660c6d4 /]# yum -y install tree net-tools psmisc vim lftp bash-completion
[root@docker01 ~]# docker commit 0bcf6fffad3b myos:latest
[root@docker01 ~]# docker images
################################################################
Dockerfile
• Dockerfile语法格式
– FROM:基础镜像
– MAINTAINER:镜像创建者信息
– EXPOSE:开放的端口
– ENV:设置变量
– ADD:复制文件到镜像
– RUN:制作镜像时执行的命令,可以有多个
– WORKDIR:定义容器默认工作目录  #相当于cd
– CMD:容器启动时执行的命令,仅可以有一条CMD  #CMD相当于定义上帝进程
################################################################
●案例1： 使用Dokerfile创建有yum的镜像
  [root@docker01 ~]# mkdir build
  [root@docker01 ~]# cd build/
  [root@docker01 build]# vim Dockerfile
  [root@docker01 build]# vim centos7.repo
  [root@docker01 build]# cat Dockerfile 
FROM centos
RUN rm -rf /etc/yum.repos.d/*
ADD centos7.repo /etc/yum.repos.d/centos7.repo
RUN yum -y install tree net-tools psmisc vim lftp bash-completion
  [root@docker01 build]# docker build -t ios:latest .   #必须写一个Dockerfile路径

●案例2： 使用Dokcerfile创建默认启动程序为python的镜像
  [root@docker01 ~]# mkdir myos
  [root@docker01 ~]# cd myos
  [root@docker01 myos]# cat Dockerfile 
FROM myos
ENV "PATH=usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin:/root/bin"
CMD ["/usr/bin/python"]
[root@docker01 myos]# docker build -t myos:python .

●案例3：使用Dockerfile创建允许ssh的镜像
补充：平常用systemctl启动的脚本是： /usr/lib/systemd/system/sshd.service 
 & 创建Dokcerfile 
  [root@docker01 ~]# cd myos
  [root@docker01 myos]# cat Dockerfile
FROM myos:latest
RUN yum -y install openssh-server initscripts
RUN sshd-keygen
ENV EnvironmentFile=/etc/sysconfig/sshd
RUN echo 1 | passwd --stdin root
CMD ["/usr/sbin/sshd", "-D"]     #python固定格式，原命令：/usr/sbin/sshd -D
 & 创建镜像
  [root@docker01 myos]# docker build -t myos:python .
 & 查新镜像IP 
  [root@docker01 myos]# docker run -it myos:ssh
  [root@docker01 myos]# docker ps  #找到myos:ssh的ID号
  [root@docker01 myos]# docker exec -it 106 bash
  [root@106e1dc18e59 /]# ifconfig
eth0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 172.17.0.5  netmask 255.255.0.0  broadcast 0.0.0.0
 & 登陆测试
  [root@docker01 myos]# ssh 172.17.0.5

●案例4：制作apache的docker 镜像
      设置首页为 hello world    #
//此处给出 Dockerfile 内容,
//httpd 的启动方法参考/usr/lib/systemd/system/httpd.service
FROM myos:latest
RUN yum -y install httpd
ENV EnvironmentFile=/etc/sysconfig/httpd
WORKDIR /var/www/html/     
RUN echo "hello world" > index.html
CMD ["/usr/sbin/httpd", "-DFOREGROUND"] 
################################################################
●在容器上起多个服务 以sshd，httpd为例
 &修改Dockerfile
  [root@docker01 myos]# cat Dockerfile
FROM myos:latest
RUN yum -y install httpd  openssh-server initscripts
ADD run.sh /etc/rc.d/init.d/run.sh
RUN chmod +x /etc/rc.d/init.d/run.sh
WORKDIR /var/www/html/
RUN echo "hello world" > index.html
RUN sshd-keygen
RUN echo 1 | passwd --stdin root
EXPOSE 80
EXPOSE 22
CMD ["/etc/rc.d/init.d/run.sh"]

 &创建启动sshd，httpd的脚本
  [root@docker01 myos]# cat run.sh
#!/bin/bash
EnvironmentFile=/etc/sysconfig/sshd  /usr/sbin/sshd -D  & 
EnvironmentFile=/etc/sysconfig/httpd  /usr/sbin/httpd -DFOREGROUND &
################################################################
制作私有镜像仓库
● 创建配置文件 /etc/docker/daemon.json
  {
   "insecure-registries" : ["192.168.1.20:5000"]
}
● 重起服务
   systemctl restart docker 
● 开启私有仓库
   docker run -itd -p 5000:5000 registry
● 验证
  curl http://192.168.1.20:5000/v2/  #版本2
  //能看到"{}" ,代表成功

● 指定标签
   docker tag busybox:latest 192.168.1.20:/5000/busybox:latest
   docker tag myos:ssh 192.168.1.20:5000/myos:ssh
   docker tag myos:http 192.168.1.20:5000/myos:http

● 上传数据
   docker push 192.168.1.20:5000/myos:http

●  验证
   //主机 docker02验证
   & 把配置文件复制到本地
    scp 192.168.1.20：/etc/docker/daemon.json /etc/docker
   & 起服务 docker
   & 远程仓库启动容器
     docker run -it 192.168.1.20:5000/myos:http

● 简单API
   & 查看仓库
    curl http://192.168.1.20:5000/v2/_catalog
   & 查看镜像标签
    curl http://192.168.1.20:5000/v2/myos/tags/list

################################################################
持久化存储


















