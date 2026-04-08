_:{
  security = {
    polkit.enable = true;
    rtkit.enable = true;
  };
  systemd.services.dlm.wantedBy = [ "multi-user.target" ];
}