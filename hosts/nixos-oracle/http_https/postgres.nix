{ lib, ... }:
let
  # The only remote address allowed to reach PostgreSQL
  remoteClient = "141.23.223.55";
in
{
  services.postgresql = {
    enable = true;
    enableTCPIP = true;
    authentication = lib.mkOverride 10 ''
      # local socket: OS user = database user (sudo -u postgres psql)
      local all all peer
      host all all 127.0.0.1/32 scram-sha-256
      host all all ::1/128 scram-sha-256
      host all all ${remoteClient}/32 scram-sha-256
    '';
  };

  # Daily pg_dumpall of every database to /var/backup/postgresql (keeps the previous dump as .prev)
  services.postgresqlBackup = {
    enable = true;
    compression = "zstd";
    compressionLevel = 10;
  };

  # 5432 is not in allowedTCPPorts; only remoteClient may connect from outside
  networking.firewall.extraCommands = ''
    iptables -A nixos-fw -p tcp -s ${remoteClient} --dport 5432 -j nixos-fw-accept
  '';
}
