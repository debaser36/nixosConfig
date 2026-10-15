{ pkgs, ... }:
let

  monitors = import ../hardware/monitorInfo.nix;
  # sway
  outputConfig = import ../hardware/swayMonitorSettings.nix {
    inherit (monitors) center_monitor;
  };
  inputConfig = import ../hardware/swayInputSettings.nix {
    initial_output = monitors.center_monitor.name;
  };
  extraConfig = import ../../../programs/desktop/nico/swayExtraConfig.nix;
  startupConfig = import ../../../programs/desktop/nico/swayStartup.nix;
  extraOptions = [ "--unsupported-gpu" ];

  packageList = import ./packageList.nix { inherit pkgs; };

  gitUser = {
    username = "debaser36";
    email = "nico.burkholder@web.de";
  };
in
{
  services.udiskie.enable = true;
  xdg.enable = true;
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
      inherit extraOptions;
      inherit pkgs;
    })

    # swayosd
    ../../../programs/homeManager/swayosd/default.nix

    # ssh
    ../../../programs/desktop/nico/ssh.home.nix
    ./ssh.home.nix

    # settings and programs shared by all desktop hosts
    ../../../programs/desktop/nico/home.nix
  ];
}
