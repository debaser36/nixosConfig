{ pkgs }:
with pkgs; [
  git-crypt
  wireguard-tools

  exercism
  corepack
  python313Full
  python313Packages.pip
  alsa-utils
  alsa-plugins
  edid-decode


  # WACOM TABLET
  xf86_input_wacom
  wacomtablet
  xorg.xev

  discord

  obsidian
  isabelle


  element-desktop

  #sql
  pgmodeler
  sqlite

  neofetch
  nnn

  swaylock
  swayidle
  mako
  waybar

  # archives
  zip
  xz
  unzip
  p7zip

  #utils
  jq
  yq-go

  #network
  mtr
  iperf3
  dnsutils
  ldns
  aria2
  socat
  nmap
  ipcalc

  #misc
  which
  tree
  gnused
  zstd
  gnupg
  libnotify
  kitty # terminal emulator
  alacritty
  keepassxc
  mako
  wl-clipboard
  shotman

  #nix-related
  nix-output-monitor

  #systools
  xorg.xmodmap
  sysstat
  lm_sensors
  ethtool
  pciutils
  usbutils
  xorg.xrandr
  wlroots

  #gaming
  steam

  #other
  nil

  zoom-us

  libgcc
  gcc
  rocmPackages.llvm.clang-unwrapped
  cmakeWithGui
]
