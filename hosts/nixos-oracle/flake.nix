{
  description = "Flake for Oracle Server hosting unhalteproblem.de";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    #unhalteproblem-website.url = "github:debaser36/unhalteproblem.de/main";
  };
  outputs = { nixpkgs, home-manager, ... }:
    let
      vars = import ./vars.nix;
    in
    {
      #packages.${vars.architeture}.website = unhalteproblem-website.packages.${vars.architeture}.default;
      nixosConfigurations = {
        nixos-oracle = nixpkgs.lib.nixosSystem {
          system = vars.architeture;
          modules = [
            {
              environment.etc."website-build.nix".source = ./http_https/website-build.nix;
            }
            ./configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.nico = import ./home_manager/home.nix;
              };
            }
          ];
        };
      };
    };
}
