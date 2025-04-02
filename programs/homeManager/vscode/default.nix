{
  pkgs,
	lib,
  ...
}:
let extensionSettings = (import ./default.extensions.nix {inherit pkgs;});
in
{

  programs.vscode = {
				enable = true;
				extensions = extensionSettings.extensions;

				userSettings = lib.recursiveUpdate {
      			
				}
				extensionSettings.userSettings;
		 };
}