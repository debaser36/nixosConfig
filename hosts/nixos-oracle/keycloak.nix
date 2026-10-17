# Keycloak at https://auth.unhalteproblem.de, the identity provider for the website's backend.
# Realms, clients and users are configured in the admin console and kept in the database; only
# the server itself is declared here. Keycloak listens on 127.0.0.1:8080 behind nginx.
{ config, pkgs, ... }:
let
  hostname = "auth.unhalteproblem.de";
  port = 8080;
in
{
  services = {
    keycloak = {
      enable = true;

      # Peer authentication over the Unix socket: the service runs as OS user "keycloak", which
      # PostgreSQL maps to the role of the same name, so there is no database password at all.
      database = {
        type = "postgresql";
        host = "/run/postgresql";
        name = "keycloak";
        username = "keycloak";
      };
      plugins = with pkgs.keycloak.plugins; [
        junixsocket-common
        junixsocket-native-common
      ];

      settings = {
        hostname = "https://${hostname}";
        http-enabled = true;
        http-host = "127.0.0.1";
        http-port = port;
        # nginx terminates TLS and passes the client's scheme and address in X-Forwarded-*
        proxy-headers = "xforwarded";
      };
    };

    # With a socket host the Keycloak module does not create the database, so it is set up here
    postgresql = {
      enable = true;
      ensureDatabases = [ "keycloak" ];
      ensureUsers = [
        {
          name = "keycloak";
          ensureDBOwnership = true;
        }
      ];
    };

    nginx.virtualHosts.${hostname} = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString port}";
        recommendedProxySettings = true;
        # Keycloak's responses carry large cookies and headers that overflow nginx's default 4k buffer
        extraConfig = ''
          proxy_buffer_size 128k;
          proxy_buffers 4 256k;
          proxy_busy_buffers_size 256k;
        '';
      };
    };
  };

  # Creates the temporary "admin" user in the master realm on the first start (ignored once the
  # realm has an admin). The password stays out of the Nix store: sops renders it into an
  # environment file that systemd reads as root.
  sops = {
    secrets.keycloak-admin-password = { };
    templates."keycloak-admin.env".content = ''
      KC_BOOTSTRAP_ADMIN_USERNAME=admin
      KC_BOOTSTRAP_ADMIN_PASSWORD=${config.sops.placeholder.keycloak-admin-password}
    '';
  };

  systemd.services.keycloak = {
    # postgresql.target includes postgresql-setup, which creates the role and database above
    after = [ "postgresql.target" ];
    requires = [ "postgresql.target" ];
    serviceConfig.EnvironmentFile = config.sops.templates."keycloak-admin.env".path;
  };
}
