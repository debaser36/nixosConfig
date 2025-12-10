{ pkgs }:
with pkgs;
let
  rstudioCustom = rstudioWrapper.override {
    packages = with rPackages; [
      ggplot2
      dplyr
      xts
      shiny
      learnr
      nycflights13
      tidyverse
    ];
  };
in
[

  # minecraft
  prismlauncher

  rustup # Rust Toolchain, including rustc, cargo, and everything else

  /* docker */
  R
  rstudioCustom
  lutris-free
  # Document Preparation & LaTeX
  texstudio # LaTeX IDE
  kdePackages.okular # pdf viewer
  texliveFull # Complete TeX Live distribution

  # Emulation
  waydroid
  waydroid-helper
  nur.repos.ataraxiasjel.waydroid-script

  # Development Tools & Languages
  git-crypt # Git encryption
  # exercism # Programming exercises platform
  corepack # Node.js package manager manager
  python314 # Python interpreter with all modules
  nil # Nix language server

  # Development Build Tools & Compilers
  libgcc # GCC runtime library
  gcc # GNU Compiler Collection
  rocmPackages.llvm.clang-unwrapped # Clang compiler
  cmakeWithGui # CMake build system with GUI

  # Audio System
  alsa-utils # ALSA sound utilities
  alsa-plugins # ALSA audio plugins

  # Display & Hardware Tools
  edid-decode # EDID decoder utility
  xf86_input_wacom # Wacom tablet X11 driver
  kdePackages.wacomtablet # Wacom tablet configuration
  xorg.xev # X11 event viewer

  # Communication & Social
  discord # Voice and text chat
  element-desktop # Matrix client
  zoom-us # Video conferencing

  # Productivity & Note-taking
  obsidian # Knowledge management
  isabelle # Proof assistant
  keepassxc # Password manager

  # API Development & Database Tools
  bruno # API testing tool
  pgmodeler # PostgreSQL database modeler
  sqlite # SQLite database

  # Wayland Desktop Environment
  swaylock # Screen locker
  swayidle # Idle management daemon
  mako # Notification daemon
  waybar # Status bar

  # Terminal Emulators & File Management
  kitty # GPU-based terminal emulator
  alacritty # GPU-accelerated terminal
  neofetch # System information display
  nnn # File manager

  # Archive & Compression Tools
  zip # ZIP archiver
  xz # XZ compression
  unzip # ZIP extractor
  p7zip # 7-Zip archiver
  zstd # Zstandard compression

  # Data Processing & Text Utilities
  jq # JSON processor
  yq-go # YAML processor
  gnused # GNU stream editor
  tree # Directory tree display
  which # Command location finder

  # Network Tools & Utilities
  wireguard-tools # WireGuard VPN tools
  mtr # Network diagnostic tool
  iperf3 # Network bandwidth testing
  dnsutils # DNS lookup utilities
  ldns # DNS library and tools
  aria2 # Download utility
  socat # Socket relay
  nmap # Network scanner
  ipcalc # IP calculator

  # System Monitoring & Hardware Tools
  xorg.xmodmap # X11 key modifier
  sysstat # System activity tools
  lm_sensors # Hardware monitoring
  ethtool # Ethernet device configuration
  pciutils # PCI utilities
  usbutils # USB utilities
  xorg.xrandr # Display configuration
  wlroots # Wayland compositor library

  # Clipboard & Screenshots
  wl-clipboard # Wayland clipboard utilities
  shotman # Screenshot tool

  # Security & Encryption
  gnupg # GNU Privacy Guard

  # System Notifications & Libraries
  libnotify # Desktop notification library

  # Nix Ecosystem Tools
  nix-output-monitor # Nix build output monitor

  # Media creating and editing
  gimp3-with-plugins # the best image editor known to men and women
]
