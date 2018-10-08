#!/bin/bash
expect <<EOF

expect "#"  {send PS1='[\033[41;30m\u\033[0m@\033[45;30m\h \033[37m\w\033[0m]\033[36m\$\033[0m'}
EOF
