{ pkgs
, lib
, ...
}:
let
  extensionSettings = import ./default.extensions.nix { inherit pkgs; };

  # Import the raw CSS from the .nix file
  customCss = import ./custom_css/pretty-ts-errors-hack.css.nix;

  # Inject custom CSS into the built VSCode
  patchedVSCode = pkgs.vscode-fhs.overrideAttrs (old: {
    postInstall = ''
      workbenchFile=$(find $out -name "workbench.html" | head -n 1)
      if [ -n "$workbenchFile" ]; then
        echo "Injecting custom CSS into $workbenchFile"
        sed -i '/<\/html>/i <style>'"${customCss}"'</style>' "$workbenchFile"
      fi
    '';
  });

in
{
  # Declare your home file (makes the CSS available in user’s home directory)
  # home.file."pretty-ts-errors-hacks.css" = homeCssImportFile;

  programs.vscode = {
    enable = true;
    package = patchedVSCode;
    profiles.default.extensions = extensionSettings.extensions;
    profiles.default.userSettings = lib.recursiveUpdate
      {
        "editor.fontFamily" = "'Fira Code' 'Font Awesome 7 Free' 'Font Awesome 7 Brands' 'Font Awesome 7 Free Solid'";
        "editor.fontLigatures" = true;
        "editor.fontWeight" = "400";
        "telemetry.enableTelemetry" = false;
        "explorer.sortOrder" = "type";
        "explorer.confirmDelete" = false;
      }
      extensionSettings.userSettings;
  };
}
