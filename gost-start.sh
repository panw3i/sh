#!/bin/bash
gost -L="socks5://:7890" -L="http://:2081" -F="mwss://user:password@gost.yourdomain.com:2096"
chmod +x gost-start.sh
pm2 start gost-start.sh --name gost
pm2 save
