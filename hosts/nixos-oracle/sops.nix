# Secrets from secrets/nixos-oracle.yaml (edit with `sops secrets/nixos-oracle.yaml`),
# decrypted at activation into /run/secrets/<name>. The server decrypts with its SSH host key
# (/etc/ssh/ssh_host_ed25519_key, the sops-nix default), whose age key is listed in .sops.yaml.
_: {
  sops = {
    defaultSopsFile = ../../secrets/nixos-oracle.yaml;

    # Checks that decryption works: `sudo cat /run/secrets/test`
    secrets.test = { };
  };
}
