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
	
  	

    # sway related stuff
  programs.sway.enable = true;

}