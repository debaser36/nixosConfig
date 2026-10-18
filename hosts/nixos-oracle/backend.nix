# Backend of github:debaser36/unhalteproblem.de (packages.backend-image), run as a podman
# container on 127.0.0.1 by the website flake's own module. nginx proxies
# https://unhalteproblem.de/api/ to it. Deployed together with the website by
# `nix flake update unhalteproblem-website`.
#
# Database: peer authentication over the Unix socket, like Keycloak, so there is no database
# password. The container runs as the host user "unhalteproblem" (rootful podman, so the uid
# inside is the uid on the host) and gets /run/postgresql mounted; PostgreSQL maps that OS user
# to the role of the same name. The backend creates its tables itself at startup.
{ unhalteproblem-website, ... }:
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
      environment.POSTGRES_HOST = "/run/postgresql";
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
