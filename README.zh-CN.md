# 🏠 dotfiles

[English](README.md) · **简体中文**

我个人的跨平台 dotfiles，支持 **macOS**（Apple Silicon）与 **Ubuntu/Debian** Linux。
软链接由 [dotbot](https://github.com/anishathalye/dotbot) 管理；macOS 的系统状态由
[nix-darwin](https://github.com/nix-darwin/nix-darwin) 声明式管理。

> Fork 自 [basnijholt/dotfiles](https://github.com/basnijholt/dotfiles)，并围绕基于
> [zcomet](https://github.com/agkozak/zcomet) 的 Zsh 配置与
> [Powerlevel10k](https://github.com/romkatv/powerlevel10k) 主题重做。

## ✨ 亮点

- **Zsh 技术栈** —— `zcomet` 插件管理器、Powerlevel10k 主题、`fzf-tab`、自动补全建议、
  fast-syntax-highlighting，并通过 `smartcache` 做工具初始化的惰性/缓存加载。
- **XDG 规范** —— 配置统一放在 `~/.config`；`~/.zshenv` 设置 `ZDOTDIR`，使 `$HOME` 下唯一
  的文件就是 `~/.zshenv` 本身。
- **终端工具链** —— [kitty](https://sw.kovidgoyal.net/kitty/)、[yazi](https://yazi-rs.github.io/)、
  [zellij](https://zellij.dev/)、[tmux](https://github.com/tmux/tmux)、[atuin](https://atuin.sh/)、
  [lazygit](https://github.com/jesseduffield/lazygit)、`bat`、`ripgrep`、`direnv`、`starship`。
- **AI 命令行** —— `configs/` 下预置了 Claude Code、Codex、Gemini 的配置。
- **macOS 用 Nix** —— 通过 `nix-darwin` 声明式管理系统与 Homebrew 软件包
  （见 [`configs/nix-darwin/`](configs/nix-darwin/)）。
- **国内镜像** —— Homebrew / PyPI 镜像环境变量已写入 `configs/zsh/zshenv`。

## 🚀 安装

```bash
git clone git@github.com:hzspyy/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install
```

`./install` 跨平台：它会先确保 [dotbot](https://github.com/anishathalye/dotbot) 可用
（macOS 用 Homebrew、Linux 用 `uv`），再按 [`install.conf.yaml`](install.conf.yaml) 创建所有
软链接。在 Ubuntu/Debian 上，其中的 `shell` 步骤还会执行
`sudo configs/ubuntu/install_packages.sh` 安装基础软件包。

### macOS —— nix-darwin

执行 `./install` 之后，应用 nix-darwin 配置 —— 见
[`configs/nix-darwin/README.md`](configs/nix-darwin/README.md)：

```bash
# 安装 Nix（Determinate Systems 安装器）
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install

# 应用配置（别名：nixswitch）
nix run nix-darwin -- switch --flake ~/dotfiles/configs/nix-darwin
```

### 卸载

```bash
./uninstall.py   # 移除 install.conf.yaml 创建的软链接
```

## 🧩 仓库结构

```text
.
├── configs/                # 所有工具配置（软链接到 ~/.config）
│   ├── atuin/              # Shell 历史（含 ZFS daemon 变体）
│   ├── bash/               # Bash 入口
│   ├── bat/                # bat（更好用的 cat）
│   ├── claude/             # Claude Code 配置
│   ├── codex/              # Codex CLI（AGENTS.md、config.toml）
│   ├── direnv/             # direnv
│   ├── gemini/             # Gemini CLI
│   ├── git/                # Git 配置、attributes、签名
│   ├── htop/  less/  pip/  # 其他工具的 rc 文件
│   ├── kitty/              # Kitty 终端（主题、键位）
│   ├── lazygit/            # lazygit TUI
│   ├── nix/                # nix.conf
│   ├── nix-darwin/         # 声明式 macOS 系统 + Homebrew（flake、Justfile）
│   ├── ripgrep/  uv/       # ripgrep 与 uv 配置
│   ├── ssh/                # SSH 客户端配置
│   ├── starship/           # Starship 主题
│   ├── tmux/               # tmux
│   ├── ubuntu/             # Ubuntu 软件包引导脚本
│   ├── vim/  vscode/       # 编辑器
│   ├── yazi/               # Yazi 文件管理器（插件、主题）
│   ├── zellij/             # Zellij 多路复用器
│   └── zsh/                # Zsh：zshenv、zshrc、别名、函数、键位、p10k
├── scripts/                # 独立辅助脚本（默认不软链接）
├── install.conf.yaml       # dotbot 链接映射表
├── install                 # 跨平台安装器（确保 dotbot 存在并执行 dotbot）
├── uninstall.py            # 移除软链接
└── Dockerfile              # 一次性 Ubuntu 容器，用于试用 shell
```

## 🐚 Shell 配置

Zsh 分两个阶段加载：

- **`~/.zshenv`** → [`configs/zsh/zshenv`](configs/zsh/zshenv)：XDG 基础目录、`ZDOTDIR`、`EDITOR`、
  `FZF_*`、`LESS*`、Homebrew/PyPI 国内镜像，以及 `PATH`。
- **`$ZDOTDIR/.zshrc`** → [`configs/zsh/zshrc`](configs/zsh/zshrc)：引导 `zcomet`，加载插件
  （补全、`git-extras`、`LS_COLORS`、`smartcache`、`fzf-tab`、`zsh-autosuggestions`、
  `fast-syntax-highlighting`、`powerlevel10k`），配置补全样式、键位，最后 `eval`
  `atuin` 与 `direnv`。

下列文件均位于 `configs/zsh/`，由 `.zshrc` 负责 source：

| 文件 | 用途 |
| --- | --- |
| `00_alias.zsh` | 别名（如基于 eza 的 `l`/`lt`、剪贴板、全局别名） |
| `20_functions.zsh` | Shell 函数（如 `upgrade-all`） |
| `30_keymaps.zsh` | 键位绑定 |
| `p10k.zsh` | Powerlevel10k 主题配置 |

Bash 作为后备方案：走 `configs/bash/` 里的 `~/.bash_profile` → `~/.bashrc` 链路。

## 🍎 macOS（nix-darwin）

[`configs/nix-darwin/`](configs/nix-darwin/) 的 flake 声明式管理系统，包含
[`homebrew.nix`](configs/nix-darwin/homebrew.nix) 里完整的 Homebrew 包/cask 列表。
[`Justfile`](configs/nix-darwin/Justfile) 封装了常用操作：

```bash
just switch   # 重建并应用（别名：nixswitch）
just --list   # 查看全部可用命令
```

## 🐳 用 Docker 试用

[`Dockerfile`](Dockerfile) 会启动一个一次性的 Ubuntu 容器，带上这套 Zsh 环境：

```bash
docker build -t dotfiles-env .
docker run -it --rm dotfiles-env
```

## 🛠️ scripts/

`scripts/` 存放独立辅助脚本，**不**会被 `install.conf.yaml` 软链接 —— 需要时直接运行即可
（如 `scripts/commit.py`、`scripts/setup-atuin-daemon.sh`、`scripts/apt-update.sh`）。

## 📄 许可证

MIT —— 见 [`LICENSE`](LICENSE)。
