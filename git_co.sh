#!/bin/bash
eval $(ssh-agent -s)
ssh-add /root/.ssh/github/id_rsa
cd /root/git/note
git add --all
git commit -m "$h_`date +%F_%R`"
git push origin master
cd /root/git/sh
git add --all
git commit -m "$h_`date +%F_%R`"
git push origin master
cd /root/git/python
git add --all
git commit -m "$h_`date +%F_%R`"
git push origin master
