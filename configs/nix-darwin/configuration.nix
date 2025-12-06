{ pkgs, lib, ... }:
{
  # Required for current nix-darwin
  nixpkgs.hostPlatform = "aarch64-darwin"; # for Apple Silicon

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;

  # --- Nix Settings ---
  nix.settings = {
    # 开启自动 GC，每周清理旧文件
    gc = {
      automatic = lib.mkDefault true;
      options = lib.mkDefault "--delete-older-than 7d";
    };
    
    experimental-features = [ "nix-command" "flakes" ];

    
    substitutions = [
      "https://mirror.sjtu.edu.cn/nix-channels/store"
      "https://nix-community.cachix.org"
    ];
    
    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
    
    builders-use-substitutes = true;
  };

  # Auto upgrade nix package and the daemon service.
  nix.package = pkgs.nix;

  nix.enable = false;

  # Add system packages
  environment.systemPackages = with pkgs; [
    nixpkgs-fmt
  ];

  programs.zsh.enable = false;

  # Configure sudo password timeout (in minutes)
  security.sudo.extraConfig = ''
    # Set timeout to 1 hour (60 minutes)
    Defaults timestamp_timeout=60
  '';

  #TODO: chang the nix  cache dir to $HOME/nvme-cache/nix

  # Keyboard
  system.keyboard.enableKeyMapping = true;

  # Configure macOS system defaults
  system.defaults = {
    NSGlobalDomain = {
      # Auto hide the menubar
      _HIHideMenuBar = true;

      # Enable full keyboard access for all controls
      AppleKeyboardUIMode = 3;

      # Enable press-and-hold repeating
      ApplePressAndHoldEnabled = false;
      InitialKeyRepeat = 20;  # normal minimum is 15 (225 ms), maximum is 120 (1800 ms)
      KeyRepeat = 2;   # normal minimum is 2 (30 ms), maximum is 120 (1800 ms

      # Disable "Natural" scrolling
      "com.apple.swipescrolldirection" = false;

      # Disable smart dash/period/quote substitutions
      NSAutomaticDashSubstitutionEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false;

      # Disable automatic capitalization
      NSAutomaticCapitalizationEnabled = false;

      # Using expanded "save panel" by default
      NSNavPanelExpandedStateForSaveMode = true;
      NSNavPanelExpandedStateForSaveMode2 = true;

      # Increase window resize speed for Cocoa applications
      NSWindowResizeTime = 0.001;

      # Save to disk (not to iCloud) by default
      NSDocumentSaveNewDocumentsToCloud = true;
    };

    dock = {
      # Set dock to auto-hide, and transparentize icons of hidden apps (⌘H)
      autohide = true;
      showhidden = true;

      # Set the animation time modifier (0.0 = instant)
      autohide-time-modifier = 0.0;

      # Disable to show recents, and light-dot of running apps
      show-recents = false;
      show-process-indicators = false;
      #wvous-tr-corner = 13;  # top-right - Lock Screen
      #wvous-br-corner = 4;  # bottom-right - Desktop
      #wvous-tl-corner = 2;  # top-left - Mission Control
      #wvous-bl-corner = 3;  # bottom-left - Application Windows
    };

    finder = {
      # Allow quitting via ⌘Q
      QuitMenuItem = true;

      # Disable warning when changing a file extension
      FXEnableExtensionChangeWarning = false;

      # Show all files and their extensions
      AppleShowAllExtensions = false;
      AppleShowAllFiles = false;

      # Show path bar, and layout as multi-column
      ShowPathbar = true;

      _FXShowPosixPathInTitle = true;  # show full path in finder title

      #ShowStatusBar = true;  # show status bar
      FXPreferredViewStyle = "clmv";

      # Search in current folder by default
      FXDefaultSearchScope = "SCcf";
    };

    #trackpad = {
    #  # Enable trackpad tap to click
    #  Clicking = true;

    #  # Enable 3-finger drag
    #  TrackpadThreeFingerDrag = true;
    #};

    ActivityMonitor = {
      # Sort by CPU usage
      SortColumn = "CPUUsage";
      SortDirection = 0;
    };

    LaunchServices = {
      # Disable quarantine for downloaded apps
      LSQuarantine = false;
    };

    CustomSystemPreferences = {
      NSGlobalDomain = {
        # Set the system accent color, TODO: https://github.com/LnL7/nix-darwin/pull/230
        #AppleAccentColor = 6;
        # Jump to the spot that's clicked on the scroll bar, TODO: https://github.com/LnL7/nix-darwin/pull/672
        AppleScrollerPagingBehavior = true;
        # Prefer tabs when opening documents, TODO: https://github.com/LnL7/nix-darwin/pull/673
        AppleWindowTabbingMode = "always";
      };
      "com.apple.finder" = {
        # Keep the desktop clean
        ShowHardDrivesOnDesktop = false;
        ShowRemovableMediaOnDesktop = false;
        ShowExternalHardDrivesOnDesktop = false;
        ShowMountedServersOnDesktop = false;

        # Show directories first
        _FXSortFoldersFirst = true; # TODO: https://github.com/LnL7/nix-darwin/pull/594

        # New window use the $HOME path
        NewWindowTarget = "PfHm";
        NewWindowTargetPath = "file://$HOME/";

        # Allow text selection in Quick Look
        QLEnableTextSelection = true;
      };
      "com.apple.Safari" = {
        # For better privacy
        UniversalSearchEnabled = false;
        SuppressSearchSuggestions = true;
        SendDoNotTrackHTTPHeader = true;

        # Disable auto open safe downloads
        AutoOpenSafeDownloads = false;

        # Enable Develop Menu, Web Inspector
        IncludeDevelopMenu = true;
        IncludeInternalDebugMenu = true;
        WebKitDeveloperExtras = true;
        WebKitDeveloperExtrasEnabledPreferenceKey = true;
        "com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled" = true;
      };
      "com.apple.universalaccess" = {
        # Set the cursor size, TODO: https://github.com/LnL7/nix-darwin/pull/671
        mouseDriverCursorSize = 1.5;
      };
      "com.apple.screencapture" = {
        # Set the filename which screencaptures should be written, TODO: https://github.com/LnL7/nix-darwin/pull/670
        name = "screenshot";
        include-date = false;
      };
      "com.apple.desktopservices" = {
        # Avoid creating .DS_Store files on USB or network volumes
        DSDontWriteUSBStores = true;
        DSDontWriteNetworkStores = true;
      };
      "com.apple.frameworks.diskimages" = {
        # Disable disk image verification
        skip-verify = true;
        skip-verify-locked = true;
        skip-verify-remote = true;
      };
      "com.apple.CrashReporter" = {
        # Disable crash reporter
        DialogType = "none";
      };
      "com.apple.AdLib" = {
        # Disable personalized advertising
        forceLimitAdTracking = true;
        allowApplePersonalizedAdvertising = false;
        allowIdentifierForAdvertising = false;
      };
    };
  };

  system.activationScripts.setting.text = ''
      # Unpin all apps, TODO: https://github.com/LnL7/nix-darwin/pull/619
      defaults write com.apple.dock persistent-apps -array ""

      # Show metadata info, but not preview in info panel
      defaults write com.apple.finder FXInfoPanesExpanded -dict MetaData -bool true Preview -bool false

      # Allow opening apps from any source
      sudo spctl --master-disable

      # Change the default apps
      #duti -s com.microsoft.VSCode .txt all
      #duti -s com.microsoft.VSCode .ass all
      #duti -s io.mpv .mkv all
      #duti -s com.colliderli.iina .mp4 all

      #~/.config/os/darwin/power.sh
    '';

  # Add ability to used TouchID for sudo
  security.pam.services.sudo_local.touchIdAuth = true;


}
