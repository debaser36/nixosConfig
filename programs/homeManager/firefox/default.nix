{pkgs, profilename ? "nico"}:
let 
	extensions = (import ./default.extensions.nix {inherit pkgs;});
in
{
    programs.firefox = {
		enable = true;
		profiles.profilename = {
			inherit extensions;
		};
	};
}