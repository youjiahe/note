Python自动化运维 day02
1.变量
2.数据类型概述
3.判断语句
4.while循环

基础
变量、数据类型
运算符、语句
高级编程方式
框架/类库/模块
##############################################################################
●变量
  & 变量名约定：
     1.首字符为字母或下划线
     2.后续字符可以为数字、字母、下划线
     3.变量名区分大小写
     4.关键字不能作为变量
  & 注意事项：
    python中不能直接定义变量，需要先用等号赋值
##############################################################################
●数据类型
  & 数字
    int：有符号整数
         — 十进制
         — 二进制       0b10010
         — 八进制       0o177
         — 十六进制0-F 0xFFFF         
    bool：布尔值 
         — True
              — 数字类型只要非0就是True
         — False 
              — 空字符串、空列表、空元组、空字典为False
           — 0  0.0  0+0j  False  ''  []  {}  () 都是False          
    float：浮点数
        — 小数点
    complex：复数
  & 字符串
    — 用引号定义，引号之间
    — 单引与双引意义一样
    — 支持三引号，可以用来包含特殊字符;如换行“\n”
  & 列表
    — 理解成容器 可以存放任意类型的python对象
    — 使用[  ]表示列表，列表中的值用逗号分隔 
      >>> ['abdc',True,3.14,1+1j,[1,2,3]]
      ['abdc', True, 3.14, (1+1j),[1,2,3]]
    — 列表操作
        1.可以使用切片和索引操作列表
        2.支持索引赋值       
  & 元组
    — 用() 表示元组
    — 元组的内容不可变，其余与列表一样
  & 字典
    — 字典是由key-value对构成的有关系的数据类型
    — {}用户表示字典
    — 通过字典中的键进行索引
    — 如果对不存在的键赋值，相当于增加新的键值
    >>> dict={"class":"nsd1806"}
    >>> dict["class"]
   'nsd1806'
   >>> dict={"class":"python","name":"youjiahe"}
   >>> dict["name"]
   'youjiahe'
   >>> dict["class"]
   'python'
   >>> dict
   {'class': 'python', 'name': 'youjiahe'}
   
●数据类型比较
  按更新模型区分：
     可变：列表、字典
     不可变：数字、字符串、元组
##############################################################################

●字符串切片
  格式 [起始位置:结束位置]
  注意:不写":"跟结束位置，只取指定索引值的字符
  表示数据的位置从0开始
  开头结尾可以省略不写
  
>>> l="abcdefghijklmnopqrstuvwxyz"
>>> l[4]
'e'
>>> l[25]
'z'
>>> l[-1]
'z'
>>> l[2:5]  #起始下标包含，结束下标不包含
'cde'
>>> l[4:-1]
'efghijklmnopqrstuvwxy'

>>> l[:5]   #":"前不写，默认第一个字符
'abcde'
>>> l[4:]
'efghijklmnopqrstuvwxyz' #":"后不写，默认最后一个字符
>>> l[:]
'abcdefghijklmnopqrstuvwxyz'

str='python'
print(str[1::2])  #取出yhn 从下标1开始取到最后，步长为2
print(str[:])     #取全部

●字符串拼接
  用数字运算符+，拼接
  >>> str0="I"
  >>> str1="Linux"
  >>> strg=str0+str+str1
  >>> strg
  'I*Linux'

●生成重复字符串
  用数字运算符*，重复生成
  >>> str="*"
  >>> str*10
  '**********'

●字符串判断
  空 非空判断
  a is None
  b is not None

●列表操作
& 列表切片查找
  >>> list=['you','￥5000/month',True]
  >>> list
  ['you', '￥5000/month', True]
  >>> list[2]
  True
  >>> list[0]
  'you'
  >>> list[1]
  '￥5000/month'

& 列表嵌入列表
  >>> list=['you',[1,2,3],True]
  >>> list
  ['you', [1, 2, 3], True]
  >>> list[1]
   [  1, 2, 3]
  >>> list[1][2]
   2

& 列表索引赋值
  >>> list[2]=False
  >>> list
  ['you', [1, 2, 3], False]
  
&列表值存在判断
 使用 in 与 not in 是否在指定列表中
  >>> list=['you',2,3,True]
  >>> 2 in list
  True
  >>> "yoyo" in list
  False

