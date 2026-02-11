{ config, ... }:
{
    services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    virtualHosts."unhalteproblem.de" = {
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
  };
}