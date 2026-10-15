{
  description = "NixOS configurations for all hosts";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-vscode-extension.url = "github:nix-community/nix-vscode-extensions";

    # nixos-oracle stays on the stable release
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.11";
    home-manager-stable = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    nur-stable = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    vscode-server.url = "github:nix-community/nixos-vscode-server";
    compose2nix = {
      url = "github:aksiksi/compose2nix";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
  };

  outputs =
    { nixpkgs
    , home-manager
    , nur
    , nix-vscode-extension
    , nixpkgs-stable
    , home-manager-stable
    , nur-stable
    , vscode-server
    , compose2nix
    , ...
    }:
    let
      mkDesktop =
        { host
        , homeManagerBackups ? false
        }:
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit nix-vscode-extension; };
          modules = [
            ./hosts/${host}/system/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.nico = import ./hosts/${host}/nico/home.nix;
              } // nixpkgs.lib.optionalAttrs homeManagerBackups {
                backupFileExtension = "backup";
              };
            }
            nur.modules.nixos.default
          ];
        };

      # Generic builder for hosts created with programs/tools/nixos_manager.
      # `channel` picks the input set ("unstable" or "stable"), `modules` the optional flake modules.
      mkHost =
        { host
        , system
        , channel
        , user
        , modules ? [ ]
        }:
        let
          inputSet = {
            unstable = { inherit nixpkgs home-manager nur; };
            stable = {
              nixpkgs = nixpkgs-stable;
              home-manager = home-manager-stable;
              nur = nur-stable;
            };
          }.${channel};
          flakeModules = {
            home-manager = [
              inputSet.home-manager.nixosModules.home-manager
              {
                home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  users.${user} = import ./hosts/${host}/home.nix;
                };
              }
            ];
            nur = [ inputSet.nur.modules.nixos.default ];
            nix-vscode-extension = [{ nixpkgs.overlays = [ nix-vscode-extension.overlays.default ]; }];
            vscode-server = [
              vscode-server.nixosModules.default
              { services.vscode-server.enable = true; }
            ];
            compose2nix = [{ environment.systemPackages = [ compose2nix.packages.${system}.default ]; }];
          };
        in
        inputSet.nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [ ./hosts/${host}/configuration.nix ] ++ builtins.concatMap (m: flakeModules.${m}) modules;
        };

      oracleVars = import ./hosts/nixos-oracle/vars.nix;
    in
    {
      nixosConfigurations = {
        thinkpadx1carbon = mkDesktop {
          host = "thinkpadx1carbon";
          homeManagerBackups = true;
        };
        nixos-asus-laptop = mkDesktop {
          host = "nixos-asus-laptop";
          homeManagerBackups = true;
        };
        nixos-home = mkDesktop { host = "nixos-home"; };
        nixos-work = mkDesktop { host = "nixos-work"; };

        nixos-oracle = nixpkgs-stable.lib.nixosSystem {
          system = oracleVars.architeture;
          modules = [
            vscode-server.nixosModules.default
            { services.vscode-server.enable = true; }
            {
              environment.etc."website-build.nix".source = ./hosts/nixos-oracle/http_https/website-build.nix;
            }
            ./hosts/nixos-oracle/configuration.nix
            { _module.args.compose2nix = compose2nix; }
            home-manager-stable.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.nico = import ./hosts/nixos-oracle/home_manager/home.nix;
              };
            }
            nur-stable.modules.nixos.default
          ];
        };

        # nixos_manager: new hosts are inserted above this line
      };
    };
}
