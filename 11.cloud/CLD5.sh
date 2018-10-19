云计算部署与管理
CLOUD DAY05

1.Docker概述
2.部署Docker
3.Docker镜像
   3.1  导入、导出镜像
4.
################################################################   
Docker概述
●什么是容器
  & 容器技术已经成为应用程序封装和交付的核心技术
  & 容器技术的核心有以下几个内核技术组成
    -- Cgroups(Control Groups)-资源管理
    -- NameSpace-隔离  #隔离主机名、隔离文件系统、隔离进程PID、隔离网络
    -- SELinux安全
  & 由于是在物理机上实施隔离,启动一个容器,可以像
    启动一个进程一样快速
    
●docker容器    
  Docker 容器是一个开源的应用容器引擎，让开发者可以打包他们的应用以及依赖包到一个可移植的容器中，然后发布到任何流行的Linux机器上，也可以实现虚拟化。容器是完全使用沙箱机制，相互之间不会有任何接口（类似 iPhone 的 app）。几乎没有性能开销,可以很容易地在机器和数据中心中运行。最重要的是,他们不依赖于任何语言、框架包括系统。
  
●什么是Docker
  & Docker是开源完整的一套容器管理系统
  & Docker提供了一组命令，让用户更加方便地使用
     容器技术，而不需要过多地关注底层内核技术
  & docker没有系统，只有进程

  & 内核原理了解7 

●Docker优点
  & 相比于传统的虚拟化技术，Docker更加简洁高效，轻量化
  & 传统的虚拟机需要安装操作系统
  & 容器使用的公共库和程序(共享底层操作系统)
  
●Docker缺点
  & 容器的隔离性没有虚拟化强
  & 共用linux内核，安全性有先天的缺陷
  & 监控容器和排错比较难
  & SELinux难以驾驭
################################################################
部署Docker
●64位系统
●至少RHEL6.5以上的版本，最好最好是RHEL7
●关闭防火墙
●配置静态IP，书写主机

●安装Docker
  • 软件包列表:
   – docker-engine   #老师提供
   – docker-engine-selinux
   
  [root@docker01 ~]# ls
  anaconda-ks.cfg
  docker-engine-1.12.1-1.el7.centos.x86_64.rpm
  docker-engine-selinux-1.12.1-1.el7.centos.noarch.rpm
  docker_images.zip
  [root@docker01 ~]# yum -y install docker-engine-*
  [root@docker01 ~]# systemctl restart docker
  [root@docker01 ~]# systemctl enable docker
  [root@docker01 ~]# ifconfig 
  docker0: flags=4099<UP,BROADCAST,MULTICAST>  mtu 1500
        inet 172.17.0.1  netmask 255.255.0.0  broadcast 0.0.0.0
################################################################
Docker镜像
●什么是Docker镜像
  & 在Docker中容器是基于镜像启动的,容器是在前端盘运行的
  & 镜像是启动容器的核心
  & 镜像采用分层设计
  & 使用快照的COW技术,确保底层数据不丢失
●什么是分层设计
  & 后端盘与前端盘不断嵌套成多层，docker把所有的层打包成一个后端盘
  
●网络中的解析：
  & 镜像（Image）就是一堆只读层（read-only layer）的统一视角
  & 容器（container）的定义和镜像（image）几乎一模一样，也是一堆层的统一视角，唯一区别在于容器的最上面那一层是可读可写的。
  & 要点：容器 = 镜像 + 读写层。并且容器的定义并没有提及是否要运行容器。
  & 元数据（metadata）就是关于这个层的额外信息，它不仅能够让Docker获取运行和构建时的信息，还包括父层的层次信息。需要注意，只读层和读写层都包含元数据。
  &一个容器的元数据好像是被分成了很多文件，但或多或少能够在/var/lib/docker/containers/<id>目录下找到，<id>就是一个可读层的id。这个目录下的文件大多是运行时的数据，比如说网络，日志等等。
  
################################################################  
Docker基本指令  
镜像常用命令
命令列表
docker images
docker history   #查看镜像制作历史
docker inspect   #查看镜像底层信息
docker pull|push
Docker基本命令
docker rmi       #删除镜像
docker save|load #导出导入镜像
docker search    #在hub仓库上查找镜像
docker tag       #对镜像创建硬连接

容器常用命令
命令列表
docker run      #运行容器；-it，-itd；
docker ps       #查看容器列表;  选项：-a 显示关闭了的容器；-q 只显示PID
docker stop|start|restart  #关闭|启动|重启 容器
docker attach|exec #进入容器；attach经常用于调试排错； 一般情况用exec
docker inspect  #查看容器底层信息
docker top      #查看容器进程列表
docker rm       #删除容器
################################################################
Docker镜像操作 
●查看镜像
  [root@docker01 ~]# docker images  #查看镜像列表
