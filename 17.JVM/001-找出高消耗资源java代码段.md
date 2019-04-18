### ●jstack
- 使用命令 jstack
jstack主要用来查看某个Java进程内的线程堆栈信息。语法格式如下：
```bash
jstack [option] pid
jstack [option] executable core
jstack [option] [server-id@]remote-hostname-or-ip
```
- 命令行参数选项说明如下：

  - -l long listings，会打印出额外的锁信息，在发生死锁时可以用jstack -l pid来观察锁持有情况 
  - -m mixed mode，不仅会输出Java堆栈信息，还会输出C/C++堆栈信息（比如Native方法）
 
>jstack可以定位到线程堆栈，根据堆栈信息我们可以定位到具体代码，所以它在JVM性能调优中使用得非常多。下面我们来一个实例找出某个Java进程中最耗费CPU的Java线程并定位堆栈信息，用到的命令有ps、top、printf、jstack、grep。

### ●查找高消耗CPU的代码
- 找到java进程号
```bash
[ekp@ekp227 ~]$ top
```
![top-java](https://github.com/youjiahe/note/blob/master/17.JVM/picture/top-java.jpg)
- 根据进程号查找高消耗的线程
```bash
[ekp@ekp227 ~]$ top -Hp 4000        #选项 -H 是查看进程下的线程
[ekp@ekp227 ~]$ printf "%x\n" 4378  #10进制-16进制转换
111a
```
![top-Hp](https://github.com/youjiahe/note/blob/master/17.JVM/picture/top-Hp-java.jpg)
- 找到高消耗CPU的线程PID，再找出堆栈代码
```bash
[ekp@ekp227 ~]$ jstack 4000 | grep 111a
"ekp_cluster_thread-pool-4-thread-5" prio=10 tid=0x00007fa5a4081000 nid=0x111a waiting on condition [0x00007fa5700f1000]
```

- 找出高消耗内存的线程亦然
