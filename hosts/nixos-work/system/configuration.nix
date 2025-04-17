{ pkgs, nix-vscode-extension, ... }:

{
  imports =
    [
      ../hardware/hardware-configuration.nix
			(import ./environment.etc.nix)
			(import ./systemPackages.nix {inherit pkgs;})
      (import ../../../programs/system/npm.nix)
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 2;
  networking.hostName = "nixos"; 
  nixpkgs.overlays = [
    nix-vscode-extension.overlays.default
  ];
  nixpkgs.config.allowUnfree = true;
  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "de_DE.UTF-8";


	nix.package = pkgs.nixVersions.latest;
	nix.extraOptions = "experimental-features = nix-command flakes no-url-literals";
  fonts.packages = [pkgs.fira-code];

  
	environment.variables = {   
		WLR_RENDERER_ALLOW_SOFTWARE="1";
		EDITOR = "nvim";
	};


	
  #virtualisation.virtualbox.guest.enable = true;
  console.keyMap = "de";	

  users.users.nico = {
		isNormalUser = true;
		description = "Default user for personal use of this system!";
		extraGroups = ["networkmanager" "wheel" "video"];
		home = "/home/nico";
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







	services.xserver.wacom.enable = true;
	services.xserver.videoDrivers = ["modesetting"];
	systemd.services.dlm.wantedBy = ["multi-user.target"];
  networking.networkmanager.enable = true;
	networking.firewall.checkReversePath = false;
	networking.wireguard.enable = true;
	services.wg-netmanager.enable = true;



	#DONT CHANGE THIS LINE
  system.stateVersion = "24.11"; # Did you read the comment?

}

