{ pkgs, ... }:
{
  users = {
    defaultUserShell = pkgs.fish;
    users.nico = {
      isNormalUser = true;
      description = "Default user for personal use of this system!";
      extraGroups = [ "networkmanager" "wheel" "video" "storage" "docker" ];
      home = "/home/nico";
      shell = pkgs.fish;
    };
  };
}
