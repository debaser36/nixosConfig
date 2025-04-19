{
  	pkgs,
	lib,
  	...
}:
let extensionSettings = (import ./default.extensions.nix {inherit pkgs;});
# homeCssImportFile = extensionSettings.home.file."pretty-ts-errors-hacks.css";
in
{

  #home.file."pretty-ts-errors-hacks.css" = homeCssImportFile; # nixos readonly file system denies injecting css into vscode
  programs.vscode = {
				enable = true;
				profiles.default.extensions = extensionSettings.extensions;

				profiles.default.userSettings = lib.recursiveUpdate {
							"editor.fontFamily" = "'Fira Code'";
							"editor.fontLigatures" = true;
							"editor.fontWeight" = "400";
      				"telemetry.enableTelemetry" = false;

							"explorer.sortOrder" = "type";
							"explorer.confirmDelete" = false;
				}
				extensionSettings.userSettings;
		 };
}
