{pkgs, profilename ? "nico"}:
let 
	packages = (import ./default.extensions.nix {inherit pkgs;});
in
{
    programs.firefox = {
		enable = true;
		profiles."nico" = {
			extensions = {
				inherit packages;
			};
		};
	};
}