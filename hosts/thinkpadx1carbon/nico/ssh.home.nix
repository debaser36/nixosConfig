_: {
  programs.ssh.settings."github.com" = {
    hostname = "ssh.github.com";
    user = "git";
    port = 443;
  };
}
