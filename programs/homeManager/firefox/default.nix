{pkgs, profilename ? "nico"}:
let 
	packages = (import ./default.extensions.nix {inherit pkgs;});
in
{
    programs.firefox = {
		enable = true;
		profiles."nico" = {
			extensions = {
				force = true;
				inherit packages;
			};

			settings = {
				"extensions.autoDisableScopes" = 0;
			};
		};
	};
}