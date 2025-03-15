{
	description = "Flake for Oracle Server hosting unhalteproblem.de";
	inputs={
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
		home-manager.url = "github:nix-community/home-manager/release-24.11";
		home-manager.inputs.nixpkgs.follows = "nixpkgs";
	  unhalteproblem-website.url = "github:debaser36/unhalteproblem.de/main";
	};
	outputs=inputs@{nixpkgs, home-manager, unhalteproblem-website, ...}:
	let
		vars = import ./vars.nix;
	in
	 {
	  packages.${vars.architeture}.website = unhalteproblem-website.packages.${vars.architeture}.default;
		nixosConfigurations = {
			nixos-oracle = nixpkgs.lib.nixosSystem {
				system=vars.architeture;
				specialArgs = {inherit unhalteproblem-website;};
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
