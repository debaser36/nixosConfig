{ ... }:
{
  services.keycloak = {
    enable = true;

    database = {
      type = "postgresql";
      username = "keycloak";
      passwordFile = "/var/secrets/keycloak_psql_pass";
    };

    settings = {
      hostname = "unhalteproblem.de";
      http-relative-path = "/keycloak";
      http-port = 38080;
      proxy-headers = "xforwarded";
      http-enabled = true;
    };
    initialAdminPassword = "admin";
  };
}
