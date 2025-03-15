#nginx setup -- just inherit everything
{config, pkgs, unhalteproblem-website, ...}:
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
		root = "${unhalteproblem-website.packages.${pkgs.system}.default}";
		locations."/" = {	
			index = "index.html";
			extraConfig = ''
				try_files $uri $uri/ =404;
			'';
		};
	};
  security.acme = {
  	acceptTerms = true;
	  defaults.group = "nginx";
	  defaults.email = "admin@unhalteproblem.de";
  };
  
  users.users.nginx.extraGroups = ["acme"];
}
