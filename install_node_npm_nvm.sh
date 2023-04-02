#!/bin/bash

# 更新软件包列表
sudo apt update

# 安装 Node.js 和 npm
sudo apt install nodejs npm

# 验证 Node.js 和 npm 是否已正确安装
node -v
npm -v

# 自动获取最新版本的 nvm
NVM_VERSION=$(curl -s https://api.github.com/repos/nvm-sh/nvm/releases/latest | grep 'tag_name' | cut -d '"' -f 4)

# 安装 nvm
curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh" | bash

# 使 nvm 可用
source ~/.bashrc

# 验证 nvm 是否已正确安装
nvm --version

# 安装所需的 Node.js 版本
nvm install 16

# 验证 Node.js 版本是否正确安装
node -v
