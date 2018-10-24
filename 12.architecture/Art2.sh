大型架构及配置技术
NSD ARCHITECTURE  DAY02

1.playbook基础
  1.1 基础知识
    1.1.1 ansible七种武器
    1.1.2 JSON简介
    1.1.3 YAML介绍
    1.1.4 Jinja2模版简介
 1.2 playbook
    1.2.1 playbook介绍
    1.2.2 playbook语法基础
2.playbook进阶
     
##################################################################################
1.playbook基础
●基础知识
ansible七种武器  (一、二、五必须掌握)
• 第一种武器
  – ansible 命令,用于执行临时性的工作,必须掌握
• 第二种武器
  – ansible-doc是ansible模块的文档说明,针对每个模
     块都有详细的说明及应用案例介绍,功能和Linux系统
    man命令类似,必须掌握
• 第三种武器
  – ansible-console是ansible为用户提供的交互式工具,
     用户可以在ansible-console虚拟出来的终端上像Shell
     一样使用ansible内置的各种命令,这为习惯使用Shell
     交互方式的用户提供了良好的使用体验
• 第四种武器
  – ansible-galaxy从github上下载管理Roles的一款工具,
     与python的pip类似
• 第五种武器
  – ansible-playbook是日常应用中使用频率最高的命令,工
     作机制:通过读预先编写好的playbook文件实现批量管理,
     可以理解为按一定条件组成的ansible任务集,必须掌握
• 第六种武器
  – ansible-vault主要用于配置文件加密,如编写的playbook
     文件中包含敏感信息,不想其他人随意查看,可用它加密/
     解密这个文件
• 第七种武器
   – ansible-pull
   – ansible有两种工作模式pull/push ,默认使用push模
       式工作,pull和push工作模式机制刚好相反
   – 适用场景:有大批量机器需要配置,即便使用高幵収
       线程依旧要花费很多时间
   – 通常在配置大批量机器(2000台)的场景下使用,灵活性稍有欠
      缺,但效率几乎可以无限提升,对运维人员的技术水
      平和前瞻性规划有较高要求
##################################################################################
1.2 JSON简介
● json 是什么?
   — JavaScript Object Notation
   – json 是 JavaScript 对象表示法,它是一种基于文本,
       独立于语言的轻量级数据交换格式。
   – JSON中的分隔符限于单引号 ' 、小括号 ()、中括号
      [ ]、大括号 { } 、冒号 : 和逗号 , '
            
● json 特性
   – JSON 是纯文本
   – JSON 具有"自我描述性"(人类可读)
   – JSON 具有层级结构(值中存在值)
   – JSON 可通过 JavaScript 进行解析
● json 语法规则
   – 数据在键值对中
   – 数据由逗号分隔
   – 大括号保存对象  
   – 中括号保存数组
● JSON对象   
   — 在 JS 语言中，一切都是对象。
   — 因此，任何支持的类型都可以通过 JSON 来表示
   — 例如字符串、数字、对象、数组等
   — 对象和数组是比较特殊且常用的两种类型。 
   
● json 数据的书写格式是:名称/值对。
   – 名称/值对包括字段名称(在双引号中),后面写一个
   冒号,然后是值,例如:
   "漂亮姐" : "庞丽静"

• json 语法规则之数组
  { "讲师"：
     ["牛犇", "丁丁", "静静", "李欣"]
  }
  
• 复合复杂类型
 { "讲师":
    [ 
     {"牛犇":"小逗逼", "负责阶段":"1"},
     {"丁丁":"老逗逼", "负责阶段":"2"},
     {"静静":"漂亮姐", "负责阶段":"3"},
     {"李欣":"老司机", "负责阶段":"4"}     
    ],
    "课程":"云计算全栈工程师培训班"
 }  
  
##################################################################################     
1.3 yaml简介

● yaml 是什么  
  – 是一个可读性高,用来表达数据序列的格式。
  – YAML:YAML Ain't Markup Language           '
  – YAML参考了其他多种语言,包括:C语言、Python、   #了解
    Perl,幵从XML、电子邮件的数据格式(RFC 2822)
     中获得灵感。Clark Evans在2001年首次发表了这种语
     言[1],另外Ingy döt Net不Oren Ben-Kiki也是这语
     言的共同设计者[2]。目前已经有数种编程语言或脚本
     语言支持(或者说解析)这种语言。     
● yaml 基础语法
  – YAML的结构通过空格来展示
  – 数组使用"- "来表示
  – 键值对使用": "来表示
  – YAML使用一个固定的缩进风格表示数据层级结构关系
  – 一般每个缩进级别由两个以上空格组成
  – # 表示注释
● 注意:
   – 不要使用tab,缩进是初学者容易出错的地方之一
   – 同一层级缩进必须对齐

● YAML的键值表示方法
   – 采用冒号分隔
   – : 后面必须有一个空格
  – YAML键值对例子
     "庞丽静": "漂亮姐"
   – 或
  "庞丽静":
    "漂亮姐"  #两个空格
    
● YAML 数组表示方法
 – 使用一个短横杠加一个空格
 – YAML数组例子
   - "李白"   # 符号 "-" 后面有一个空格
   - "杜甫"
   - "白居易"
   - "李贺"        
  //相当于json的 ["李白", "杜甫", "白居易", "李贺"]
  
– 哈希数组复合表达式
   "诗人":
     - "李白"   #缩进两个空格
     - "杜甫"
     - "白居易"
     - "李贺"
  //相当于json的 {"诗人":["李白", "杜甫", "白居易", "李贺"]}

