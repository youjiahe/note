cd /tale/demo && bash install.sh

docker run -itd \
-v /apps/tale/:/tale \
-v /usr/lib/jvm:/usr/lib/jvm \ 
-v /usr/lib/jvm-exports/:/usr/lib/jvm-exports/ \
-v /usr/share/applications/:/usr/share/applications/ \
-v /usr/share/doc/java-1.8.0-openjdk-devel-1.8.0.131:/usr/share/doc/java-1.8.0-openjdk-devel-1.8.0.131 \
-v /usr/share/man/man1/:/usr/share/man/man1/ \
-v /usr/share/systemtap:/usr/share/systemtap \
-v /usr/share/javazi-1.8/:/usr/share/javazi-1.8/  \
-p 9000:9000 0a5
