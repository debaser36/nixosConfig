{ pkgs
, lib
, ...
}:
let
  extensionSettings = import ./default.extensions.nix { inherit pkgs; };

  customCss = pkgs.writeText "pretty-ts-errors-hack.css" (import ./custom_css/pretty-ts-errors-hack.css.nix);

  # Inject the custom CSS into VS Code's workbench, then wrap the patched build in the FHS
  # environment. Patching vscode-fhs itself does nothing: it is only a wrapper with symlinks, and
  # its buildCommand never runs postInstall. VS Code may report the installation as corrupt because
  # the file checksum no longer matches.
  patchedVSCode = (pkgs.vscode.overrideAttrs (old: {
    postInstall = (old.postInstall or "") + ''
      substituteInPlace "$out/lib/vscode/resources/app/out/vs/code/electron-browser/workbench/workbench.html" \
        --replace-fail '</html>' "<style>$(cat ${customCss})</style></html>"
    '';
  })).fhs;

in
{
  programs.vscode = {
    enable = true;
    package = patchedVSCode;
    profiles.default.extensions = extensionSettings.extensions;
    profiles.default.userSettings = lib.recursiveUpdate
      {
        "editor.fontFamily" =
          "'Fira Code', 'Font Awesome 7 Free', 'Font Awesome 7 Brands', 'Font Awesome 7 Free Solid'";
        "editor.fontLigatures" = true;
        "remote.SSH.connectTimeout" = 60;
        # TODO: use a more dynamic way to get the user's home directory instead of hardcoding it
        "remote.SSH.configFile" = "/home/nico/.ssh/config";
        "remote.SSH.useLocalServer" = false;
        "remote.SSH.remotePlatform" = { "unhalteproblem.de" = "linux"; };
        "editor.fontWeight" = "400";
        "telemetry.enableTelemetry" = false;
        "explorer.sortOrder" = "type";
        "explorer.confirmDelete" = false;
        "terminal.integrated.sendKeybindingsToShell" = true;
      }
      extensionSettings.userSettings;
  };
}
