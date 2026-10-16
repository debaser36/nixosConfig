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
    # Pins unstable only for nixos-oracle, used by an overlay to pull individual
    # packages (currently just claude-code) that need to be newer than stable.
    # Separate from the desktops' `nixpkgs` so the two input sets stay independent.
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    # The website builds with its own pinned nixos-unstable (Node.js 26), so it shares no input
    # with the desktops. Deploy a new version with `nix flake update unhalteproblem-website`.
    unhalteproblem-website.url = "github:debaser36/unhalteproblem.de";
  };

  outputs =
    { self
    , nixpkgs
    , home-manager
    , nur
    , nix-vscode-extension
    , nixpkgs-stable
    , home-manager-stable
    , nur-stable
    , vscode-server
    , nixpkgs-unstable
    , unhalteproblem-website
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
      # `channel` picks the input set ("unstable" or "stable"), `modules` the optional flake modules,
      # `specialArgs` extra module arguments (e.g. flake inputs a host uses directly).
      mkHost =
        { host
        , system
        , channel
        , user
        , modules ? [ ]
        , specialArgs ? { }
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
          };
        in
        inputSet.nixpkgs.lib.nixosSystem {
          inherit system specialArgs;
          modules = [ ./hosts/${host}/configuration.nix ] ++ builtins.concatMap (m: flakeModules.${m}) modules;
        };

      # Repository tooling (formatter, linter, dev shell) comes from the desktop nixpkgs pin
      forAllSystems = f: nixpkgs.lib.genAttrs [ "x86_64-linux" "aarch64-linux" ] (system: f nixpkgs.legacyPackages.${system});
    in
    {
      # `nix fmt` formats the whole repository (or only the paths given)
      formatter = forAllSystems (pkgs: pkgs.writeShellApplication {
        name = "fmt";
        runtimeInputs = [ pkgs.nixpkgs-fmt ];
        text = ''nixpkgs-fmt "''${@:-.}"'';
      });

      # `nix develop`: the tools CI uses, plus the Nix language server
      devShells = forAllSystems (pkgs: {
        default = pkgs.mkShell { packages = with pkgs; [ nixpkgs-fmt statix nil ]; };
      });

      # Run by `nix flake check` (and CI) next to the evaluation of every host
      checks = forAllSystems (pkgs: {
        format = pkgs.runCommand "check-format" { nativeBuildInputs = [ pkgs.nixpkgs-fmt ]; } ''
          nixpkgs-fmt --check ${self} && touch $out
        '';
        statix = pkgs.runCommand "check-statix" { nativeBuildInputs = [ pkgs.statix ]; } ''
          cd ${self} && statix check . && touch $out
        '';
      });

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

        nixos-oracle = mkHost {
          host = "nixos-oracle";
          system = "aarch64-linux";
          channel = "stable";
          user = "nico";
          modules = [ "vscode-server" "home-manager" "nur" ];
          specialArgs = { inherit nixpkgs-unstable unhalteproblem-website; };
        };

        # nixos_manager: new hosts are inserted above this line
      };
    };
}
