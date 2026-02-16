{ lib, ... }:
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      "unhalteproblem.de" = {
        addKeysToAgent = "yes";
        hostname = "unhalteproblem.de";
        identityFile = "/home/nico/keys_and_secrets/private/ssh/unhalteproblem.key";
        user = "nico";
      };
    };
  };
  home.file.".ssh/config".force = true;
  home.activation = {
    fixSSHPermissions = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
      run install -d -m 0700 "$HOME/.ssh"
      if [ -L "$HOME/.ssh/config" ]; then
        src="$(readlink -f "$HOME/.ssh/config")"
        run rm -f "$HOME/.ssh/config"
        run install -m 0600 "$src" "$HOME/.ssh/config"
      fi
    '';
  };
}
