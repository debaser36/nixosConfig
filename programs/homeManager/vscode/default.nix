{
  	pkgs,
	lib,
  	...
}:
let extensionSettings = (import ./default.extensions.nix {inherit pkgs;});
homeCssImportFile = extensionSettings.home.file."pretty-ts-errors-hacks.css";
in
{

  home.file."pretty-ts-errors-hacks.css" = homeCssImportFile; # nixos readonly file system denies injecting css into vscode
  programs.vscode = {
				enable = true;
				profiles.default.extensions = extensionSettings.extensions;
				package=pkgs.vscode-fhs;
				profiles.default.userSettings = lib.recursiveUpdate {

						/* "terminal.integrated.profiles.linux" =
						{
							"kitty"= {
								"path" = "/nix/store/lfl14ziff7iwrbawfrss4ls4sfabn1xp-kitty-0.40.1/bin/kitty";
							};
						}; */

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
