{ swayConfig ? (import ./swayConfigDefault.nix { })
, outputConfig ? { }
, inputConfig ? { }
, extraConfig ? (import ./swayDefaultExtraConfig.nix)
, startupConfig ? {
    startup = [ ];
  }
, pkgs
, ...
}:
let
  inherit (pkgs) lib;
in
{
  home.sessionVariables = {
    WLR_RENDERER = "gles2";
    WLR_RENDERER_ALLOW_SOFTWARE = "1";
  };
  wayland.windowManager.sway = {
    enable = true;
    checkConfig = false;
    wrapperFeatures.gtk = true;

    config = lib.recursiveUpdate
      (lib.recursiveUpdate
        (lib.recursiveUpdate swayConfig outputConfig)
        inputConfig)
      startupConfig;
    inherit extraConfig;

  };
}
