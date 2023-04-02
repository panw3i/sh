#!/bin/bash

# Check if the system is Debian/Ubuntu
if [ -f "/etc/debian_version" ]; then
  # Check if apt is installed
  if ! [ -x "$(command -v apt)" ]; then
    echo 'Error: apt is not installed.' >&2
    exit 1
  fi
  # Update apt package list and install required packages
  sudo apt update
  sudo apt install -y zsh git curl
elif [ -f "/etc/redhat-release" ]; then
  # Check if yum is installed
  if ! [ -x "$(command -v yum)" ]; then
    echo 'Error: yum is not installed.' >&2
    exit 1
  fi
  # Install required packages
  sudo yum install -y zsh git curl
else
  echo 'Error: unsupported system.' >&2
  exit 1
fi

# Change the default shell to zsh
chsh -s /bin/zsh

# Install oh-my-zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
  echo 'oh-my-zsh is already installed.'
fi

# Copy zshrc template file to the user's home directory
cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc

# Install autojump
if ! [ -x "$(command -v autojump)" ]; then
  sudo apt install -y autojump  # For Debian/Ubuntu
  # sudo yum install -y autojump  # For CentOS/RHEL
else
  echo 'autojump is already installed.'
fi

# Install zsh-autosuggestions
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
else
  echo 'zsh-autosuggestions is already installed.'
fi

# Install zsh-syntax-highlighting
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
else
  echo 'zsh-syntax-highlighting is already installed.'
fi

# Configure zsh
sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="ys"/g' ~/.zshrc
sed -i 's/plugins=(git)/plugins=(git autojump zsh-autosuggestions zsh-syntax-highlighting)/g' ~/.zshrc

# Reload zsh configuration
source ~/.zshrc

echo "Installation complete! Please restart your terminal to apply changes."
