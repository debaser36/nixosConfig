{
  description = "My very first nixos config flake :))";
  #author="nico@nixos";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-vscode-extension.url = "github:nix-community/nix-vscode-extensions";
  };
  outputs =
    inputs@{ self
    , nixpkgs
    , home-manager
    , nur
    , nix-vscode-extension
    , ...
    }: {
      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit nix-vscode-extension; };
          modules = [
            ./system/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.nico = import ./nico/home.nix;
              };
            }
            nur.modules.nixos.default
          ];
        };
      };
    };
}
