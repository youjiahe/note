深复制和浅复制 
1.copy.copy,仅仅复制父对象 
2.copy.deepcopy，复制父对象和子对象

import copy
list1=[1,2,['a','b']]
list2=list1
list3=copy.copy(list1)
list4=copy.deepcopy(list1)
list1.append(3)
list1[2].append('c')
print(list1,'\n',list2,'\n',list3,'\n',list4)
# [1, 2, ['a', 'b', 'c'], 3] 
# [1, 2, ['a', 'b', 'c'], 3]   #赋值，全跟着父变量变
# [1, 2, ['a', 'b', 'c']]      #浅拷贝，不可变对象不跟着父变量变，可变对象(子列表)跟着变
# [1, 2, ['a', 'b']]           #深拷贝，全部都不跟着父变量变
--------------------- 
作者：29DCH 
来源：CSDN 
原文：https://blog.csdn.net/cowboysobusy/article/details/80472524 
版权声明：本文为博主原创文章，转载请附上博文链接！
