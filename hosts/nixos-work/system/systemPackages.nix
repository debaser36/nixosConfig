{ pkgs }:
let
  custom-sddm-astronaut = pkgs.sddm-astronaut.override {
    embeddedTheme = "pixel_sakura";
  };
in
{
  #packages needed for flakes to work
  environment.systemPackages = with pkgs; with pkgs.kdePackages;
    [
      # sddm theme
      custom-sddm-astronaut
      qtbase
      qtmultimedia
      qttools
      qtvirtualkeyboard
      qtsvg

      # needed base programs
      git
      vim
      wget
      wlroots
      xorg.xrandr
      procps
    ];

  # sway related stuff
  programs.sway.enable = true;
  programs.fish.enable = true;

  services = {
    xserver.enable = true;
    displayManager = {
      defaultSession = "sway";
      sddm = {
        enable = true;
        package = pkgs.kdePackages.sddm;
        wayland = {
          enable = true;
          compositor = "weston";
        };
        theme = "sddm-astronaut-theme";
        autoNumlock = true;
        enableHidpi = true;
        settings = {
          Theme = {
            Current = "sddm-astronaut-theme";
            CursorTheme = "Bibata-Modern-Ice";
            CursorSize = 24;
          };
        };
        extraPackages = [ custom-sddm-astronaut ];
      };
    };

    postgresql = {
      enable = true;
      ensureDatabases = [ "pb_app" ];
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
  };

}
