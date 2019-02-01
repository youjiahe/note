#############################字符串#################################################
1.字符串--正则匹配替换
   def _sub_quote(pattern):
       substr = pattern.group("string")
       substr = substr.replace("'", "")
       return substr
   insertIntoText = re.sub("(?P<string>'clob_blob[0-9]+')",_sub_quote,insertIntoText)
   //功能实现：替换掉目标对象中的单引号；如 'clob_blob78' 替换为 clob_blob78
   
#############################多线程#################################################
1.限制线程数
    tables=['EKP_OA_PL_RISKLOG',
    'KM_IMISSIVE_EVALUATION',
    'SYS_XFORM_MAIN_DATA_CUSLIST',
    'THIRD_NX_TODO']
    i=0
    for src_table in tables:
        src_table="".join(src_table)
        th = threading.Thread(target=mysql2oraclectl,args=(target_Oracle_dbConfig,src_Mysql_dbConfig1,src_table,'single')
        th.start()
        if i%100==0:
            while threading.enumerate(): 
                if len(threading.enumerate()) <= 6:  #当前剩余线程数少于6时，开启下一批并发
                    break
                sleep(0.1)
        i += 1
     //功能实现：限制并发线程数为 100；
