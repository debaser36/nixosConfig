{ pkgs, nixpkgs-unstable, ... }:

let
  vars = import ./vars.nix;

  pkgs-unstable = import nixpkgs-unstable {
    inherit (pkgs.stdenv.hostPlatform) system;
    config.allowUnfree = true;
  };

in
{
  imports = [
    ../../programs/system/fish.nix
    ./hardware-configuration.nix
    ./http_https/acme.nix
    ./http_https/nginx.nix
    ./sops.nix
  ];

  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        # Without this, anyone on the serial console can add `init=/bin/sh` to the kernel command line
        editor = false;
      };
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
    };
    initrd.systemd.enable = true;
  };

  networking = {
    hostName = vars.hostname;
    networkmanager.enable = true;
  };

  time.timeZone = vars.timezone;
  i18n.defaultLocale = vars.locale;

  users = {
    mutableUsers = false;
    users.${vars.default_user.username} = {
      isNormalUser = true;
      extraGroups = [
        "networkmanager"
        "wheel"
      ];
      openssh.authorizedKeys.keys = [ vars.public_sshKey ];
      home = "/home/" + vars.default_user.username;
      shell = pkgs.fish;
    };
  };

  # Enable passwordless sudo.
  security.sudo.extraRules = [
    {
      users = [ vars.default_user.username ];
      commands = [
        {
          command = "ALL";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];

  nixpkgs = {
    config.allowUnfree = true;
    # Pull claude-code from unstable: stable's version lags too far behind upstream.
    overlays = [
      (_: _: { inherit (pkgs-unstable) claude-code; })
    ];
  };

  environment.systemPackages = with pkgs; [
    curl
    git
    vim
    neovim
    wget
  ];

  nix = {
    package = pkgs.nixVersions.latest;
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [ "nico" "root" ];
      auto-optimise-store = true;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };

  environment.variables.EDITOR = "nvim";
  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    # 2222 for networks that block outgoing port 22 (it must also be allowed in the Oracle Cloud security list)
    ports = [
      22
      2222
    ];
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  # Bans addresses after repeated failed SSH logins (jail on ports 22 and 2222)
  services.fail2ban.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [
    22
    80
    443
    2222
  ];

  # Disable documentation for minimal install.
  documentation.enable = false;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.11"; # Did you read the comment?
}
