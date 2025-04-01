{
	description = "My very first nixos config flake :))";
	#author="nico@nixos";
	inputs={
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
		home-manager.url = "github:nix-community/home-manager/release-24.11";
		home-manager.inputs.nixpkgs.follows = "nixpkgs";
		nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
	};
	outputs={nixpkgs, home-manager, nur, ...}: {
		nixosConfigurations = {
			nixos=nixpkgs.lib.nixosSystem {
				system="x86_64-linux";
				modules = [
					./configuration.nix
					home-manager.nixosModules.home-manager{
						home-manager.useGlobalPkgs = true;
						home-manager.useUserPackages = true;
						home-manager.users.nico = import ./nico/home.nix;	
					}
					#./greetd.nix
					nur.modules.nixos.default
				];
			};
		};
	};
}
