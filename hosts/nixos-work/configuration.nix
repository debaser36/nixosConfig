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
  WLR_EVDI_RENDER_DEVICE = "/dev/dri/card1";    
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
nixpkgs.overlays = [
  (final: prev: {    
    wlroots_0_17 = 
			prev.wlroots_0_17.overrideAttrs (old: { # you may need to use 0_18
					patches = (old.patches or [ ]) ++ [
						(prev.fetchpatch {
          url = "https://gitlab.freedesktop.org/wlroots/wlroots/uploads/bd115aa120d20f2c99084951589abf9c/DisplayLink_v2.patch";
              hash = "sha256-vWQc2e8a5/YZaaHe+BxfAR/Ni8HOs2sPJ8Nt9pfxqiE=";
            })       
          ];
			  });
wlroots_0_18 = prev.wlroots_0_18.overrideAttrs (old: { # you may need to use 0_18
      patches = (old.patches or [ ]) ++ [
        (prev.fetchpatch {
          url = "https://gitlab.freedesktop.org/wlroots/wlroots/uploads/bd115aa120d20f2c99084951589abf9c/DisplayLink_v2.patch";
              hash = "sha256-vWQc2e8a5/YZaaHe+BxfAR/Ni8HOs2sPJ8Nt9pfxqiE=";
            })       
          ];

      });})
];


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
	services.xserver.videoDrivers = ["displaylink" "modesetting"];
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

