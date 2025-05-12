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
		procps
	];
	
  	

    # sway related stuff
  programs.sway.enable = true;
	programs.fish.enable = true;

	# displayManager
	services.displayManager.defaultSession = "sway";
	services.xserver.enable = true;
	services.displayManager.sddm = {
		enable = true;
	};

	# psql
	services.postgresql = {
		enable = true;
		ensureDatabases = ["pb_app"];
		enableTCPIP = true;
		authentication = pkgs.lib.mkOverride 10 ''
			#...
			#type database DBuser origin-address auth-method
			local all       all     trust
			# ipv4
			host  all      all     127.0.0.1/32   trust
			# ipv6
			host all       all     ::1/128        trust
  '';
		initialScript = pkgs.writeText "init-sql-script" ''
				ALTER USER postgres WITH PASSWORD 'postgres';
				CREATE ROLE nico WITH LOGIN PASSWORT 'postgres';
				GRANT ALL PRIVILEGES ON DATABASE pb_app TO nico;
		'';
	};

}
