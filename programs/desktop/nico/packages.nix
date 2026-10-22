# User packages shared by all desktop hosts; each host adds its own in hosts/<host>/nico/packageList.nix.
# Programs enabled through a module (kitty, waybar, swaylock, swayidle, mako, gnupg, steam) are
# installed by that module and are not listed here.
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Development
    git-crypt # Git encryption
    nil # Nix language server

    # Audio
    alsa-utils
    alsa-plugins

    # Display & input
    edid-decode # EDID decoder, used by programs/tools/monitor_info
    xev # X11 event viewer
    xmodmap
    xrandr

    # Communication
    element-desktop # Matrix client
    zoom-us

    # Productivity
    obsidian
    keepassxc # Password manager

    # Terminal & files
    alacritty
    fastfetch
    nnn

    # Archives
    zip
    xz
    unzip
    p7zip
    zstd

    # Data & text
    jq
    yq-go
    gnused
    tree
    which

    # Network
    wireguard-tools
    mtr
    iperf3
    dnsutils
    ldns
    aria2
    socat
    nmap
    ipcalc

    # System
    sysstat
    lm_sensors
    ethtool
    pciutils
    usbutils

    # Wayland desktop
    wl-clipboard
    shotman # Screenshots
    libnotify

    # Nix
    nix-output-monitor
  ];
}
