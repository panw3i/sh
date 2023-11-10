# install gost
#!/bin/sh
gost -L="socks5://:7890" -L="http://:2081" -F="mwss://user:password@gost.yourdomain.com:2096"
pm2 start gost --name gost
pm2 save
pm2 startup

