{
	description = "Flake for Oracle Server hosting unhalteproblem.de";
	inputs={
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
		home-manager.url = "github:nix-community/home-manager/release-24.11";
		home-manager.inputs.nixpkgs.follows = "nixpkgs";
	};
	outputs=inputs@{nixpkgs, home-manager, ...}:
	let
		vars = import ./vars.nix;
	in
	 {
		nixosConfigurations = {
			nixos-oracle = nixpkgs.lib.nixosSystem {
				system=vars.architeture;
				modules = [
						./configuration.nix
						home-manager.nixosModules.home-manager {
						home-manager.useGlobalPkgs = true;
						home-manager.useUserPackages = true;
						home-manager.users.nico = import ./home_manager/home.nix;	
					}
				];
			};
		};
	};
}
