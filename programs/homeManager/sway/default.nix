{ swayConfig ? (import ./swayConfigDefault.nix { })
, outputConfig ? { }
, inputConfig ? { }
, extraConfig ? (import ./swayDefaultExtraConfig.nix)
, startupConfig ? {
    startup = [ ];
  }
, extraOptions ? [ ]
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
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";
  };
  wayland.windowManager.sway = {
    enable = true;
    checkConfig = false;
    wrapperFeatures.gtk = true;

    config = lib.recursiveUpdate (lib.recursiveUpdate (lib.recursiveUpdate swayConfig outputConfig) inputConfig) startupConfig;
    inherit extraConfig;
    inherit extraOptions;

  };
}
