{ pkgs, ... }:

let
  vars = import ./vars.nix;

in
{
  imports =
    [
      ./hardware-configuration.nix
      ./http_https/acme.nix
      ./http_https/nginx.nix
      ./http_https/keycloak.nix
      ./http_https/postgres.nix
      ./http_https/website-activation.nix
    ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
    };
    initrd.systemd.enable = true;
  };
  systemd.targets.multi-user.enable = true;

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
      extraGroups = [ "networkmanager" "wheel" ];
      openssh.authorizedKeys.keys = [ vars.public_sshKey ];
      home = "/home/" + vars.default_user.username;
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

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    openssh
    curl
    git
    vim
    neovim
    wget
    nginx
    nodejs
    nodePackages.pnpm
  ];

  nix = {
    package = pkgs.nixVersions.latest;
    extraOptions = ''
      			experimental-features = nix-command flakes 
      			trusted-users = nico root
      			sandbox = false
      			'';

  };

  environment.variables.EDITOR = "nvim";
  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  # Disable autologin.
  services.getty.autologinUser = null;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 22 80 443 5432 ];

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
