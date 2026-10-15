{ pkgs, ... }:
let

  monitors = import ../hardware/monitorInfo.nix;
  outputConfig = import ../hardware/swayMonitorSettings.nix {
    inherit (monitors) left_monitor;
    inherit (monitors) center_monitor;
    inherit (monitors) right_monitor;
  };
  inputConfig = import ../hardware/swayInputSettings.nix {
    initial_output = monitors.center_monitor.name;
  };
  extraConfig = import ./swayExtraConfig.nix;
  startupConfig = import ./swayStartup.nix;

  packageList = import ./packageList.nix { inherit pkgs; };

  gitUser = {
    username = "debaser36";
    email = "n.burkholder@tu-berlin.de";
  };
in
{
  home = {
    packages = packageList;

    # ## DONT CHANGE THIS LINE!
    stateVersion = "25.05";
  };

  _module.args = {
    user = gitUser;
  };

  # Packages configurable via home manager config settings
  imports = [
    # sway
    (import ../../../programs/homeManager/sway/default.nix {
      inherit inputConfig;
      inherit outputConfig;
      inherit extraConfig;
      inherit startupConfig;
      inherit pkgs;
    })

    # ssh
    ../../../programs/desktop/nico/ssh.home.nix

    # Discord
    ../../../programs/homeManager/discord/default.nix

    # Go
    ../../../programs/homeManager/go/default.nix

    # settings and programs shared by all desktop hosts
    ../../../programs/desktop/nico/home.nix

    # texlive
    ../../../programs/homeManager/texlive/default.nix

    # lutris
    ../../../programs/homeManager/lutris/default.nix

    # texlive
    ../../../programs/homeManager/texlive/default.nix
  ];
}