● 字典操作
& 修改键值
  >>> info = {'name': 'you', 'age': 25, 'job': 'Devops'}
  >>> info["age"]=24
  >>> info
  {'name': 'you', 'age': 24, 'job': 'Devops'}
& 添加键值
  >>> info["salary"]=1000
  >>> info
  {'name': 'you', 'age': 24, 'job': 'Devops', 'salary': 1000}
&字典键存在判断
  >>> "name" in info
  True
  >>> "you" in info
  False

##############################################################################
运算
●算术运算
  + - * /  
  //         #取整
  %
  ** 
>>> 3//2
1
>>> 2**8
256
>>> 2.5*2   #注意，浮点数与整数运算，结果为浮点数
5.0

●比较运算符
  >  <  ==  >=   <=   !=
 & 字符串比较，按照首字符ASCII编码的值进行比较
  
 >>> "A">"a"
 False
 >>> "A">"!"
 True
 >>> "Z">"a"
 False
 >>> "Z">"X"
 True
 >>> "{">'a'
 True

●逻辑运算符
  and  or not 
  
  >>> True and True
  True
  >>> True and False
  False
  >>> True or True
  True
  >>> True or False
  True
  >>> False or False
  False
  >>> not True
  False
  >>> not False
  True

##############################################################################
python中的语句
 顺序语句
 判断语句
 循环语句
##############################################################################
●判断语句
& 结构
if 表达式：
    if_suit            #缩进4个空格
elif 表达式:
    elif_suit
else:
    else_suit

& 在pycharm中敲 
#!/usr/bin/env python3
if 'a'>"A":
    print('yes')
else:
    print('no')

& 特殊条件
  — 空字符串、空列表、空元组、空字典为False
  — 数字类型只要非0就是True
  — 0  0.0  0+0j  False  ''  []  {}  () 都是False
>>> if '':
...     print('yes')
... else:
...     print('no')
... 
no
##############################################################################
判断语句
●案例1:判断合法用户
1.  创建login2.py文件
2.  提示用户输入用户名和密码
3.  获得到相关信息后,将其保存在变量中
4.  如果用户输的用户名为youjiahe,密码为123456,则输
出Login successful,否则输出Login incorrect

#!/usr/bin/env python3
user =  input("请输入用户名:")
passwd = input(" 请输入密码:")
if user == "youjiahe" and passwd == "123456":
    print("Login sucessfully!")
else:
    print("Login incorrect!")
                           
##############################################################################
判断语句
●案例2:编写判断成绩的程序
•  创建grade.py脚本,根据用户输入的成绩分档,要求如下:
1.  如果成绩大于60分,输出“及格”
2.  如果成绩大于70分,输出“良”
3.  如果成绩大于80分,输出“好”
4.  如果成绩大于90分,输出“优秀”
5.  否则输出“你要努力了”

#!/usr/bin/env python3
#字符串转换为整数  int('str')
grade = int(input('请输入成绩:'))
if grade >= 90:
    print('优秀')
elif grade >=80:
    print('好')
elif grade >=70:
    print('良')
elif grade >=60:
    print('及格')
else:
    print('你要努力了')
    
##############################################################################
条件表达式 了解
>>> x=1
>>> y=10
>>> smaller = x if x<y else y
>>> smaller
1
##############################################################################
循环语句
while

&结构
while  表达式:
    while_suit
#当表达式的值为真，循环执行while_suit 
#当表达式的值为假，循环结束


&循环中断  #与shell一样
  break
  continue
& else  #了解
   当循环完全结束后可以执行else内的代码
   死循环中else语句永远不会执行
##############################################################################
循环语句
while

●案例3:输出1～20
#!/usr/bin/env python3
num = 1
while num<=20:
    print(num,end=' ')
    num += 1
print('')
##############################################################################
循环语句
while

●案例4:九九乘法表 
#!/usr/bin/env python3
start = 9
end = 9
i = 1
j = 1
while i<=start:
    while j<=i:
        if i*j<10:
            print(i,'×',j,'=',i*j,sep='',end='  ')
            j += 1
        else:
            print(i, '×', j, '=', i * j, sep='', end=' ')
            j += 1
    print('')
    i += 1
    j=1

