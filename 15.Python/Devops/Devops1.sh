运维开发实战
NSD DEVOPS DAY01
1.多进程编程
2.多线程编程
##############################################################################	
什么是forking
●fork(分岔)在Linux系统中使用非常广泛
•  当某一命令执行时,父进程(当前进程)fork出一个子进程
•  父进程将自身资源拷贝一份,命令在子进程中运行时,
	就具有和父进程完全一样的运行环境

	#!/usr/bin/env python3
	import os
	print('hello')
	os.fork()
	print('哈哈哈哈')
   [root@room9pc01 day1]# python3 fork_.py 
	hello
	哈哈哈哈    #父进程把剩下代码拷贝一份，放到子进程运行
	哈哈哈哈    #在父进程也运行一遍

	#!/usr/bin/env python3
	import os
	print('hello')
	pid=os.fork()
	if pid:
		print('父进程 ......')
	else:
		print('子进程......')
	print('又来了')
	[root@room9pc01 day1]# python3 fork_2.py 
	hello
	父进程 ......   #在父进程执行，因为父进程pid非0
	又来了           #父进程执行
	子进程......    #子进程执行，fork()后面的程序，拷贝到子进程执行，pid为空
	又来了           #子进程执行
##############################################################################
●fork编程思路
1.一定要明确父子进程的分工
2、一般来说，父进程只用来生成子进程；子进程做具体的工作
3、子进程做完工作后，结束并退出！！！
##############################################################################
进程的生命周期
•  父进程fork出子进程并挂起
•  子进程运行完毕后,释放大部分资源并通知父进程,
这个时候,子进程被称作僵尸进程
•  父进程获知子进程结束,子进程所有资源释放
##############################################################################
●僵尸进程(zombie)
  — 在子进程终止和父进程调用wait()之间的这段时间,子进程被称为zombie(僵尸)进程
  — 如果子进程还没有终止,父进程先退出了,那么子进
	程会持续工作。系统自动将子进程的父进程设置为
	init进程,init将来负责清理僵尸进程
	
●使用轮询解决zombie问题
  — 父进程通过os.wait()来得到子进程是否终止的信息  
  — python可以使用waitpid()来处理子进程
    •  waitpid()接受两个参数,
    	第一个参数设置为-1,表示与wait()函数相同;
    	第二参数如果设置为0表示挂起父进程,直到子程序退出,设置为1表示不挂起父进程
    	
    •  waitpid()的返回值:如果子进程尚未结束则返回0,否则返回子进程的PID 
          
    •   一个waitpid()处理一个zombie进程
##############################################################################
●案例3:利用fork创建TCP服务器
•  编写TCP服务器
1.  服务器监听在0.0.0.0的21567端口上
2.  收到客户端数据后,将其加上时间戳后回送给客户端
3.  如果客户端发过来的字符全是空白字符,则终止与客
户端的连接
4.  服务器能够同时处理多个客户端的请求
5.  程序通过forking来实现


#父进程打开socket，接收客户端连接
#父进程生成子进程
#子进程关闭服务器套接字，负责与客户机通信
#

#!/usr/bin/env python3
import time
import socket
import os
class TcpSer:
    def __init__(self,host='',port=12345):
        self.addr=(host,port)
        self.serv=socket.socket()
        self.serv.setsockopt(socket.SOL_SOCKET,socket.SO_REUSEADDR,1)
        self.serv.bind(self.addr)
        self.serv.listen(1)
    def chat(self,client_sock):
        while True:
            data=client_sock.recv(1024).decode()
            if data.strip()=='quit':
                break
            data='[%s] %s'  % (time.strftime('%R'),data)
            try:
                client_sock.send(data.encode())
            except BrokenPipeError:
                break

    def mainloop(self):
        while True:
            try :
                client_sock,client_addr=self.serv.accept()
            except KeyboardInterrupt:
                print()
                break
            pid=os.fork()
            if pid:
                client_sock.close()
                while True:
                    result = os.waitpid(-1, 1)
                    print(result)
                    if result[0]==0:
                        break
            else:
                self.chat(client_sock)
                client_sock.close()
                exit()

        self.serv.close()

if __name__ == '__main__':
    s=TcpSer()
    s.mainloop()
##############################################################################
多线程编程
●class写法	
    th = threading.Thread(target=Ping(ip))
    th.start()
●def写法
    th=threading.Thread(target=ping,args=(ip,))
    th.start()  #相当于  target(args) => ping(ip)
    
●例子:
	import subprocess
	import os
	import time
	import threading
	n=0
	class Ping:
		def __init__(self,ip):
		    self.ip=ip

		def __call__(self):
		    rc=subprocess.call('ping -i0.1 -c2 -W1 %s &>/dev/null' % self.ip,shell=True)
		    if rc==0:
		        print("{:.<20}\033[32;1m[up]\033[0m".format(self.ip))

	if __name__ == '__main__':
		ips = ["139.159.193.%s" % i for i in range(1, 255)]
		start=time.time()
		for ip in ips:
		    th = threading.Thread(target=Ping(ip))
		    th.start()
		end=time.time()
		print(end-start)

##############################################################################
GIL  全局解释器锁，某一时间，只能由一个线程交给python解释器，解释器把代码交给CPU
##############################################################################
多线程，多进程编程如何选择
1.程序分类
  计算密集型(CPU密集型)应用： 多进程可以提升效率、多线程不能提升
  IO密集型应用：  采用多进程、多线程提升效率
  













































