{ config, ... }:
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
  services.postgresql.enable = true;
  environment.etc."keycloak_psql_pass".text = "PWD";
  services.keycloak = {
    enable = true;

    database = {
      type = "postgresql";
      createLocally = true;

      username = "keycloak";
      passwordFile = "/etc/keycloak_psql_pass";
    };

    settings = {
      hostname = "unhalteproblem.de";
      http-relative-path = "/keycloak";
      http-port = 38080;
      proxy-headers = "xforwarded";
      http-enabled = true;
    };
  };
  security.acme = {
    acceptTerms = true;
    defaults.group = "nginx";
    defaults.email = "admin@unhalteproblem.de";
  };

  users.users.nginx.extraGroups = [ "acme" ];
}
