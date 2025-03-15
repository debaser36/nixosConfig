{ config, lib, pkgs, ... }:

let
  vars = import ./vars.nix;
  unhalteproblemWebsite = (builtins.getFlake "github:debaser36/unhalteproblem.de").packages.aarch64-linux.website;
in
{
  imports =
    [
      	./hardware-configuration.nix
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

  networking.hostName = vars.hostname;
  networking.networkmanager.enable = true;

  time.timeZone = vars.timezone;
  i18n.defaultLocale = vars.locale;

  users = {
    mutableUsers = false;
    users.${vars.username} = {
      isNormalUser = true;
      extraGroups = ["networkmanager" "wheel"];
      openssh.authorizedKeys.keys = [ vars.sshKey ];
      home = "/home/" + vars.username;
    };
  };

  # Enable passwordless sudo.
  security.sudo.extraRules = [
    {
      users = [vars.username];
      commands = [
        {
          command = "ALL";
          options = ["NOPASSWD"];
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
  ];



 nix = {
	package = pkgs.nixVersions.latest;
	extraOptions = "experimental-features = nix-command flakes ";
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
  networking.firewall.allowedTCPPorts = [ 22 80 443 ];

  #nginx setup
  services.nginx = {
 	enable = true;
	recommendedGzipSettings = true;
    	recommendedOptimisation = true;
    	recommendedProxySettings = true;
    	recommendedTlsSettings = true;

  };
  services.nginx.virtualHosts."unhalteproblem.de" = {
		forceSSL = true;
		enableACME = true;
		root = "/var/www/unhalteproblem.de";
		locations."/" = {	
			index = "index.html";
			extraConfig = ''
				try_files $uri $uri/ =404;
			'';
		};
	};
  security.acme = {
  	acceptTerms = true;
	defaults.group = "nginx";
	defaults.email = "admin@unhalteproblem.de";
  };
  users.users.nginx.extraGroups = ["acme"];
  systemd.services."deploy-website" = {
	description = "Copy Website to the correct nixos location";
	after = ["network.target"];
	wants = ["network.target"];
	wantedBy = ["multi-user.target"];
	script = ''
		rm -rf /var/www/unhalteproblem.de
	        mkdir -p /var/www/unhalteproblem.de
	        chown -R nginx:nginx /var/www/unhalteproblem.de
		'';
    };



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
