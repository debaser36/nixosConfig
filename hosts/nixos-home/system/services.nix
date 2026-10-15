{ pkgs, ... }:
{
  services = {
    xserver = {
      wacom.enable = true;
      videoDrivers = [ "modesetting" ];
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