1×1=1  
2×1=2  2×2=4  
3×1=3  3×2=6  3×3=9  
4×1=4  4×2=8  4×3=12 4×4=16 
5×1=5  5×2=10 5×3=15 5×4=20 5×5=25 
6×1=6  6×2=12 6×3=18 6×4=24 6×5=30 6×6=36 
7×1=7  7×2=14 7×3=21 7×4=28 7×5=35 7×6=42 7×7=49 
8×1=8  8×2=16 8×3=24 8×4=32 8×5=40 8×6=48 8×7=56 8×8=64 
9×1=9  9×2=18 9×3=27 9×4=36 9×5=45 9×6=54 9×7=63 9×8=72 9×9=81 
##############################################################################
循环语句
while
continue

●案例5：continue
#!/usr/bin/env pyhotn3
num = 0
while num<=20:
    num += 1
    if num%2==1:
        continue
    else:
        print(num,end=' ')
##############################################################################
循环语句  
while
else  #了解
●案例6：计算1~100所有数字之和
#!/usr/bin/env python3
num = 1
sum = 0
while num<=100:
    sum += num
    num += 1
else:
    print(sum)
##############################################################################
循环语句
while
●案例7：猜数模块
#!/usr/bin/env python3
#导入随机数模块
#int()把字符串转为整数
import random
num=random.randint(1, 100)
count=1
while count<=5:
    guest=int(input('请输入一个数[1-100]：'))
    if guest==num:
        print('恭喜你猜对了,答案就是',num,sep='')
        break
    elif guest>num:
        print('猜大了',end=' ')
        print('还剩下',5-count,'次机会')
    elif guest<num:
        print('猜小了',end=' ')
        print('还剩下',5-count,'次机会')
    count += 1
else:
    print('你妹阿,五次机会都猜不对，可以回家了')
    print('彩票号码是',num)

##############################################################################
●作业：剪刀石头布游戏
#!/usr/bin/env python3
import random
quan = ['剪刀', '石头', '布']
com_win=[['剪刀','布'],['石头','剪刀'],['布','石头']]
you_win=[['剪刀','石头'],['石头','布'],['布','剪刀']]
c=0
y=0
you=-1
while c<2 and y<2:
#    comput = random.randint(0, 2)  #不使用索引取值
    while you not in [0,1,2]:
         you = input("请出拳[0：剪刀;1：石头;2：布]")
         if you not in ['0','1','2']:
             continue
         else:
             you=int(you)
    com_chu = random.choice(quan)   #在列表中随即选中
#    com_chu = random.randint[comput]
    you_chu = quan[you]
    zhan_ju = [com_chu, you_chu]

    if zhan_ju in com_win:
        c += 1
        print('总比分',c,':',y)
        print('电脑','你',sep='  ')
        print(com_chu,you_chu,sep='  ')
    elif zhan_ju in you_win:
        y += 1
        print('总比分',c,':',y)
        print('电脑','你',sep='  ')
        print(com_chu,you_chu,sep='  ')
    else:
        print('平局')
    you=-1

if c==2:
    print('-------------------------------')
    print('电脑硬了')
    print('总比分', c, ':', y)
    print('-------------------------------')
elif y==2:
    print('-------------------------------')
    print('你硬了')
    print('总比分', c, ':', y)
    print('-------------------------------')

请出拳[0：剪刀;1：石头;2：布]3   #只识别0，1，2
请出拳[0：剪刀;1：石头;2：布]a 
请出拳[0：剪刀;1：石头;2：布]2
总比分 0 : 1
电脑  你
石头  布
请出拳[0：剪刀;1：石头;2：布]egt
请出拳[0：剪刀;1：石头;2：布](
请出拳[0：剪刀;1：石头;2：布]1
平局
请出拳[0：剪刀;1：石头;2：布]0
总比分 1 : 1
电脑  你
石头  剪刀
请出拳[0：剪刀;1：石头;2：布]a2
请出拳[0：剪刀;1：石头;2：布]2
总比分 1 : 2
电脑  你
石头  布
-------------------------------
你硬了
总比分 1 : 2
-------------------------------























