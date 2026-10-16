{
  hostname = "nixos-oracle";
  system = "aarch64-linux";

  default_user = {
    username = "nico";
    home = "/home/nico";
  };

  public_sshKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN5mbciq/dANNKJOFDgIBlMmTX3q8XUOwP05DsjIGUXM unhalteProblemPrivateKey";
  locale = "de_DE.UTF-8";
  timezone = "Europe/Berlin";

}
