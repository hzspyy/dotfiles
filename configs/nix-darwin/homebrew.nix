{ config, pkgs, ... }:

{
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
      upgrade = true;
    };

    # CLI Tools (Part 1)
    brews = [
      "atuin" # Shell history sync tool
      "autossh" # Automatically restart SSH sessions
      "bat" # Better cat with syntax highlighting
      "blueutil" # Bluetooth utility
      "brew-cask-completion" # Completion for brew cask
      "btop" # System monitor
      "cmake" # Build system
      "coreutils" # GNU core utilities
      "dotbot"
      #"eza" # ls alternative
      "ffmpeg" # Multimedia framework
      "findutils" # GNU find utilities
      "fzf" # Fuzzy finder
      "gh" # GitHub CLI
      "git-extras" # Additional git commands
      "git-lfs" # Git large file storage
      "git-secret" # Secret files in git
      "git" # Version control
      "gnu-sed" # GNU version of sed
      "gnupg" # GnuPG encryption
      "go" # Go programming language
      "graphviz" # Graph visualization
      "grep" # GNU grep
      "htop" # Process viewer
      "iperf3" # Network bandwidth tool v3
      "jq" # JSON processor
      "just" # Command runner
      #"keychain" # SSH/GPG key manager
      #"kitty"
      "lazygit" # Git TUI
      "less"
      "neovim"
      "nmap" # Network scanner
      "node" # JavaScript runtime
      "ollama" # Ollama LLMs
      "pipx" # Python app installer
      "pwgen" # Password generator
      "rclone" # Cloud storage sync
      "rsync" # File sync tool
      "sing-box"
      "ssh-copy-id" # SSH public key installer
      "starship" # Shell prompt
      #"superfile" # Modern terminal file manager
      #"syncthing" # File synchronization
      "tailscale" # VPN service
      "tealdeer" # Fast alternative to tldr
      #"terraform" # Infrastructure as code
      "tmux" # Terminal multiplexer
      #"tre-command" # Tree command, improved
      "tree" # Directory listing
      "vim"
      "wget" # File downloader
      "yq" # YAML processor
      "yazi"
      "zsh" # Shell
    ];

    # GUI Applications (Casks)
    casks = [
      "1password-cli" # 1Password CLI
      #"avast-security" # Antivirus
      "chromedriver" # Chrome automation
      "docker" # Container platform
      "font-fira-code" # Programming font
      "font-fira-mono-nerd-font" # Nerd font
      #"git-credential-manager" # Git credential helper
      "iterm2" # Terminal emulator
      #"karabiner-elements" # Keyboard customizer
      "keepingyouawake" # Prevent sleep
      #"keyboard-maestro" # Automation tool
      #"mpv" # Media player
      #"obsidian" # Note taking app
      #"qbittorrent" # Torrent client
      "raycast" # Productivity tool
      #"rectangle" # Window manager
      "slack" # Slack chat
      #"sloth" # Process monitor
      #"spotify" # Music streaming
      #"syncthing" # File synchronization
      #"teamviewer" # Remote control
      #"telegram" # Messenger
      #"tor-browser" # Private browser
      "visual-studio-code" # Code editor
    ]
    ++ (
      if config.isPersonal then
        [
          "1password" # Password manager
          "google-chrome" # Web browser
        ]
      else
        [
          "google-cloud-sdk" # Google Cloud CLI
          "google-drive" # Cloud storage
          "xquartz" # X11 server
          "klayout" # GDS Layout viewer
        ]
    );

    # Additional repositories
    taps = [
      "gromgit/fuse" # For SSHFS
    ];
  };
}
