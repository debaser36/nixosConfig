{
  #-------------Bash settings------------
	programs.bash.enable = true;
	programs.bash.shellAliases = {
		ll = "ls -l";
		la = "ls -A";
		ls = "ls -A --color=tty";
	};
	programs.bash.bashrcExtra = "export PATH=\"$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin\"";
}