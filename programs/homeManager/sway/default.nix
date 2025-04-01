{
  swayConfig?(import ./swayConfigDefault.nix {}),
  outputConfig?{},
  extraConfig ? (import ./swayDefaultExtraConfig.nix),
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

    config = lib.recursiveUpdate swayConfig outputConfig;
    inherit extraConfig;

  };
}