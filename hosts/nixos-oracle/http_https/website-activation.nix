{ pkgs, ... }:
{
  system.activationScripts = {
    deployWebsite = {
      text = ''
        # Create website directory
        mkdir -p /var/www/seite.de

        # Copy built website to the directory
        cp -r ${(import ./website-build.nix {inherit pkgs;})}/* /var/www/unhalteproblem.de/

        # Set correct permissions
        chown -R nginx:nginx /var/www/seite.de
      '';
    };
  };


}
