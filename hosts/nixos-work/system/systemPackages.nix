{pkgs}:
{
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

    # sway related stuff
  programs.sway.enable = true;

}