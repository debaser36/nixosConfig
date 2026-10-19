# Backend of github:debaser36/unhalteproblem.de (packages.backend-image), run as a podman
# container on 127.0.0.1 by the website flake's own module. nginx proxies
# https://unhalteproblem.de/api/ to it. Deployed together with the website by
# `nix flake update unhalteproblem-website`.
#
# Database: peer authentication over the Unix socket, like Keycloak, so there is no database
# password. The container runs as the host user "unhalteproblem" (rootful podman, so the uid
# inside is the uid on the host) and gets /run/postgresql mounted; PostgreSQL maps that OS user
# to the role of the same name. The backend creates its tables itself at startup.
#
# Secrets: the Keycloak client secret is `unhalteproblem-oidc-client-secret` in
# secrets/nixos-oracle.yaml. sops-nix renders it into a root-only env file at activation, which
# podman reads on the host when the container starts; only the placeholder reaches the Nix store.
{ config, unhalteproblem-website, ... }:
let
  name = "unhalteproblem";
  # Fixed, because the image has no /etc/passwd and podman needs the number. Between the ids
  # nixpkgs reserves (up to ~330) and the range NixOS allocates system users from (400-999).
  id = 350;
in
{
  imports = [ unhalteproblem-website.nixosModules.backend ];

  services = {
    unhalteproblem-backend = {
      enable = true;
      nginx.virtualHost = "unhalteproblem.de";
      # A host starting with / is the directory of the Postgres socket
      environment = {
        POSTGRES_HOST = "/run/postgresql";
        SMTP_HOST = "smtp.zoho.eu"; # your provider
        SMTP_FROM = "Backend <backend@unhalteproblem.de>";
      };
      environmentFiles = [ config.sops.templates."unhalteproblem-backend.env".path ];
    };

    postgresql = {
      enable = true;
      ensureDatabases = [ name ];
      ensureUsers = [
        {
          inherit name;
          ensureDBOwnership = true;
        }
      ];
    };
  };

  sops = {
    secrets = {
      unhalteproblem-oidc-client-secret = { };
      unhalteproblem-oidc-client-secret = { };
      unhalteproblem-keycloak-admin-client-secret = { };
      unhalteproblem-smtp-user = { };
      unhalteproblem-smtp-password = { };
      unhalteproblem-contact-mail-to = { };
    };
    templates."unhalteproblem-backend.env" = {
      content = ''
        OIDC_CLIENT_SECRET=${config.sops.placeholder.unhalteproblem-oidc-client-secret}
        KEYCLOAK_ADMIN_CLIENT_SECRET=${config.sops.placeholder.unhalteproblem-keycloak-admin-client-secret}
        SMTP_USER=${config.sops.placeholder.unhalteproblem-smtp-user}
        SMTP_PASSWORD=${config.sops.placeholder.unhalteproblem-smtp-password}
        CONTACT_MAIL_TO=${config.sops.placeholder.unhalteproblem-contact-mail-to}'';
      restartUnits = [ "podman-unhalteproblem-backend.service" ];
    };
  };

  users = {
    users.${name} = {
      uid = id;
      group = name;
      isSystemUser = true;
    };
    groups.${name}.gid = id;
  };

  virtualisation.oci-containers.containers.unhalteproblem-backend = {
    user = "${toString id}:${toString id}";
    volumes = [ "/run/postgresql:/run/postgresql:ro" ];
  };

  systemd.services.podman-unhalteproblem-backend = {
    # postgresql.target includes postgresql-setup, which creates the role and database above
    after = [ "postgresql.target" ];
    requires = [ "postgresql.target" ];
  };
}
