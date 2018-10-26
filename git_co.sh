#!/bin/bash
cd /root/git/note
git pull
git add --all
git commit -m "$h_`date +%F_%R`"
git push origin master
