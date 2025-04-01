{pkgs, profilename ? "nico"}:
{
    programs.firefox = {
		enable = true;
		profiles.profilename = {
			#extensions.packages
		};
	};
}