{ config, lib, ... }:
{
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
        				try_files $uri /index.html;
        			'';
    };
    locations."/keycloak/" = {
      proxyPass = "http://localhost:${toString config.services.keycloak.settings.http-port}/keycloak/";
    };
  };
  services.postgresql = {
    enable = true;
    enableTCPIP = true;
    authentication = lib.mkOverride 10 ''
      local all all trust
      host all all 127.0.0.1/32 md5     
      host all all ::1/128 md5              # IPv6 localhost
      host all all 141.23.223.55/32 md5
    '';
  };
  services.keycloak = {
    enable = true;

    database = {
      type = "postgresql";
      username = "keycloak";
      passwordFile = "/var/secrets/keycloak_psql_pass";
    };

    settings = {
      hostname = "unhalteproblem.de";
      http-relative-path = "/keycloak";
      http-port = 38080;
      proxy-headers = "xforwarded";
      http-enabled = true;
    };
    initialAdminPassword = "admin";
  };
  security.acme = {
    acceptTerms = true;
    defaults.group = "nginx";
    defaults.email = "admin@unhalteproblem.de";
  };

  users.users.nginx.extraGroups = [ "acme" ];
}