– 高级复合表达式
   "诗人":
     -
       "李白": "诗仙"  # 符号 "-" 后面有一个空格,后面内容缩进
       "年代": "唐"
     -
       "杜甫": "诗圣"
       "年代": "唐"
     -
       "白居易": "诗魔"   
       "年代": "唐"
     -
       "李贺": "诗鬼"
       "年代": "唐"
       
//相当于json的       
 { "讲师":
    [ 
     {"牛犇":"小逗逼", "负责阶段":"1"},
     {"丁丁":"老逗逼", "负责阶段":"2"},
     {"静静":"漂亮姐", "负责阶段":"3"},
     {"李欣":"老司机", "负责阶段":"4"}     
    ],
    "课程":"云计算全栈工程师培训班"
 }    
##################################################################################
1.4 Jinja2模版简介
● Jinja2是什么
   – Jinja2是基于Python的模板引擎,包含发量和表达式
       两部分,两者在模板求值时会被替换为值,模板中还
       有标签,控制模板的逻辑
● 为什么要学习Jinja2模版
   – 因为playbook的模板使用Python的Jinja2模块来处理
   
● jinja2 模版基本语法
   – 模板的表达式都是包含在分隔符 "{{   }}" 内的;
   – 控制语句都是包含在分隔符 "{% %}" 内的;
   – 另外,模板也支持注释,都是包含在分隔符 "{# #}"内,支持块注释。
   – 调用变量 {{varname}}
   – 计算
      {{2+3}}
   – 判断
     {{1 in [1,2,3]}}

● jinja2 模版控制语句      #if
   {% if name == '小逗逼' %} 
        讲故事,吹牛B
   {% elif name == '老逗逼' %}
        黑丝
   {% elif name == '漂亮姐' %}
        约会
   {% else %}
        沉迷学习,无法自拔
   {% endif %}
   
● jinja2 模版控制语句
   {% if name == ... ... %}
       ... ...
   {% elif name == '漂亮姐' %}
   {% for method in [约会, 逛街, 吃饭, 看电影, 去宾馆] %}
   {{do method}}
   {% endfor %}
       ... ...
   {% endif %}

● jinja2 过滤器
   – 变量可以通过 过滤器 修改。过滤器不变量用管道符号
      ( | )分割,幵且也 可以用圆括号传递可选参数。多
      个过滤器可以链式调用,前一个过滤器的输出会被作为 
      后一个过滤器的输入。
      
   – 例如:
   – 把一个列表用逗号连接起来: {{ list|join(', ') }}
   – 过滤器这里不一一列举,需要的可以查询在线文档
  http://docs.jinkan.org/docs/jinja2/templates.html
  #builtin-filters
##################################################################################
playbook

● playbook 是什么?
  – playbook是ansible用于配置,部署和管理托管主机剧本,
     通过playbook的详绅描述,执行其中的一系列tasks,可
     以让进端主机达到预期状态
  – 也可以说,playbook字面意思即剧本,现实中由演员按
     剧本表演,在ansible中由计算机进行安装,部署应用,
     提供对外服务,以及组织计算机处理各种各样的事情

● 为什么要使用playbook
– 执行一些简单的任务,使用ad-hoc命令可以方便的解决问
   题,但有时一个设施过于复杂时,执行ad-hoc命令是不合
   适的,最好使用playbook
– playbook可以反复使用编写的代码,可以放到不同的机器
   上面,像函数一样,最大化的利用代码,在使用ansible的
   过程中,处理的大部分操作都是在编写playbook
##################################################################################
playbook语法基础
● playbook语法格式
   – playbook由YAML语言编写,遵循YAML标准
    – 在同一行中,#之后的内容表示注释
    – 同一个列表中的元素应该保持相同的缩迚
• playbook构成
   – Target: 定义将要执行playbook的进程主机组
   – Variable: 定义playbook运行时需要使用的发量
   – Tasks: 定义将要在进程主机上执行的任务列表   #ansible的模块
   – Handler: 定义task执行完成以后需要调用的任务    
   
● playbook执行结果
  使用ansible-playbook运行playbook文件,输出内容
   为JSON格式,由不同颜色组成便于识别
   – 绿色代表执行成功
   – ***代表系统代表系统状态収生改发
   – 红色代表执行失败
##################################################################################
● 第一个playbook
[root@ansible ~]# cat ping_shell.yml
---        # 第一行,表示开始
-
  hosts: all
  remote_user: root
  tasks: 
    - ping:
##################################################################################
● playbook创建用户
---
- hosts: all
  remote_user: root
  tasks:
    - name: create user plj   #name代表注释
      user: group=wheel uid=1000 name=plj
    - shell: echo 123456 | passwd --stdin plj
    - shell: chage -d 0 plj
##################################################################################
playbook综合练习  
1. 安装Apache并修改监听端口为8080
2. 修改ServerName配置,执行apachectl -t命令丌报错
3. 设置默认主页hello world
4. 启动服务并设开机自起
#以下每个模块都用ansible-doc查找  
[root@ansible ~]# vim httpd.yml
---
- 
  hosts: web
  remote_user: root
  tasks:
    - name: install httpd 
      yum:
        name: httpd
        state: present
    - lineinfile:
        path: /etc/httpd/conf/httpd.conf
        regexp: '^Listen'
        line: 'Listen 8080'
    - replace:
        path: /etc/httpd/conf/httpd.conf
        regexp: '^#ServerName'
        replace: 'ServerName'
    - shell: echo 'hello world' > /var/www/html/index.html
      args:
        executable: /bin/bash
    - service:
        name: httpd
        state: restarted
        enabled: yes
        
[root@ansible ~]# ansible-playbook httpd.yml -f 2   #-f 2 表示开两个进程并发执行      
##################################################################################
playbook进阶
● 变量
  error
  handlers
  when
  register
  with_items
  with_nested
  tags
  include and roles
● 调试
  debug































