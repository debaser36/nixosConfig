# Backend of github:debaser36/unhalteproblem.de (packages.backend-image), run as a podman
# container on 127.0.0.1 by the website flake's own module. nginx proxies
# https://unhalteproblem.de/api/ to it. Deployed together with the website by
# `nix flake update unhalteproblem-website`.
{ unhalteproblem-website, ... }:
{
  imports = [ unhalteproblem-website.nixosModules.backend ];

  services.unhalteproblem-backend = {
    enable = true;
    nginx.virtualHost = "unhalteproblem.de";
  };
}
