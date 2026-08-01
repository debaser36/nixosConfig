{ pkgs, ... }: {
  #-------------Bash settings------------
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
    bashrcExtra = ''
      export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin:$HOME/.npm-global/bin"
    '';

    initExtra = ''
      if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" \
        && -z ''${BASH_EXECUTION_STRING} \
        && -t 1 ]]
      then
        shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
        exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
      fi
    '';
  };
}
