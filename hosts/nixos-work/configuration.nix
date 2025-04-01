{ pkgs, lib, ... }:

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


	nix.package = pkgs.nixVersions.latest;
	nix.extraOptions = "experimental-features = nix-command flakes no-url-literals";

  #packages needed for flakes to work
  environment.systemPackages = with pkgs; 
	[
		git 
		vim 
		wget 
		pulseaudio
		wlroots
		xorg.xrandr
		nodejs_23
	];

	environment.variables = {   
	WLR_RENDERER_ALLOW_SOFTWARE="1";
	#WLR_RENDERER="gles2";
  #WLR_EVDI_RENDER_DEVICE = "/dev/dri/card1";    
	EDITOR = "nvim";
};
  environment.etc."default_wallpaper.jpg".source = ./assets/wallpapers/default_wallpaper.jpg;


	
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
			init-license=MIT
			audit=false
			fund=false
			init-type=module
			prefer-offline=true
			progress=false
			prefix=~/.npm-global

		'';
	};



  security.polkit.enable = true;
  hardware.graphics.enable = true;
	hardware.graphics.enable32Bit = true;
  security.rtkit.enable = true;
  services.dbus.enable = true;
  services.pipewire = {
	enable = true;
	alsa.enable = true;
	alsa.support32Bit = true;
	pulse.enable = true;
  };
	services.xserver.videoDrivers = ["modesetting"];
	systemd.services.dlm.wantedBy = ["multi-user.target"];
  networking.networkmanager.enable = true;
	networking.firewall.checkReversePath = false;
	networking.wireguard.enable = true;
	services.wg-netmanager.enable = true;

  # sway related stuff
  programs.sway.enable = true;

	#DONT CHANGE THIS LINE
  system.stateVersion = "24.11"; # Did you read the comment?

}

