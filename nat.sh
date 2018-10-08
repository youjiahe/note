for i in mangle security raw nat filter;do
     iptables -t ${i} -F
     iptables -t ${i} -X
     rmmod iptable_${i}
done
sysctl -w net.ipv4.ip_forward=1
ETH=$(ip route show|awk '{if($1=="default" && $2=="via")print $5}')
iptables -t nat -A POSTROUTING -s 192.168.0.0/16 -o ${ETH} -j MASQUERADE
