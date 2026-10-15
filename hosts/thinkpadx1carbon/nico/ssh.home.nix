_: {
  programs.ssh.settings = {
    "github.com" = {
      hostname = "ssh.github.com";
      user = "git";
      port = 443;
    };
    # Extends the shared entry: many networks block outgoing port 22, nixos-oracle also listens on 2222
    "unhalteproblem.de".port = 2222;
  };
}
