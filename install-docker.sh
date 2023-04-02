#!/bin/bash

# 检查当前用户是否具有 sudo 权限
if [ "$(id -u)" != "0" ]; then
  echo "错误：脚本必须以 root 用户身份运行。"
  exit 1
fi

# 检查操作系统
if [ "$(uname -s)" == "Linux" ]; then
  if [ -f "/etc/lsb-release" ]; then
    . /etc/lsb-release
    OS="$DISTRIB_ID"
    VER="$DISTRIB_RELEASE"
  elif [ -f "/etc/os-release" ]; then
    . /etc/os-release
    OS="$ID"
    VER="$VERSION_ID"
  elif [ -f "/etc/redhat-release" ]; then
    OS="CentOS"
    VER=$(cat /etc/redhat-release | sed 's/.*release\ //g' | sed 's/\ .*//g')
  else
    echo "错误：不支持的 Linux 发行版。"
    exit 1
  fi
else
  echo "错误：不支持的操作系统。"
  exit 1
fi

# 安装 Docker
if [ "$OS" == "Ubuntu" ]; then
  apt-get update
  apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
  add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
  apt-get update
  apt-get install -y docker-ce docker-ce-cli containerd.io
elif [ "$OS" == "Debian" ]; then
  apt-get update
  apt-get install -y apt-transport-https ca-certificates curl gnupg2 software-properties-common
  curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
  add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
  apt-get update
  apt-get install -y docker-ce docker-ce-cli containerd.io
elif [ "$OS" == "CentOS" ]; then
  yum install -y yum-utils
  yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
  yum update
  yum install -y docker-ce docker-ce-cli containerd.io
else
  echo "错误：不支持的 Linux 发行版。"
  exit 1
fi

# 安装 Docker Compose
LATEST=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep 'tag_name' | cut -d '"' -f 4)
curl -L "https://github.com/docker/compose/releases/download/$LATEST/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# 验证 Docker 和 Docker Compose 是否已正确安装
echo "正在验证 Docker 和 Docker Compose 是否已正确安装..."
docker --version
docker-compose --version

echo "安装完成。"
