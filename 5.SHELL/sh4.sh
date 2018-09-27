 ##############################################
中断
continue
--跳过本次循环，继续下一次循环

break 
--直接结束循环

return
执行完后返回一个值

 #############################################
字符串截取
统计字符串长度
    ${#变量}  #统计变量字符长度
[root@pc207 shell_100]# phone=13676240551
[root@pc207 shell_100]# echo ${#phone}
11                                              #包含11个字符

字符串截取
1）方法一（推荐）： echo ${}    
   格式：echo ${变量:起始位置:截取长度}      #从0数起
         [root@pc207 shell_100]# phone=13676240551
         [root@pc207 shell_100]# echo ${phone:7:4}
         0551

2）方法二：expr substr
   格式：expr substr $变量 起始位置 长度      #从1数起
         [root@pc207 shell_100]# expr substr $phone 8  4
         0551

3）方法三：使用cut分割工具                  #从1数起
   格式1：echo $变量 | cut -b 起始位置-结束位置          #连续截取
   格式2：echo $变量 | cut -b 位置编号1，位置编号2     #指定截取
       [root@pc207 shell_100]# echo $phone | cut -b 8-11
           0551                                #截取8-11位
       [root@pc207 shell_100]# echo $phone | cut -b 8,11
           01                                  #截取8位和11位

 ############################################
字符串替换
格式 ：echo ${phone/被替换内容/替换后内容}   #替换一个
           echo ${phone//被替换内容/替换后内容}   #替换所有  ,有 //

  [root@shell shell_100]# echo ${phone//13676/*}
  *240551
  [root@shell shell_100]# echo ${phone//13676/*****}
  *****240551

 ############################################
字符串匹配删除
#：从左往右删除
%：从右往左删除

# A=`head -1 /etc/passwd`
# echo $A
root:x:0:0:root:/root:/bin/bash

echo ${A#删除内容}  #从左往右删除“删除内容”，一次
不影响原来的值
# echo ${A#root}                     # 一个“#”号删除一次
:x:0:0:root:/root:/bin/bash
# echo ${A#*:}
x:0:0:root:/root:/bin/bash
# echo ${A##*:}                      # 两个“#”号删除所有
/bin/bash

echo ${A%删除内容}  #从右往左删除“删除内容”，一次
[root@shell shell_100]# echo ${A%:*}
root:x:0:0:root:/root
[root@shell shell_100]# echo ${A%%:*}
root

 ##############################################
字符串初始值设置
格式：echo ${NB:-123} 
#[如果变量NB有值，则显示NB的值；如果NB没有值则显示123]

 ##########################################
数组
数组也是一个变量，一个变量可以春多个值
[root@shell shell_100]# x=(1 2 3 4 5)
[root@shell shell_100]# echo ${x[0]}
1
[root@shell shell_100]# echo ${x[5]}

[root@shell shell_100]# echo ${x[4]}
5
[root@shell shell_100]# echo ${x[*]}
1 2 3 4 5

统计数组长度
[root@svr7 ~]# echo ${#x[*]}
5

 ############################################
EOF
可以在脚本下写邮件
#！/bin/bash
mail -s error root << EOF[可变，可是行业规定EOF]
xxx
yyy
zzz       #xxxx  yyyy  zzzz 为邮件内容
EOF   #EOF前不能有空格
 ############################################
expect预期交互
1)装包expect
2)写脚本
exp() {
ping -c2 -i0.1 -W1 $1 &>/dev/null
if [ $? -eq 0 ]; then
   expect << EOF
spawn ssh -o StrictHostKeyChecking=no $1
expect "password" {send "123456\n"}
expect "#"        {send "echo 'aheiufrhywiuet' >> /a.txt\n"}  #\n \r 换行
expect "#"        {send "exit\r"}
EOF
fi
}
 ############################################
正则表达式
正则表达式伴随着整个职业生涯

例子：
^：grep “^a”   /a.txt         #显示以“a”开头的行
[]：grep “[act]”  /a.txt        #显示包含a 或者c 或者t 的行
[^]：grep “[^abc]tt” /a.txt      #不显示包含att btt ctt 的行
. ：grep “a.” /a.txt            #显示包含1个a的，且后面必须有内容的行
*：grep “bbbba*” /a.txt   #显示包含“bbbb”，且包含任意个”a”的行，0个也可以
\{n,m\}：grep “a\{3,5\}” /a.txt  #显示包含3-5个”a”，或者5个以上的行，可不会显示红色
\{n,\}：grep “a\{3,\}” /a.txt      #显示包含3个”a”以上的行
\{n\}：grep “a\{3\}” /a.txt        #显示包含3个”a”的行

从 ftp 下载 regular_express.txt:
过滤下载文件中包含 the 关键字
[root@shell ~]# grep the regular_express.txt
过滤下载文件中丌包含 the 关键字
[root@shell ~]# grep -v the regular_express.txt
过滤下载文件中丌论大小写 the 关键字
[root@shell ~]# grep -i the regular_express.txt 
过滤 test 或 taste 这两个单字
[root@shell ~]# grep "test\|taste"  regular_express.txt
[root@shell ~]# grep "t[ae]st" regular_express.txt
过滤有 oo 的字节
[root@shell ~]# grep "oo." regular_express.txt
过滤丌想要 oo 前面有 g 的
 [root@shell ~]#grep "[^g]oo." regular_express.txt
过滤 oo 前面丌想有小写字节
[root@shell ~]#grep "[^a-z]oo" regular_express.txt
过滤有数字的那一行
[root@shell ~]#grep "[0-9]" regular_express.txt
过滤以 the 开头的
[root@shell ~]#grep "^the" regular_express.txt
过滤以小写字母开头的
[root@shell ~]#grep "^[a-z]" regular_express.txt
过滤开头丌是英文字母
[root@shell ~]# grep "^[^a-z,A-Z]" regular_express.txt
过滤行尾结束为小数点.那一行
[root@shell ~]# grep “\.$” regular_express.txt
过滤空白行
[root@shell ~]# grep -v ^$ regular_express.txt
过滤出 g??d 的字串
[root@shell ~]# grep "g..d" regular_express.txt
过滤至少两个 o 以上的字串
[root@shell ~]# grep "o\{2,\}" regular_express.txt
过滤 g 开头和 g 结尾但是两个 g 之间仅存在至少一个 o
[root@shell ~]# grep "[g]oo*[g]" regular_express.txt
过滤任意数字的行
[root@shell ~]# grep "[0-9]" regular_express.txt
过滤两个 o 的字串
[root@shell ~]# grep "oo" regular_express.txt
过滤 g 后面接 2 到 5 个 o,然后在接一个 g 的字串
[root@shell ~]# grep "[g]o\{2,5\}[g]" regular_express.txt
过滤 g 后面接 2 个以上 o 的
[root@shell ~]# grep "[g]o\{2,\}" regular_express.txt
