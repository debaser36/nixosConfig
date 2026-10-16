_: {
  security.acme = {
    acceptTerms = true;
    # Certificates and challenge directories belong to group nginx, so nginx needs no acme group
    defaults.group = "nginx";
    defaults.email = "admin@unhalteproblem.de";
  };
}
