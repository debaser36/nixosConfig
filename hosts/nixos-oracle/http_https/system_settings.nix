#nginx setup -- just inherit everything
_:
{
  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
  };

  environment.etc."keycloak-database-pass".txt = "PWD";
  services.keycloak = {
    enable = true;
    settings = {
      hostname = "localhost/keycloak";
      http-enabled = true;
      hostname-strict-https = false;
    };
    database.passwordFile = "/etc/keycloak-database-pass";
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
  };
  security.acme = {
    acceptTerms = true;
    defaults.group = "nginx";
    defaults.email = "admin@unhalteproblem.de";
  };

  users.users.nginx.extraGroups = [ "acme" ];
}
