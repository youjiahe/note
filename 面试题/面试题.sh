1.如何控制容器占用系统资源的份额？
docker run -tid –cpu-shares 100 centos:latest  #在创建容器时指定容器所使用的CPU份额值，权重值0
docker run -tid –cpu-period 100000 –cpu-quota 200000 centos #容器进程每1秒使用单个CPU的0.2秒时间

2.如何修改docker默认存储设置
  2.1 修改docker.service文件.
     vim /usr/lib/systemd/system/docker.service
  2.2 在里面的EXECStart的后面增加后如下:
      ExecStart=/usr/bin/dockerd --graph /home/docker  #先创建文件夹
  2.3 查看
     docker info | grep "\/home\/docker"
