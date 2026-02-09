{ pkgs, ... }:
{
  home.packages = with pkgs; [
    neofetch
    nnn

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
    openssl
    #misc
    which
    tree
    gnused
    zstd
    gnupg
    libnotify
    kitty

    #nix-related
    nix-output-monitor

    #systools
    sysstat
    lm_sensors
    ethtool
    pciutils
    usbutils
    xrandr
  ];
}
