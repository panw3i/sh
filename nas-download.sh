#!/bin/sh

# 获取传递的参数
url=$1

# 使用 curl 下载文件
curl --tlsv1.2 -O -L $url
