{lib}:
{
    services.postgresql = {
    enable = true;
    enableTCPIP = true;
    authentication = lib.mkOverride 10 ''
      local all all trust
      host all all 127.0.0.1/32 md5     
      host all all ::1/128 md5              # IPv6 localhost
      host all all 141.23.223.55/32 md5
    '';
  };
}