查看镜像列表
– 镜像仓库名称
– 镜像标签
– 镜像ID
– 创建时间
– 大小

●Docker hub镜像仓库
  & https://hub.docker.com
  & Docker官方提供公共镜像的仓库(Registry)
    [root@docker01 ~]# docker search centos  #
  & 使用hub镜像仓库下载上传busybox镜像
    1.搜索镜像
     [root@docker01 ~]# docker search busybox
     busybox            Busybox base image.   #一般下载基础镜像
     [root@docker01 ~]# docker search docker
      docker        Docker in Docker!
   2.下载镜像
    [root@docker01 ~]# docker pull busybox  #push是上传
    [root@docker01 ~]# docker pull docker
   3.查看镜像
   [root@docker01 ~]# docker images
   REPOSITORY   TAG        IMAGE ID        CREATED         SIZE
   docker       latest     fd7e073eb60f    13 days ago     152 MB
   busybox      latest     59788edf1f3e    2 weeks ago     1.154 MB

●导入、导出镜像
  & 主机docker01 导出镜像
  [root@docker01 ~]# docker save docker >  docker.tar
  [root@docker01 ~]# scp docker.tar docker02:/root
  & 主机docker02 导入镜像
  [root@docker02 ~]# docker load < docker.tar

●导入老师的docker镜像，  
  [root@docker01 ~]# unzip docker_images.zip 
  [root@docker01 ~]# cd docker_images/
  [root@docker01 docker_images]# for i in `ls`; do docker load < $i; done
  [root@docker01 ~]# docker images

●查看镜像底层信息  
  [root@docker02 ~]# docker inspect redis
●查看镜像制作历史
  [root@docker02 ~]# docker history redis   
   
●创建镜像硬连接  
[root@docker02 ~]# docker tag ubuntu ubuntu:v1 
[root@docker02 ~]# docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
ubuntu              latest              452a96d81c30        5 months ago        79.62 MB
ubuntu              v1                  452a96d81c30        5 months ago        79.62 MB
################################################################
Docker容器操作
●启动Docker
  & 启动含有前台程序的容器，如centos，ubantu，busybox
  docker run -it 镜像名:标签名  命令    #这是启动前台交互的
   #标签默认latest，命令不打就是默认命令，centos7就是bash，ubantu就是sh
  & 启动含有后台服务的容器，如nginx,redis
  docker run -itd 镜像名:标签名  命令    

●查看容器进程 docker ps
  [root@docker02 ~]# docker run -itd nginx
  13cfb3f87a321236441830e382913d3243d929568567686b47d3b368f2ce4a7c

  [root@docker02 ~]# docker ps
  CONTAINER ID        IMAGE               COMMAND                      CREATED             STATUS              PORTS               NAMES
  13cfb3f87a32        nginx               "nginx -g 'daemon off"   6 seconds ago       Up 3 seconds        80/tcp, 443/tcp     fervent_hoover

●查看已经关闭的容器进程 docker ps -a
  [root@docker02 ~]# docker ps -aq  #-q，值显示PID
be729e8d893f
e486becb1fea
ca9b3b5ab8f3

●开启关闭了的容器  docker start   #还有stop/restart
  [root@docker02 ~]# docker start be729e8d893f
  be729e8d893f

●删除容器 docker rm  #需要先stop
  [root@docker02 ~]# docker ps -aq  #查看已经关闭的容器，及PID
  13cfb3f87a32
  84a87ba6c4e0
  be729e8d893f
  38819afdff04
  202efb01793a
  3cc7b30366b0

  [root@docker02 ~]# docker rm `docker ps -aq`
  13cfb3f87a32
  84a87ba6c4e0
  be729e8d893f
  38819afdff04
  202efb01793a
  3cc7b30366b0
################################################################
● docker top
● 进入容器
  & 进入容器  #需要先启动容器，run
   – docker attach 进入容器,exit会导致容器关闭
   – docker exec 进入容器,退出时不会关闭容器
   
 & docker exec
  [root@docker02 ~]# docker exec -it 2fee bash
  [root@2fee07374c79 /]# pstree -p 0
  ?()-+-bash(1)
      `-bash(13)---pstree(44)               ` #开了一个子进程 
      
 & docker attach  
  [root@docker02 ~]# docker attach 2fee
  [root@2fee07374c79 /]# pstree -p 0
  ?()-+-bash(1)---pstree(47)                    #连接上帝进程 
      `-bash(13)                           `
















