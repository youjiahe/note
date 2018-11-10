##############################################################################
字符串：
str='python'
print(str[1::2])  #取出yhn 从下标1开始取到最后，步长为2
print(str[:])     #取全部
##############################################################################
列表
alist=[10,20,30,'bob','alice',[1,2,3]]
alist[-1].append(4)
alist[-1].append(5)
alist[-1].append(6)
print(alist[-1])
print(11 not in alist)
print(alist[-1][2])
alist[-1].pop(-1)
print(alist[-1])

输出结果:
[1, 2, 3, 4, 5, 6]
True
3
[1, 2, 3, 4, 5]
##############################################################################a=20
条件表达式

a=20
b=30
s= a if a<b else b
print(s)

20
##############################################################################
猜数游戏：
做了一个是否为数字的函数

from random import randint
from string import digits 
def intp(st):
    stat=0
    if st != '':
        for i in st:
            if i not in digits:
                stat=1
                break
            else:
                stat=0
    else:
        stat=2
    return stat

num=randint(1,100)
an=''
for i in range(5):
    while intp(an)!=0:
        an = input('请输入一个数字:')
    if intp(an)==0:
        anwser=int(an)
    if anwser==num:
        print('恭喜您喜提1分钱红包，2分钱流量券')
        break
    elif anwser>num:
        print('猜大了')
    else:
        print('猜小了')
    an=''
else:
    print('五次机会用完，回去等通知')



























