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
################################################################  
Docker镜像操作   
●查看镜像
  [root@docker01 ~]# docker images

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
################################################################   
●导入、导出镜像
  & 主机docker01 导出镜像
  [root@docker01 ~]# docker save docker >  docker.tar
  [root@docker01 ~]# scp docker.tar docker02:/root
  & 主机docker02 导入镜像
  [root@docker02 ~]# docker load < docker.tar
################################################################
●导入老师的docker镜像，  
  [root@docker01 ~]# unzip docker_images.zip 
  [root@docker01 ~]# cd docker_images/
  [root@docker01 docker_images]# for i in `ls`; do docker load < $i; done
  [root@docker01 ~]# docker images





























