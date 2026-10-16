_: {
  #-------------Bash settings------------
  # Interactive bash hands over to fish; that part lives in ../fish/default.nix.
  programs.bash = {
    enable = true;
    shellAliases = {
      ll = "ls -l";
      la = "ls -A";
      ls = "ls -A --color=tty";
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      "....." = "cd ../../../..";
    };
  };
}
