# 🏠 dotfiles

My personal, cross-platform dotfiles for **macOS** (Apple Silicon) and **Ubuntu/Debian** Linux.
Symlinks are managed with [dotbot](https://github.com/anishathalye/dotbot); macOS system state is
managed declaratively with [nix-darwin](https://github.com/nix-darwin/nix-darwin).

> Forked from [basnijholt/dotfiles](https://github.com/basnijholt/dotfiles) and reworked around a
> [zcomet](https://github.com/agkozak/zcomet)-based Zsh setup with a
> [Powerlevel10k](https://github.com/romkatv/powerlevel10k) prompt.

## ✨ Highlights

- **Zsh stack** — `zcomet` plugin manager, Powerlevel10k prompt, `fzf-tab`, autosuggestions,
  fast-syntax-highlighting, and lazy/cached tool init via `smartcache`.
- **XDG-clean** — everything lives under `~/.config`; `~/.zshenv` sets `ZDOTDIR` so the only file
  in `$HOME` is `~/.zshenv` itself.
- **Terminal tooling** — [kitty](https://sw.kovidgoyal.net/kitty/), [yazi](https://yazi-rs.github.io/),
  [zellij](https://zellij.dev/), [tmux](https://github.com/tmux/tmux), [atuin](https://atuin.sh/),
  [lazygit](https://github.com/jesseduffield/lazygit), `bat`, `ripgrep`, `direnv`, `starship`.
- **AI CLIs** — pre-baked configs for Claude Code, Codex, and Gemini under `configs/`.
- **macOS via Nix** — reproducible system + Homebrew packages through `nix-darwin`
  (see [`configs/nix-darwin/`](configs/nix-darwin/)).
- **China mirrors** — Homebrew / PyPI mirror env vars baked into `configs/zsh/zshenv`.

## 🚀 Installation

```bash
git clone git@github.com:hzspyy/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

### macOS

`install_mac` runs dotbot against [`install.conf.yaml`](install.conf.yaml) (install dotbot first,
e.g. `brew install dotbot`):

```bash
./install_mac
```

Then apply the nix-darwin configuration — see [`configs/nix-darwin/README.md`](configs/nix-darwin/README.md):

```bash
# Install Nix (Determinate Systems installer)
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install

# Apply the configuration (alias: nixswitch)
nix run nix-darwin -- switch --flake ~/dotfiles/configs/nix-darwin
```

### Ubuntu / Debian

`install_ubuntu` bootstraps dotbot, links the configs, and (via the `shell` step in
`install.conf.yaml`) installs base packages with `sudo configs/ubuntu/install_packages.sh`:

```bash
./install_ubuntu
```

### Uninstall

```bash
./uninstall.py   # removes the symlinks created by install.conf.yaml
```

## 🧩 Repository structure

```text
.
├── configs/                # All tool configurations (symlinked into ~/.config)
│   ├── atuin/              # Shell history (+ ZFS daemon variant)
│   ├── bash/               # Bash entry points
│   ├── bat/                # bat (better cat)
│   ├── claude/             # Claude Code settings
│   ├── codex/              # Codex CLI (AGENTS.md, config.toml)
│   ├── direnv/             # direnv
│   ├── gemini/             # Gemini CLI
│   ├── git/                # Git config, attributes, signing
│   ├── htop/  less/  pip/  # Misc tool rc files
│   ├── kitty/              # Kitty terminal (themes, keymaps)
│   ├── lazygit/            # lazygit TUI
│   ├── nix/                # nix.conf
│   ├── nix-darwin/         # Declarative macOS system + Homebrew (flake, Justfile)
│   ├── ripgrep/  uv/       # ripgrep & uv config
│   ├── ssh/                # SSH client config
│   ├── starship/           # Starship prompt
│   ├── tmux/               # tmux
│   ├── ubuntu/             # Ubuntu package bootstrap script
│   ├── vim/  vscode/       # Editors
│   ├── yazi/               # Yazi file manager (plugins, themes)
│   ├── zellij/             # Zellij multiplexer
│   └── zsh/                # Zsh: zshenv, zshrc, aliases, functions, keymaps, p10k
├── scripts/                # Standalone helper scripts (not symlinked by default)
├── install.conf.yaml       # dotbot link map
├── install_mac             # dotbot entry point (macOS)
├── install_ubuntu          # dotbot bootstrap + entry point (Ubuntu/Debian)
├── uninstall.py            # Remove symlinks
└── Dockerfile              # Throwaway Ubuntu container to try the shell
```

## 🐚 Shell configuration

Zsh loads in two stages:

- **`~/.zshenv`** → [`configs/zsh/zshenv`](configs/zsh/zshenv): XDG base dirs, `ZDOTDIR`, `EDITOR`,
  `FZF_*`, `LESS*`, Homebrew/PyPI China mirrors, and `PATH`.
- **`$ZDOTDIR/.zshrc`** → [`configs/zsh/zshrc`](configs/zsh/zshrc): bootstraps `zcomet`, loads
  plugins (completions, `git-extras`, `LS_COLORS`, `smartcache`, `fzf-tab`, `zsh-autosuggestions`,
  `fast-syntax-highlighting`, `powerlevel10k`), completion styles, key bindings, and finally
  `eval`s `atuin` and `direnv`.

Supporting files, all under `configs/zsh/` and sourced from `.zshrc`:

| File | Purpose |
| --- | --- |
| `00_alias.zsh` | Aliases (e.g. `l`/`lt` via eza, clipboard, global aliases) |
| `20_functions.zsh` | Shell functions (e.g. `upgrade-all`) |
| `30_keymaps.zsh` | Key bindings |
| `p10k.zsh` | Powerlevel10k prompt configuration |

Bash is supported as a fallback: `~/.bash_profile` → `~/.bashrc` chain in `configs/bash/`.

## 🍎 macOS (nix-darwin)

The [`configs/nix-darwin/`](configs/nix-darwin/) flake manages the system declaratively, including
the full Homebrew package/cask list in [`homebrew.nix`](configs/nix-darwin/homebrew.nix). A
[`Justfile`](configs/nix-darwin/Justfile) wraps the common operations:

```bash
just switch   # rebuild & apply (alias: nixswitch)
just --list   # see all available recipes
```

## 🐳 Trying it in Docker

The [`Dockerfile`](Dockerfile) spins up a throwaway Ubuntu container with the Zsh environment:

```bash
docker build -t dotfiles-env .
docker run -it --rm dotfiles-env
```

## 🛠️ scripts/

`scripts/` holds standalone helpers that are **not** symlinked by `install.conf.yaml` — run them
directly when needed (e.g. `scripts/commit.py`, `scripts/setup-atuin-daemon.sh`,
`scripts/apt-update.sh`).

## 📄 License

MIT — see [`LICENSE`](LICENSE).
