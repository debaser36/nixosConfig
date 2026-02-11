_:
{
  security.acme = {
    acceptTerms = true;
    defaults.group = "nginx";
    defaults.email = "admin@unhalteproblem.de";
  };
  users.users.nginx.extraGroups = [ "acme" ];
}
