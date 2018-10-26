100.使用 awk 编写的 wc 程序
#知识点  length()统计每行字符数
[root@client ~]# awk "END{print length()}" test.txt
  26
[root@client ~]# cat test.txt
abcdefghijklmnopqrstuvwxyz

答案：
awk '{lines=NR;f+=NF;chars+=length()}END{print lines,f,chars+NR}' test.txt 
4 10 29
