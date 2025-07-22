{ pkgs }:
{
  programs.bash.initExtra = ''
    if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
    then
      shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
      exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
    fi
  '';
  programs.fish = {
    functions = {
      d = ''
        if test (count $argv) -eq 0
            echo "Usage: detach <command> [args ...]"
            return 1
        end
        echo "Detaching command: $argv"
        nohup $argv > /dev/null & disown; and exit
      '';
    };
    enable = true;
    shellAliases = {
      ll = "ls -l";
      la = "ls -A";
      ls = "ls -A --color=tty";
      nvi = "vi";
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      "....." = "cd ../../../..";
    };
  };
}
