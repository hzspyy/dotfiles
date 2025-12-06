#!/bin/bash
set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}🐧 Starting Ubuntu Setup Script...${NC}"

# 0. 基础检查与提权
if [ "$EUID" -ne 0 ]; then
  echo -e "${RED}Please run as root or use sudo.${NC}"
  exit 1
fi

echo -e "${BLUE}📦 Updating apt cache and installing base dependencies...${NC}"
apt-get update
apt-get install -y curl wget git build-essential gpg software-properties-common unzip vim

# ==============================================================================
# 1. 配置第三方源 (许多现代工具不在默认源里)
# ==============================================================================

# --- Eza (ls replacement) ---
if ! command -v eza &> /dev/null; then
    echo -e "${GREEN}Adding Eza repository...${NC}"
    mkdir -p /etc/apt/keyrings
    wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
    echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | tee /etc/apt/sources.list.d/gierens.list
    chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
fi


# 更新源以获取新添加的包信息
apt-get update

# ==============================================================================
# 2. 安装 APT 软件包
# ==============================================================================
echo -e "${BLUE}📦 Installing APT packages...${NC}"

PACKAGES=(
    # 系统工具
    "zsh"
    "tmux"
    "ffmpeg"
    "ripgrep"      # rg
    "fd-find"      # fd
    "bat"          # bat
    "fzf"
    "jq"
    "tree"
    "htop"
    "btop"
    "iputils-ping" # ping
    "net-tools"    # ifconfig etc
    "nmap"
    "iperf3"
    "socat"
    
    # 开发工具
    "git"
    "make"
    "gcc"
    "python3-pip"
    "python3-venv"
    "golang-go"
    "nodejs"
    "npm"
    
    "eza"
)

# 安装所有包
apt-get install -y "${PACKAGES[@]}"

# 修复 bat 命令 (Ubuntu下默认叫 batcat)
if [ ! -f /usr/local/bin/bat ] && [ -f /usr/bin/batcat ]; then
    ln -s /usr/bin/batcat /usr/local/bin/bat
fi
if [ ! -f /usr/local/bin/fd ] && [ -f /usr/bin/fdfind ]; then
    ln -s /usr/bin/fdfind /usr/local/bin/fd
fi

# ==============================================================================
# 3. 安装非 APT 工具 (通过脚本/二进制)
# ==============================================================================

# --- uv (Python Package Manager) ---
if ! command -v uv &> /dev/null; then
    echo -e "${GREEN}🐍 Installing uv (Python tool)...${NC}"
    # 指定 UV_INSTALL_DIR 为 /usr/local/bin，确保所有用户可用
    curl -LsSf https://astral.sh/uv/install.sh | env UV_INSTALL_DIR="/usr/local/bin" sh
fi


# --- Zoxide (z) ---
if ! command -v zoxide &> /dev/null; then
    echo -e "${GREEN}📂 Installing Zoxide...${NC}"
    curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
    # 需要手动添加到 path，或者依靠 dotfiles 的配置
fi


# --- Just ---
if ! command -v just &> /dev/null; then
    echo -e "${GREEN}🔧 Installing Just...${NC}"
    curl --proto '=https' --tlsv1.2 -sSf https://just.systems/install.sh | bash -s -- --to /usr/local/bin
fi

# --- LazyGit ---
#if ! command -v lazygit &> /dev/null; then
#    echo -e "${GREEN}Installing LazyGit...${NC}"
#    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
#    curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
#    tar xf lazygit.tar.gz lazygit
#    install lazygit /usr/local/bin
#    rm lazygit lazygit.tar.gz
#fi

# --- Yazi (Terminal File Manager) ---
# Yazi 需要较新的 Rust 环境，这里下载预编译二进制比较稳妥
#if ! command -v yazi &> /dev/null; then
#    echo -e "${GREEN}Installing Yazi...${NC}"
#    # 这里为了简化，假设是 x86_64，如果是 ARM 服务器请修改 URL
#    curl -LO https://github.com/sxyazi/yazi/releases/latest/download/yazi-x86_64-unknown-linux-gnu.zip
#    unzip yazi-x86_64-unknown-linux-gnu.zip
#    mv yazi-x86_64-unknown-linux-gnu/yazi /usr/local/bin/
#    rm -rf yazi-x86_64-unknown-linux-gnu*
#fi
#
echo -e "${BLUE}🎉 Ubuntu Setup Complete!${NC}"
