#!/bin/bash


# 定义环境变量
proxy_port=7892                  #clash 代理端口
dns_port=1053                    #clash dns监听端口

# 清除 iptables 规则
iptables -F
iptables -t nat -F
iptables -t mangle -F
iptables -X

# 启用 IP 转发
sysctl -w net.ipv4.ip_forward=1
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf


# 启用tun
mkdir -p /dev/net
mknod /dev/net/tun c 10 200
chmod 600 /dev/net/tun


# 配置tcp透明代理
## 在nat表中新建clash规则链
iptables -t nat -N clash
## 排除环形地址与保留地址
iptables -t nat -A clash -d 0.0.0.0/8 -j RETURN
iptables -t nat -A clash -d 10.0.0.0/8 -j RETURN
iptables -t nat -A clash -d 127.0.0.0/8 -j RETURN
iptables -t nat -A clash -d 169.254.0.0/16 -j RETURN
iptables -t nat -A clash -d 172.16.0.0/12 -j RETURN
iptables -t nat -A clash -d 192.168.0.0/16 -j RETURN
iptables -t nat -A clash -d 224.0.0.0/4 -j RETURN
iptables -t nat -A clash -d 240.0.0.0/4 -j RETURN
## 重定向tcp流量到clash 代理端口
iptables -t nat -A clash -p tcp -j REDIRECT --to-port "$proxy_port"
## 拦截外部tcp数据并交给clash规则链处理
iptables -t nat -A PREROUTING -p tcp -j clash

# dns 相关配置
iptables -t nat -I PREROUTING -p udp --dport 53 -j REDIRECT --to-port 1053

# 保存 iptables 规则
iptables-save > /etc/iptables/rules.v4


echo "透明网关已启用。"
