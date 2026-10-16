# Secrets from secrets/thinkpadx1carbon.yaml (edit with `sops secrets/thinkpadx1carbon.yaml`),
# decrypted at activation into /run/secrets/<name>.
{ sops-nix, ... }:
{
  imports = [ sops-nix.nixosModules.sops ];

  sops = {
    defaultSopsFile = ../../../secrets/thinkpadx1carbon.yaml;
    # Machine key, created once by hand (no sshd, so there is no SSH host key to use).
    # Its public key is listed in .sops.yaml.
    age.keyFile = "/var/lib/sops-nix/key.txt";

    # Checks that decryption works: `sudo cat /run/secrets/test`
    secrets.test = { };
  };
}
