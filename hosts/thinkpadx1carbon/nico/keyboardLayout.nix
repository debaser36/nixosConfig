{ lib, pkgs, ... }:
let
  # Full keymaps for sway's xkb_file; includes resolve against xkeyboard-config at load time
  mkKeymap = name: { layout, keycodes ? "evdev+aliases(qwerty)", types ? "", symbols ? "" }:
    pkgs.writeText "${name}.xkb" ''
      xkb_keymap {
        xkb_keycodes { include "${keycodes}" };
        xkb_types {
          include "complete"
          ${types}
        };
        xkb_compat { include "complete" };
        xkb_symbols {
          include "pc+${layout}+inet(evdev)"
          ${symbols}
        };
        xkb_geometry { include "pc(pc105)" };
      };
    '';

  keymaps = {
    "US Standard" = mkKeymap "us-standard" { layout = "us"; };
    # Like US Standard, but Ctrl+[a o u s] gives [ä ö ü ß] and Ctrl+Shift the capitals;
    # Ctrl is consumed, so programs receive the plain character
    "US Custom" = mkKeymap "us-custom" {
      layout = "us";
      types = ''
        type "CTRL_UMLAUT" {
          modifiers = Shift + Lock + Control;
          map[Shift] = Level2;
          map[Lock] = Level2;
          map[Control] = Level3;
          map[Shift+Control] = Level4;
          map[Lock+Control] = Level4;
          map[Lock+Shift+Control] = Level3;
          level_name[Level1] = "Base";
          level_name[Level2] = "Caps";
          level_name[Level3] = "Ctrl";
          level_name[Level4] = "Ctrl Caps";
        };
      '';
      symbols = ''
        key <AC01> { type = "CTRL_UMLAUT", [ a, A, adiaeresis, Adiaeresis ] };
        key <AD09> { type = "CTRL_UMLAUT", [ o, O, odiaeresis, Odiaeresis ] };
        key <AD07> { type = "CTRL_UMLAUT", [ u, U, udiaeresis, Udiaeresis ] };
        key <AC02> { type = "CTRL_UMLAUT", [ s, S, ssharp, U1E9E ] };
      '';
    };
    "German Standard" = mkKeymap "de-standard" {
      layout = "de";
      keycodes = "evdev+aliases(qwertz)";
    };
  };

  changeKeyboardLayout = pkgs.writeShellApplication {
    name = "changeKeyboardLayout";
    runtimeInputs = [ pkgs.gum pkgs.sway ];
    text = ''
      state="''${XDG_STATE_HOME:-$HOME/.local/state}/keyboard-layout"
      declare -A keymaps=(
        ${lib.concatStringsSep "\n  " (lib.mapAttrsToList (n: f: ''["${n}"]="${f}"'') keymaps)}
      )

      current="US Standard"
      if [ -r "$state" ] && [ -n "''${keymaps["$(cat "$state")"]:-}" ]; then
        current="$(cat "$state")"
      fi

      if [ "''${1:-}" = "--apply" ]; then
        # Called by sway on startup and reload: reapply the saved layout
        choice="$current"
      else
        choice="$(gum choose --header "Choose keyboard layout:" --selected "$current" \
          "US Standard" "US Custom" "German Standard")" || exit 0
      fi

      swaymsg -q input type:keyboard xkb_file "''${keymaps["$choice"]}"
      mkdir -p "$(dirname "$state")"
      echo "$choice" > "$state"
    '';
  };
in
{
  home.packages = [ changeKeyboardLayout ];

  wayland.windowManager.sway.config.startup = [
    { command = "changeKeyboardLayout --apply"; always = true; }
  ];
}
