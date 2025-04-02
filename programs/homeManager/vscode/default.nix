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
				profiles.default.extensions = extensionSettings.extensions;

				profiles.default.userSettings = lib.recursiveUpdate {
							"editor.fontFamily" = "'Fira Code'";
							"editor.fontLigatures" = true;
							"editor.fontWeight" = "400";
      				"telemetry.enableTelemetry" = false;

							"explorer.sortOrder" = "type";
				}
				extensionSettings.userSettings;
		 };
}
