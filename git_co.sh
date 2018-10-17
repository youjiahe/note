#!/bin/bash
read -p "修改笔记/最新笔记[1]:" $n
[ $n -eq 1 ]  && h="最新笔记" || h="修改笔记"
cd /root/git/note
git add --all
git commit -m "$h_`date +%F_%R`"
git push origin master
