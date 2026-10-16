{ pkgs, unhalteproblem-website, ... }:
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
      # Static build of github:debaser36/unhalteproblem.de, served straight from the Nix store
      root = unhalteproblem-website.packages.${pkgs.stdenv.hostPlatform.system}.default;
      locations."/" = {
        index = "index.html";
        extraConfig = ''
          				try_files $uri /index.html;
          			'';
      };
    };
  };
}
