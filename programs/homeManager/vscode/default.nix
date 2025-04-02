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
				enableUpdateCheck = false;
				extensions = extensionSettings.extensions;

				userSettings = lib.recursiveUpdate {
      			"telemetry.enableTelemetry" = false;
				}
				extensionSettings.userSettings;
		 };
}