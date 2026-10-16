# Sway with the shared defaults (swayConfigDefault.nix). Hosts describe their monitors in
# `my.sway.monitors`; keybindings, startup programs, inputs and extra options are set directly
# through the Home Manager options under `wayland.windowManager.sway`.
{ config, lib, ... }:
let
  inherit (lib) mkOption types;
  cfg = config.my.sway;

  monitorType = types.submodule {
    options = {
      name = mkOption {
        type = types.str;
        description = "Output name as sway reports it (swaymsg -t get_outputs), e.g. eDP-1.";
      };
      width = mkOption { type = types.int; };
      height = mkOption { type = types.int; };
      refresh_rate = mkOption { type = types.number; };
      rotation = mkOption {
        type = types.str;
        default = "normal";
        description = "Sway output transform: normal, 90, 180 or 270.";
      };
    };
  };

  rotated = m: m.rotation == "90" || m.rotation == "270";
  effectiveWidth = m: if rotated m then m.height else m.width;
  effectiveHeight = m: if rotated m then m.width else m.height;

  # Monitors are placed side by side from left to right, each vertically centred on the first one.
  outputs =
    let
      firstHeight = effectiveHeight (lib.head cfg.monitors);
      place = acc: m: {
        x = acc.x + effectiveWidth m;
        outputs = acc.outputs // {
          ${m.name} = {
            mode = "${toString m.width}x${toString m.height}@${toString m.refresh_rate}Hz";
            position = "${toString acc.x},${toString ((firstHeight - effectiveHeight m) / 2)}";
            transform = m.rotation;
          };
        };
      };
    in
    (lib.foldl' place { x = 0; outputs = { }; } cfg.monitors).outputs;
in
{
  options.my.sway = {
    monitors = mkOption {
      type = types.listOf monitorType;
      default = [ ];
      description = "Monitors from left to right.";
    };
    primaryOutput = mkOption {
      type = types.str;
      default = (lib.head cfg.monitors).name;
      defaultText = lib.literalExpression "(lib.head config.my.sway.monitors).name";
      description = "Output that devices such as the drawing tablet are mapped to.";
    };
  };

  config = {
    home.sessionVariables = {
      WLR_RENDERER = "gles2";
      WLR_RENDERER_ALLOW_SOFTWARE = "1";
    };
    wayland.windowManager.sway = {
      enable = true;
      checkConfig = false;
      wrapperFeatures.gtk = true;

      config = lib.mkMerge [
        (import ./swayConfigDefault.nix { })
        { output = lib.mkIf (cfg.monitors != [ ]) outputs; }
      ];
    };
  };
}
