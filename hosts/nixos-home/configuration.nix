{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 2;
  networking.hostName = "nixos"; 
  nixpkgs.config.allowUnfree = true;
  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "de_DE.UTF-8";
	
	services.avahi = {
  enable = true;
  nssmdns4 = true;
  openFirewall = true;
};
	services.printing.enable = true;

  nix = {
	package = pkgs.nixVersions.latest;
	extraOptions = "experimental-features = nix-command flakes no-url-literals";
  };  

  #packages needed for flakes to work
  environment.systemPackages = with pkgs; [git vim wget pulseaudio];
  environment.variables.EDITOR = "nvim";

	services.postgresql = {
		enable = true;
		enableTCPIP = true;
		#ensureDatabases = ["pb_app"];
		authentication = pkgs.lib.mkOverride 10 ''
			#type database  DBuser  origin-address auth-method
      local all       all     trust
			host	all				all			127.0.0.1/32 trust
			host	all				all			::1/128			trust
		'';

	};
	
  #virtualisation.virtualbox.guest.enable = true;
  console.keyMap = "de";	

  users.users.nico = {
		isNormalUser = true;
		description = "Default user for personal use of this system!";
		extraGroups = ["networkmanager" "wheel" "video"];
		home = "/home/nico";
  };

		programs.npm = {
			enable = true;
			npmrc = ''
				prefix = ''${HOME}/.npm
				color = true
				audit = false
				fund = false
				init-author-email = dev@unhalteproblem.de
				init-author-url = https://www.unhalteproblem.de
				init-license = MIT
				init-type = module
				prefer-offline = true
				progress = false
				yes = dev
			'';
		};


  security.polkit.enable = true;
  hardware.graphics.enable = true;
  security.rtkit.enable = true;
  services.dbus.enable = true;
  services.pipewire = {
	enable = true;
	alsa.enable = true;
	alsa.support32Bit = true;
	pulse.enable = true;
  };
	hardware.nvidia.open = true;
	services.xserver.videoDrivers = ["nvidia"];
  networking.networkmanager.enable = true;
	networking.firewall.checkReversePath = false;
	networking.wireguard.enable = true;
	services.wg-netmanager.enable = true;

  # sway related stuff
  programs.sway.enable = true;
  environment.etc."default_wallpaper.jpg".source = ./assets/wallpapers/default_wallpaper.jpg;

	#DONT CHANGE THIS LINE
  system.stateVersion = "24.11"; # Did you read the comment?

}

