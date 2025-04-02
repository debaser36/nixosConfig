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
							"editor.fontFamily" = "'Fira Code'";
							"editor.fontLigatures" = true;
							"editor.fontWeight" = "400";
      				"telemetry.enableTelemetry" = false;
				}
				extensionSettings.userSettings;
		 };
}
