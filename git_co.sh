#!/bin/bash
eval $(ssh-agent -s)
ssh-add /root/.ssh/github/id_rsa
for i in  /root/git/{sh,note,python} 
do
   cd $i
   git pull origin master
   git add --all
   git commit -m "update_`date +%F_%R`"
   git push origin master
done
