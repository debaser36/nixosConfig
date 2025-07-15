{ pkgs, nix-vscode-extension, ... }:

{
  imports =
    [
      ../hardware/hardware-configuration.nix
      (import ./environment.etc.nix)
      (import ./systemPackages.nix { inherit pkgs; })
      (import ../../../programs/system/npm.nix)
    ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
    timeout = 2;
  };

  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
    firewall = {
      checkReversePath = false;
      allowedUDPPorts = [ 51820 ];
    };
    wireguard.enable = true;
  };

  nixpkgs = {
    overlays = [
      nix-vscode-extension.overlays.default
      (
        final: prev: {
          flutter = prev.flutter319;
        }
      )
    ];
    config = {
      allowUnfree = true;
    };
  };

  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "de_DE.UTF-8";

  nix = {
    package = pkgs.nixVersions.latest;
    extraOptions = "experimental-features = nix-command flakes no-url-literals";
  };

  fonts.packages = [ pkgs.fira-code ];

  environment.variables = {
    WLR_RENDERER_ALLOW_SOFTWARE = "1";
    EDITOR = "nvim";
  };

  #virtualisation.virtualbox.guest.enable = true;
  console.keyMap = "de";

  users = {
    defaultUserShell = pkgs.fish;
    users.nico = {
      isNormalUser = true;
      description = "Default user for personal use of this system!";
      extraGroups = [ "networkmanager" "wheel" "video" "storage" ];
      home = "/home/nico";
      shell = pkgs.fish;
    };
  };

  security = {
    polkit.enable = true;
    rtkit.enable = true;
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services = {
    udisks2.enable = true;
    udev = {
      packages = [pkgs.yubikey-personalization];
    };

    dbus.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    xserver = {
      wacom.enable = true;
      videoDrivers = [ "modesetting" ];
    };
    wg-netmanager.enable = true;
  };

  systemd.services.dlm.wantedBy = [ "multi-user.target" ];

  #DONT CHANGE THIS LINE
  system.stateVersion = "24.11"; # Did you read the comment?
}
