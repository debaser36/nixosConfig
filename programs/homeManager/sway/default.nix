{
  swayConfig?(import ./swayConfigDefault.nix {}),
  outputConfig?{},
  inputConfig?{},
  extraConfig ? (import ./swayDefaultExtraConfig.nix),
  startupArray ? [],
  pkgs,
  ...
}:
let
 lib = pkgs.lib;
in
{
  home.sessionVariables = {
			WLR_RENDERER="gles2";
			WLR_RENDERER_ALLOW_SOFTWARE="1";
	};
  wayland.windowManager.sway={
    enable=true;
    checkConfig=false;
    wrapperFeatures.gtk = true;
    startup = startupArray;

    config = lib.recursiveUpdate (lib.recursiveUpdate swayConfig outputConfig) inputConfig;
    inherit extraConfig;

  };
}